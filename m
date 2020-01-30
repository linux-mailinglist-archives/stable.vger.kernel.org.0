Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 915A314E153
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730617AbgA3Sn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:43:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:52130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730613AbgA3Sn1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:43:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BB9AF20702;
        Thu, 30 Jan 2020 18:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409807;
        bh=HbLFfeGQCXCLi8mrUB2mh0jjKcgAoECwm3vUCTiKN2c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yd/pzMyoovoKCSEpcgOUsiaY7W4XMOlEixeJbI4P0wWL0odz9amw+eFkTVW+GK6et
         QaUu+AYY5G6zr/Yj9EA3kTggOYVkwjZoSl5FlQ8MVSODVuSjHnc802Fakld18zFPCe
         IY0HNNRxPkTojtmarxIgJYCflF0xaTmP9lMQ46wE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 039/110] net: socionext: fix xdp_result initialization in netsec_process_rx
Date:   Thu, 30 Jan 2020 19:38:15 +0100
Message-Id: <20200130183619.986884058@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183613.810054545@linuxfoundation.org>
References: <20200130183613.810054545@linuxfoundation.org>
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
@@ -941,8 +941,8 @@ static int netsec_process_rx(struct nets
 		struct netsec_de *de = dring->vaddr + (DESC_SZ * idx);
 		struct netsec_desc *desc = &dring->desc[idx];
 		struct page *page = virt_to_page(desc->addr);
+		u32 xdp_result = NETSEC_XDP_PASS;
 		struct sk_buff *skb = NULL;
-		u32 xdp_result = XDP_PASS;
 		u16 pkt_len, desc_len;
 		dma_addr_t dma_handle;
 		struct xdp_buff xdp;


