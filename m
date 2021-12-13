Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B04347294E
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244744AbhLMKTe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:19:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243961AbhLMKPB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:15:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68E13C0D9420;
        Mon, 13 Dec 2021 01:55:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D809B80D1F;
        Mon, 13 Dec 2021 09:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1A6C34601;
        Mon, 13 Dec 2021 09:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389315;
        bh=CVqEleoQJCV/cZRQTW6FYeyD6t7B7mZI9DtCWXSef78=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHZ9Py0Kw+AM7Ht8CpLA4ZPCu8sBP61oRaNlMRhRW/e9ZxbUU8ZT7EbIQOmRojPu0
         72C748TxRHFxb9U1AwbM9eGueQOouWgt7gMhwRyQj25IG1gz7/b6ymlJ2V1iwDHdCr
         hqnNQbvfcSKivsntHjQL5noKMCfCKDwYgPwmPaR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Louis Amas <louis.amas@eho.link>,
        Emmanuel Deloget <emmanuel.deloget@eho.link>,
        Marcin Wojtas <mw@semihalf.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 056/171] net: mvpp2: fix XDP rx queues registering
Date:   Mon, 13 Dec 2021 10:29:31 +0100
Message-Id: <20211213092946.968144103@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Louis Amas <louis.amas@eho.link>

commit a50e659b2a1be14784e80f8492aab177e67c53a2 upstream.

The registration of XDP queue information is incorrect because the
RX queue id we use is invalid. When port->id == 0 it appears to works
as expected yet it's no longer the case when port->id != 0.

The problem arised while using a recent kernel version on the
MACCHIATOBin. This board has several ports:
 * eth0 and eth1 are 10Gbps interfaces ; both ports has port->id == 0;
 * eth2 is a 1Gbps interface with port->id != 0.

Code from xdp-tutorial (more specifically advanced03-AF_XDP) was used
to test packet capture and injection on all these interfaces. The XDP
kernel was simplified to:

	SEC("xdp_sock")
	int xdp_sock_prog(struct xdp_md *ctx)
	{
		int index = ctx->rx_queue_index;

		/* A set entry here means that the correspnding queue_id
		* has an active AF_XDP socket bound to it. */
		if (bpf_map_lookup_elem(&xsks_map, &index))
			return bpf_redirect_map(&xsks_map, index, 0);

		return XDP_PASS;
	}

Starting the program using:

	./af_xdp_user -d DEV

Gives the following result:

 * eth0 : ok
 * eth1 : ok
 * eth2 : no capture, no injection

Investigating the issue shows that XDP rx queues for eth2 are wrong:
XDP expects their id to be in the range [0..3] but we found them to be
in the range [32..35].

Trying to force rx queue ids using:

	./af_xdp_user -d eth2 -Q 32

fails as expected (we shall not have more than 4 queues).

When we register the XDP rx queue information (using
xdp_rxq_info_reg() in function mvpp2_rxq_init()) we tell it to use
rxq->id as the queue id. This value is computed as:

	rxq->id = port->id * max_rxq_count + queue_id

where max_rxq_count depends on the device version. In the MACCHIATOBin
case, this value is 32, meaning that rx queues on eth2 are numbered
from 32 to 35 - there are four of them.

Clearly, this is not the per-port queue id that XDP is expecting:
it wants a value in the range [0..3]. It shall directly use queue_id
which is stored in rxq->logic_rxq -- so let's use that value instead.

rxq->id is left untouched ; its value is indeed valid but it should
not be used in this context.

This is consistent with the remaining part of the code in
mvpp2_rxq_init().

With this change, packet capture is working as expected on all the
MACCHIATOBin ports.

Fixes: b27db2274ba8 ("mvpp2: use page_pool allocator")
Signed-off-by: Louis Amas <louis.amas@eho.link>
Signed-off-by: Emmanuel Deloget <emmanuel.deloget@eho.link>
Reviewed-by: Marcin Wojtas <mw@semihalf.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Link: https://lore.kernel.org/r/20211207143423.916334-1-louis.amas@eho.link
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2960,11 +2960,11 @@ static int mvpp2_rxq_init(struct mvpp2_p
 	mvpp2_rxq_status_update(port, rxq->id, 0, rxq->size);
 
 	if (priv->percpu_pools) {
-		err = xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, rxq->id, 0);
+		err = xdp_rxq_info_reg(&rxq->xdp_rxq_short, port->dev, rxq->logic_rxq, 0);
 		if (err < 0)
 			goto err_free_dma;
 
-		err = xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, rxq->id, 0);
+		err = xdp_rxq_info_reg(&rxq->xdp_rxq_long, port->dev, rxq->logic_rxq, 0);
 		if (err < 0)
 			goto err_unregister_rxq_short;
 


