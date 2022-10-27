Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3CA860FDC8
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 18:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbiJ0Q7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 12:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236749AbiJ0Q7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 12:59:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78EFB17D28B
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 09:59:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2ECD9B82714
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 16:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C098C433D6;
        Thu, 27 Oct 2022 16:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666889938;
        bh=JtpIYIMkexgB07OMO+X3Sg3lhexb866ZbWLaBgvsPt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K3JuVOqfUuxKA+arLIIj9b3X7yG99nOVgWzEKUSoFiEIe2bKHYjqXyf75GP1KiCts
         9RLsXNJ9pbJ08ekqZU02YEGUulx6IclI5UhnOY0/9pj5Hng3C/MN8L4XX8/B+2louM
         KXdnHniLxvSmu63dq/67PMLEAK/c2mEj3vels9Ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yang Yingliang <yangyingliang@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 54/94] net: ethernet: mtk_eth_wed: add missing of_node_put()
Date:   Thu, 27 Oct 2022 18:54:56 +0200
Message-Id: <20221027165059.356238195@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
References: <20221027165057.208202132@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit e0bb4659e235770e6f53b3692e958591f49448f5 ]

The device_node pointer returned by of_parse_phandle() with refcount
incremented, when finish using it, the refcount need be decreased.

Fixes: 804775dfc288 ("net: ethernet: mtk_eth_soc: add support for Wireless Ethernet Dispatch (WED)")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed.c b/drivers/net/ethernet/mediatek/mtk_wed.c
index fff2b745587e..614147ad6116 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed.c
@@ -808,7 +808,7 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 
 	pdev = of_find_device_by_node(np);
 	if (!pdev)
-		return;
+		goto err_of_node_put;
 
 	get_device(&pdev->dev);
 	irq = platform_get_irq(pdev, 0);
@@ -861,6 +861,8 @@ void mtk_wed_add_hw(struct device_node *np, struct mtk_eth *eth,
 	mutex_unlock(&hw_lock);
 err_put_device:
 	put_device(&pdev->dev);
+err_of_node_put:
+	of_node_put(np);
 }
 
 void mtk_wed_exit(void)
@@ -881,6 +883,7 @@ void mtk_wed_exit(void)
 		hw_list[i] = NULL;
 		debugfs_remove(hw->debugfs_dir);
 		put_device(hw->dev);
+		of_node_put(hw->node);
 		kfree(hw);
 	}
 }
-- 
2.35.1



