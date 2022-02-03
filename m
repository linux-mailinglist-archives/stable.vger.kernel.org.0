Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFC34A8F17
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354443AbiBCUmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355748AbiBCUjF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:39:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65BCC061760;
        Thu,  3 Feb 2022 12:36:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73CB3B835AD;
        Thu,  3 Feb 2022 20:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B636C340F0;
        Thu,  3 Feb 2022 20:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920567;
        bh=e7++UKLnpHgdLY0wud0yHtptEMp6tU2m8lqkAWd9MCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RR8RBYATbPo2SKz72lF4FxmU+Ch/x+KvMu0pdmMWcCjxxqa+aOdhdqU7ap2qB6hY/
         +ypBEfh4RIILbVXMxHVNgfn0Wjh7qePfUwCFCQnsaWL5QB+jXA2u2EnLgOYELk2pmR
         UZ+0w6mVYbxoV8gF7L4P0SxoruD8i06eHayA9VXlL+Jts8AwQgPMkyBSte+cKgByqc
         i7KTuhSGXkfjRm95UJokENrCEhXubIjdvAX1MsqqN7XyqW+YLxOQ3w/x3sUPauy3xJ
         KCSagubD4bVs7uK+9g2XE2KPBUYRKLpVh/cq8fMmiR6dmgF+6riGxlXVS+h1njEGGG
         O40U1TWuUxHQg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 12/15] PM: wakeup: simplify the output logic of pm_show_wakelocks()
Date:   Thu,  3 Feb 2022 15:35:42 -0500
Message-Id: <20220203203545.3879-12-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203545.3879-1-sashal@kernel.org>
References: <20220203203545.3879-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit c9d967b2ce40d71e968eb839f36c936b8a9cf1ea ]

The buffer handling in pm_show_wakelocks() is tricky, and hopefully
correct.  Ensure it really is correct by using sysfs_emit_at() which
handles all of the tricky string handling logic in a PAGE_SIZE buffer
for us automatically as this is a sysfs file being read from.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/wakelock.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/kernel/power/wakelock.c b/kernel/power/wakelock.c
index 105df4dfc7839..52571dcad768b 100644
--- a/kernel/power/wakelock.c
+++ b/kernel/power/wakelock.c
@@ -39,23 +39,20 @@ ssize_t pm_show_wakelocks(char *buf, bool show_active)
 {
 	struct rb_node *node;
 	struct wakelock *wl;
-	char *str = buf;
-	char *end = buf + PAGE_SIZE;
+	int len = 0;
 
 	mutex_lock(&wakelocks_lock);
 
 	for (node = rb_first(&wakelocks_tree); node; node = rb_next(node)) {
 		wl = rb_entry(node, struct wakelock, node);
 		if (wl->ws->active == show_active)
-			str += scnprintf(str, end - str, "%s ", wl->name);
+			len += sysfs_emit_at(buf, len, "%s ", wl->name);
 	}
-	if (str > buf)
-		str--;
 
-	str += scnprintf(str, end - str, "\n");
+	len += sysfs_emit_at(buf, len, "\n");
 
 	mutex_unlock(&wakelocks_lock);
-	return (str - buf);
+	return len;
 }
 
 #if CONFIG_PM_WAKELOCKS_LIMIT > 0
-- 
2.34.1

