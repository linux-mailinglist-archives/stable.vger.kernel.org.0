Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D86A4E288E
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348455AbiCUOAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348968AbiCUN6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:58:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820C116068F;
        Mon, 21 Mar 2022 06:56:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A98C2B81674;
        Mon, 21 Mar 2022 13:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05612C340ED;
        Mon, 21 Mar 2022 13:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871009;
        bh=R1mmyF3W66JcYlAvZpdgAFCo4BLEqOwTQIP0aFl0cmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xAmYFkcXoedm4ZPHPRPDMZDyAIFxbh959xhdPylZZ3r72dJ3EmEINi3wbcJx6WpaK
         d81U9rGf0n+iqLxBegjBpeY2zpKQVLnHFPSs79D5kDmiLA8dEs4OiQRO9CqWEC16OT
         My5DRnbl0gYXyxXPJhqRnII2gXL9DK3wrnjLmS3E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 49/57] atm: eni: Add check for dma_map_single
Date:   Mon, 21 Mar 2022 14:52:30 +0100
Message-Id: <20220321133223.409660032@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133221.984120927@linuxfoundation.org>
References: <20220321133221.984120927@linuxfoundation.org>
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
index 1409d48affb7..f256aeeac1b3 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -1114,6 +1114,8 @@ DPRINTK("iovcnt = %d\n",skb_shinfo(skb)->nr_frags);
 	}
 	paddr = dma_map_single(&eni_dev->pci_dev->dev,skb->data,skb->len,
 			       DMA_TO_DEVICE);
+	if (dma_mapping_error(&eni_dev->pci_dev->dev, paddr))
+		return enq_next;
 	ENI_PRV_PADDR(skb) = paddr;
 	/* prepare DMA queue entries */
 	j = 0;
-- 
2.34.1



