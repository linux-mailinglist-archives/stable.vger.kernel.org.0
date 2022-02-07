Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53B44ABA63
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:28:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383648AbiBGLXV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:23:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235197AbiBGLKr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:10:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32830C043189;
        Mon,  7 Feb 2022 03:10:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 889B4B80EE8;
        Mon,  7 Feb 2022 11:10:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940E7C004E1;
        Mon,  7 Feb 2022 11:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232244;
        bh=fWA7+yWKegMS40cpvXEP1/eohdqQT4jfg/9bqF05LxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GaadPUriA8fZrnnPXJ6+/obK5xARRrwdbmgVrEVN58qgY0keA0atxY0k33AHjJCSp
         /xUUB+9ZbPMq9AQ/DcLkisTGeYcaSwdGaQFaHs7Bg8IV6GMAoLrj1vCwqQgcTwiIOB
         xwwdnxtq9Ttq3UnKVA8OIwZcULoCWcmfXoyTn+Wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.14 06/69] PM: wakeup: simplify the output logic of pm_show_wakelocks()
Date:   Mon,  7 Feb 2022 12:05:28 +0100
Message-Id: <20220207103755.813910177@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103755.604121441@linuxfoundation.org>
References: <20220207103755.604121441@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
 kernel/power/wakelock.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/kernel/power/wakelock.c
+++ b/kernel/power/wakelock.c
@@ -39,23 +39,19 @@ ssize_t pm_show_wakelocks(char *buf, boo
 {
 	struct rb_node *node;
 	struct wakelock *wl;
-	char *str = buf;
-	char *end = buf + PAGE_SIZE;
+	int len = 0;
 
 	mutex_lock(&wakelocks_lock);
 
 	for (node = rb_first(&wakelocks_tree); node; node = rb_next(node)) {
 		wl = rb_entry(node, struct wakelock, node);
 		if (wl->ws.active == show_active)
-			str += scnprintf(str, end - str, "%s ", wl->name);
+			len += sysfs_emit_at(buf, len, "%s ", wl->name);
 	}
-	if (str > buf)
-		str--;
-
-	str += scnprintf(str, end - str, "\n");
+	len += sysfs_emit_at(buf, len, "\n");
 
 	mutex_unlock(&wakelocks_lock);
-	return (str - buf);
+	return len;
 }
 
 #if CONFIG_PM_WAKELOCKS_LIMIT > 0


