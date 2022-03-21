Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 093D24E28F0
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 14:59:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348468AbiCUOBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 10:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349196AbiCUN7o (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 09:59:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96A8255B0;
        Mon, 21 Mar 2022 06:58:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5535D6125C;
        Mon, 21 Mar 2022 13:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63456C340E8;
        Mon, 21 Mar 2022 13:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647871096;
        bh=Iu6+8UKizmEfUSOoYi6/uV6d0fxVYQ5PqqCfF95FSwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=buYsdJXczLIr17MXuA+xJsLAeh2M7Pu0fOyOcMt7iwBpOqATJdRhfk/sup+Y/2Kja
         8lm151kozU8UzYT0uqhNZj2oGPQ8ruSFuFRjie9a1PLXMQqGrdDsxCTNFjpMgEH+MZ
         ahV2BnGh8LFogX8esEIYJA1DgAu7BWA8MxdiuO9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/17] atm: eni: Add check for dma_map_single
Date:   Mon, 21 Mar 2022 14:52:42 +0100
Message-Id: <20220321133217.340072563@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220321133217.148831184@linuxfoundation.org>
References: <20220321133217.148831184@linuxfoundation.org>
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
index de52428b8833..4816db0553ef 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -1116,6 +1116,8 @@ DPRINTK("iovcnt = %d\n",skb_shinfo(skb)->nr_frags);
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



