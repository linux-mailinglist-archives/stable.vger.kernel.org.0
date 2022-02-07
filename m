Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1883A4ABA68
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383664AbiBGLXX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:23:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355277AbiBGLIQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:08:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D5E2C043181;
        Mon,  7 Feb 2022 03:08:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19CBB61261;
        Mon,  7 Feb 2022 11:08:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF30BC004E1;
        Mon,  7 Feb 2022 11:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232095;
        bh=i4kxKJp73ZiiAxDUVelR4/cBG+CtNNOMx/SDUQqHhAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hisNyPet+uc9ucP7DHfMAylgnaAljy9RczUD/IDl9HDADHHZThSTE0y57LHFj/pSF
         5JyXP/AtyD+yP6SAUa/EkVBLT5H2z236suBN7Bsvklj8xqMW/CKDP3b0ktIjGIxZUi
         OgPJeLSAyTcYgf5dVHo8YWV4WJexYdYFGatc7018=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.9 07/48] PM: wakeup: simplify the output logic of pm_show_wakelocks()
Date:   Mon,  7 Feb 2022 12:05:40 +0100
Message-Id: <20220207103752.579589466@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103752.341184175@linuxfoundation.org>
References: <20220207103752.341184175@linuxfoundation.org>
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
@@ -38,23 +38,19 @@ ssize_t pm_show_wakelocks(char *buf, boo
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


