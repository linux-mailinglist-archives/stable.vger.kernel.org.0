Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4B86C17B5
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:16:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232562AbjCTPQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232494AbjCTPQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:16:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F7C22F049
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:11:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 638D8614CA
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:11:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73CF5C433EF;
        Mon, 20 Mar 2023 15:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325083;
        bh=UhbWfDo4aa049H3Fc/KzDMnX6UzczZvujkPWPefrYfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EJEGeuvEE9wrwwJXefoLLBN+8u/mj2pMT0P3R/5qUSVoBdPoIplwnUmE42R2m4PEn
         Sid9K7U9FRyFPoQ/eQ94KlOmhtePD5MujlPubv4trF//FRXQZVlQS2rxFA4nZnfZWt
         LOBbX72s5/LuY/GIZeHybksVqJiiO6aYjNxz8JAM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <error27@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 005/211] fbdev: chipsfb: Fix error codes in chipsfb_pci_init()
Date:   Mon, 20 Mar 2023 15:52:20 +0100
Message-Id: <20230320145513.524234003@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 77bc762451c2dc72bdbea07b857c916c9e7f4952 ]

The error codes are not set on these error paths.

Fixes: 145eed48de27 ("fbdev: Remove conflicting devices on PCI bus")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/Y/yG+sm2mhdJeTZW@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/chipsfb.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/video/fbdev/chipsfb.c b/drivers/video/fbdev/chipsfb.c
index cc37ec3f8fc1f..7799d52a651f3 100644
--- a/drivers/video/fbdev/chipsfb.c
+++ b/drivers/video/fbdev/chipsfb.c
@@ -358,16 +358,21 @@ static int chipsfb_pci_init(struct pci_dev *dp, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	if (pci_enable_device(dp) < 0) {
+	rc = pci_enable_device(dp);
+	if (rc < 0) {
 		dev_err(&dp->dev, "Cannot enable PCI device\n");
 		goto err_out;
 	}
 
-	if ((dp->resource[0].flags & IORESOURCE_MEM) == 0)
+	if ((dp->resource[0].flags & IORESOURCE_MEM) == 0) {
+		rc = -ENODEV;
 		goto err_disable;
+	}
 	addr = pci_resource_start(dp, 0);
-	if (addr == 0)
+	if (addr == 0) {
+		rc = -ENODEV;
 		goto err_disable;
+	}
 
 	p = framebuffer_alloc(0, &dp->dev);
 	if (p == NULL) {
@@ -417,7 +422,8 @@ static int chipsfb_pci_init(struct pci_dev *dp, const struct pci_device_id *ent)
 
 	init_chips(p, addr);
 
-	if (register_framebuffer(p) < 0) {
+	rc = register_framebuffer(p);
+	if (rc < 0) {
 		dev_err(&dp->dev,"C&T 65550 framebuffer failed to register\n");
 		goto err_unmap;
 	}
-- 
2.39.2



