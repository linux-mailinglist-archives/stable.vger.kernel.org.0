Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D7B470617
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 17:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237489AbhLJQsr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 11:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233117AbhLJQsr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 11:48:47 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD34C061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 08:45:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 10884CE2C16
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 16:45:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB48DC00446;
        Fri, 10 Dec 2021 16:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639154708;
        bh=0hZ6hn3eC4I7yLrSJ7wFoull3wzCL6W+IVj2m1WMU14=;
        h=Subject:To:Cc:From:Date:From;
        b=UByx+r/XrpzCDNq4ZFEyH/r9EPASi5S1dqLAskMs1rw8gzBeEUL+1luRP/ioZtAZ4
         eMI3NssGUF7jAFeomHoo7VtuybryDBzcoU/YvcUmM6T8whAFdKpxq9lHMIOkHlRMsw
         i3rlJRRPfaAcO++jN1Te8taS0ZawqbWwFSLOXyBY=
Subject: FAILED: patch "[PATCH] net: mvpp2: fix XDP rx queues registering" failed to apply to 5.10-stable tree
To:     louis.amas@eho.link, brouer@redhat.com, emmanuel.deloget@eho.link,
        john.fastabend@gmail.com, kuba@kernel.org, mw@semihalf.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 10 Dec 2021 17:45:05 +0100
Message-ID: <163915470517181@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a50e659b2a1be14784e80f8492aab177e67c53a2 Mon Sep 17 00:00:00 2001
From: Louis Amas <louis.amas@eho.link>
Date: Tue, 7 Dec 2021 15:34:22 +0100
Subject: [PATCH] net: mvpp2: fix XDP rx queues registering

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

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 6480696c979b..6da8a595026b 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -2960,11 +2960,11 @@ static int mvpp2_rxq_init(struct mvpp2_port *port,
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
 

