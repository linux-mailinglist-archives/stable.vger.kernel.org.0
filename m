Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23F0A14E277
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:52:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730611AbgA3Sn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:43:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:52084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730606AbgA3SnZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:43:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BA9F20CC7;
        Thu, 30 Jan 2020 18:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580409804;
        bh=umTeR8oIiJjmU04XF6OMoKh/l1/mt83qwBM0dTA8Rd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+L2P7pj4TtTnHhM68FaAc7OOSWvntPJk9CXDgIiABDKxZzif5SXES9k/s5/ZZImr
         BP5ZDNUMAEZzudKa8axMiP/6rf2Vh4XneoaYhXB0+xuupn9HzP72VApmyqauatti9R
         kDgjgyEYdkTcgFiU742ZvmHmCeCPKq9lTB35jyw4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenzo Bianconi <lorenzo@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 038/110] net: socionext: fix possible user-after-free in netsec_process_rx
Date:   Thu, 30 Jan 2020 19:38:14 +0100
Message-Id: <20200130183619.890025567@linuxfoundation.org>
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

[ Upstream commit b5e82e3c89c78ee0407ea8e8087af5519b6c7bae ]

Fix possible use-after-free in in netsec_process_rx that can occurs if
the first packet is sent to the normal networking stack and the
following one is dropped by the bpf program attached to the xdp hook.
Fix the issue defining the skb pointer in the 'budget' loop

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
@@ -928,7 +928,6 @@ static int netsec_process_rx(struct nets
 	struct netsec_rx_pkt_info rx_info;
 	enum dma_data_direction dma_dir;
 	struct bpf_prog *xdp_prog;
-	struct sk_buff *skb = NULL;
 	u16 xdp_xmit = 0;
 	u32 xdp_act = 0;
 	int done = 0;
@@ -942,6 +941,7 @@ static int netsec_process_rx(struct nets
 		struct netsec_de *de = dring->vaddr + (DESC_SZ * idx);
 		struct netsec_desc *desc = &dring->desc[idx];
 		struct page *page = virt_to_page(desc->addr);
+		struct sk_buff *skb = NULL;
 		u32 xdp_result = XDP_PASS;
 		u16 pkt_len, desc_len;
 		dma_addr_t dma_handle;


