Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97EC84A8DAF
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354499AbiBCUcm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:32:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354509AbiBCUbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:31:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595A2C06176C;
        Thu,  3 Feb 2022 12:31:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1BEBBB835AA;
        Thu,  3 Feb 2022 20:31:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E3AC36AE2;
        Thu,  3 Feb 2022 20:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920280;
        bh=e7++UKLnpHgdLY0wud0yHtptEMp6tU2m8lqkAWd9MCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eaNn7ymt7BQ9v/Jsuxz4KPOClIRSKwRk1kdY0OmfmAcaIG5nLDBDqzmghdUYDWoRo
         h0B4ffGZC1qj9uoA0CoyJ0BdBtzgCCf9UxdLsFL7IRMQ2d7DT0IBopWWZc4/CYQMaA
         liOPDK1h7pXGieetkByOoYKz9T/B895REmlx3MEQOnl2NrgmDmXLzd06dYzs/vcz0P
         JYys8ItyCz5DHx0z8zyVuIBr1dmFRWg/cPD7emZ+Qqpj/xL7LP7jS+jw65VQQ85MZ0
         OTqiIya0q4GzP0iO2hSdt3wWBddP/HhILA9xcQfGJ0qQM4i8cWqSBnovLeovIJDcOA
         X5PTthMF14scg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        pavel@ucw.cz, len.brown@intel.com, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 36/52] PM: wakeup: simplify the output logic of pm_show_wakelocks()
Date:   Thu,  3 Feb 2022 15:29:30 -0500
Message-Id: <20220203202947.2304-36-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
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

