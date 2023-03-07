Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 124B66AF384
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231503AbjCGTF7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:05:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231645AbjCGTFo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:05:44 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E01EBCFD9
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:51:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E05BBCE1C82
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87A6C433EF;
        Tue,  7 Mar 2023 18:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678215051;
        bh=mtwwF1p3cwQQwwydNl4TwINE95vZ62i3LE2XQ20Zj+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vkxyD4PLRXyRF5VY/N8GhsrbSbb3RY3L+0Yy7TMC/EEN0AtXFT2H/mVFAiFkUgIUF
         hdGITounggohmgFPEs9D2Omq6uVt9tHyLrF4ZdiJ8BqLNvxTWD+YiGFGEzv8H24kRH
         XnuQjb7XGfWY3ga8RT13swNJS2DO8jVijkAJu2T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Qi Zheng <zhengqi.arch@bytedance.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/567] OPP: fix error checking in opp_migrate_dentry()
Date:   Tue,  7 Mar 2023 17:57:52 +0100
Message-Id: <20230307165911.786038602@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qi Zheng <zhengqi.arch@bytedance.com>

[ Upstream commit eca4c0eea53432ec4b711b2a8ad282cbad231b4f ]

Since commit ff9fb72bc077 ("debugfs: return error values,
not NULL") changed return value of debugfs_rename() in
error cases from %NULL to %ERR_PTR(-ERROR), we should
also check error values instead of NULL.

Fixes: ff9fb72bc077 ("debugfs: return error values, not NULL")
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/debugfs.c b/drivers/opp/debugfs.c
index b5f2f9f393926..9eb71f47487b2 100644
--- a/drivers/opp/debugfs.c
+++ b/drivers/opp/debugfs.c
@@ -209,7 +209,7 @@ static void opp_migrate_dentry(struct opp_device *opp_dev,
 
 	dentry = debugfs_rename(rootdir, opp_dev->dentry, rootdir,
 				opp_table->dentry_name);
-	if (!dentry) {
+	if (IS_ERR(dentry)) {
 		dev_err(dev, "%s: Failed to rename link from: %s to %s\n",
 			__func__, dev_name(opp_dev->dev), dev_name(dev));
 		return;
-- 
2.39.2



