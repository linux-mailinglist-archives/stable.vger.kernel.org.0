Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECE34A4139
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244149AbiAaLDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:03:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48454 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244628AbiAaLBo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:01:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8912EB82A5F;
        Mon, 31 Jan 2022 11:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AC2C340E8;
        Mon, 31 Jan 2022 11:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626902;
        bh=y8gnLAmebI/LsWI7Qf1t1rVMg1fjqFljK3zoLhrq18I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKGj8WpwVyM976ouBf6FOBXAwp9zugjCeXYYXHEhnunveJrfXzU6GjeVXP7fPoxiq
         J6Uv70DGwSNwq7Is/BfGx7ckvZfmUg0U8x2rgdcsJvydQtcDOdOiGVh3NEjlOSP0ES
         VvS/3ZXq/RzaNnlafnJxHU13XtheJrzxepsyCyPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 012/100] PM: wakeup: simplify the output logic of pm_show_wakelocks()
Date:   Mon, 31 Jan 2022 11:55:33 +0100
Message-Id: <20220131105220.865219539@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit c9d967b2ce40d71e968eb839f36c936b8a9cf1ea upstream.

The buffer handling in pm_show_wakelocks() is tricky, and hopefully
correct.  Ensure it really is correct by using sysfs_emit_at() which
handles all of the tricky string handling logic in a PAGE_SIZE buffer
for us automatically as this is a sysfs file being read from.

Reviewed-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/power/wakelock.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

--- a/kernel/power/wakelock.c
+++ b/kernel/power/wakelock.c
@@ -39,23 +39,20 @@ ssize_t pm_show_wakelocks(char *buf, boo
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


