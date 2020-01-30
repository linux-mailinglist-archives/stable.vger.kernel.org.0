Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E92414E12A
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:42:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730270AbgA3Sl7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:41:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:50058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730286AbgA3Sl6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:41:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41C61205F4;
        Thu, 30 Jan 2020 18:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409717;
        bh=N3f/o6OEfEATW92CUQoPs/h5ohxXzCma9kMlBT4/vuc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=khkk7Y0vtS2YfqCzQ//QG7BiQ4wrd42qXO8KAjIDJ7aAXweR75ghdFWbZSS6rJKYC
         jKQTZlVyUiuh1sbHpMWTg9tRKRcwRQ3kL7gTd0T8tRoNdizPzeb1oYf2BmYy6jJMTn
         QRCUiM0v07yINWOxWJ4+qOWP/CsrAmxJzun+x65E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 41/56] net: socionext: fix xdp_result initialization in netsec_process_rx
Date:   Thu, 30 Jan 2020 19:38:58 +0100
Message-Id: <20200130183616.528818741@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.849023566@linuxfoundation.org>
References: <20200130183608.849023566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 02758cb6dac31a2b4bd9e535cffbe718acd46404 ]

Fix xdp_result initialization in netsec_process_rx in order to not
increase rx counters if there is no bpf program attached to the xdp hook
and napi_gro_receive returns GRO_DROP

Fixes: ba2b232108d3c ("net: netsec: add XDP support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/socionext/netsec.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -942,8 +942,8 @@ static int netsec_process_rx(struct nets
 		struct netsec_de *de = dring->vaddr + (DESC_SZ * idx);
 		struct netsec_desc *desc = &dring->desc[idx];
 		struct page *page = virt_to_page(desc->addr);
+		u32 xdp_result = NETSEC_XDP_PASS;
 		struct sk_buff *skb = NULL;
-		u32 xdp_result = XDP_PASS;
 		u16 pkt_len, desc_len;
 		dma_addr_t dma_handle;
 		struct xdp_buff xdp;


