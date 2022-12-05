Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC24D6432C1
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234032AbiLET3Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:29:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234220AbiLET2u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:28:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7402A252
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:25:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F7A3B81181
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976B3C433C1;
        Mon,  5 Dec 2022 19:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268326;
        bh=/0U5v69+AfI76KNgSSgDmyGhOzuSRTqXmWjoBfRquWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eQpLbOgMXToFZEtR+C9r3LKmORbjPeVWnM0/cWyre+zWfVkAvh/7HHf0kUKoh0jYo
         Du39/JBysCstg3/Z3z3cPLxrJCvOKq50APIn9Fqg6MhdTAfT9KpjlAV/6/2h3Xh+Sl
         UrQmcpso1PtLX+Oj6H/1UqDwu273hFneTjaaAmgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Hai <wanghai38@huawei.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 033/124] e100: Fix possible use after free in e100_xmit_prepare
Date:   Mon,  5 Dec 2022 20:08:59 +0100
Message-Id: <20221205190809.385020547@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 45605c75c52c7ae7bfe902214343aabcfe5ba0ff ]

In e100_xmit_prepare(), if we can't map the skb, then return -ENOMEM, so
e100_xmit_frame() will return NETDEV_TX_BUSY and the upper layer will
resend the skb. But the skb is already freed, which will cause UAF bug
when the upper layer resends the skb.

Remove the harmful free.

Fixes: 5e5d49422dfb ("e100: Release skb when DMA mapping is failed in e100_xmit_prepare")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/e100.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 11a884aa5082..90a2ba20e902 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -1741,11 +1741,8 @@ static int e100_xmit_prepare(struct nic *nic, struct cb *cb,
 	dma_addr = dma_map_single(&nic->pdev->dev, skb->data, skb->len,
 				  DMA_TO_DEVICE);
 	/* If we can't map the skb, have the upper layer try later */
-	if (dma_mapping_error(&nic->pdev->dev, dma_addr)) {
-		dev_kfree_skb_any(skb);
-		skb = NULL;
+	if (dma_mapping_error(&nic->pdev->dev, dma_addr))
 		return -ENOMEM;
-	}
 
 	/*
 	 * Use the last 4 bytes of the SKB payload packet as the CRC, used for
-- 
2.35.1



