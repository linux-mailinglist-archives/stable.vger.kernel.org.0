Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1404E293C
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 15:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348831AbiCUOEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348685AbiCUOBs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 10:01:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424569D0D1;
        Mon, 21 Mar 2022 06:59:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D82D612EC;
        Mon, 21 Mar 2022 13:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A848C36AE5;
        Mon, 21 Mar 2022 13:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871159;
        bh=Plcu9F1XdHYz/hQLZ0JanjGcp2uWjHOnsKvUPjK2klk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qb74SmO+xvPxXhXaq6k4vdV/RlL5/F7d5sGEIsq+3c/tOnFlD0WlUBQ/5IxWSWX7n
         xDG2d/T/WaFBhz67OSSmzMBRSfqpWnsSQB40O1cWZnuHoI3xPT26+ml91UQEZrwKIR
         Ba8gI+bZFUS/kIxXib2KKIhmXGZ0F1Y4VLXJb+Xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 09/30] atm: eni: Add check for dma_map_single
Date:   Mon, 21 Mar 2022 14:52:39 +0100
Message-Id: <20220321133219.918430097@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133219.643490199@linuxfoundation.org>
References: <20220321133219.643490199@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 0f74b29a4f53627376cf5a5fb7b0b3fa748a0b2b ]

As the potential failure of the dma_map_single(),
it should be better to check it and return error
if fails.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/atm/eni.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index b574cce98dc3..9fcc49be499f 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -1112,6 +1112,8 @@ DPRINTK("iovcnt = %d\n",skb_shinfo(skb)->nr_frags);
 	skb_data3 = skb->data[3];
 	paddr = dma_map_single(&eni_dev->pci_dev->dev,skb->data,skb->len,
 			       DMA_TO_DEVICE);
+	if (dma_mapping_error(&eni_dev->pci_dev->dev, paddr))
+		return enq_next;
 	ENI_PRV_PADDR(skb) = paddr;
 	/* prepare DMA queue entries */
 	j = 0;
-- 
2.34.1



