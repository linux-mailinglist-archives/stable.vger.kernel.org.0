Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3C5E66C0ED
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:06:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231872AbjAPOGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:06:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbjAPOFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:05:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46CD32197F;
        Mon, 16 Jan 2023 06:03:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4A5E60FD8;
        Mon, 16 Jan 2023 14:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E844C43392;
        Mon, 16 Jan 2023 14:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877793;
        bh=IbuQFBkpWU0KOypHqfp9y1VKkrrZt+r+mVeye6h3CGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CrjeTB5GE2WooanInmuOa3rwwtzbxZFEpDj25ZRhjc8DkcWpZc+rCz4Mpu/edjooC
         l4Ez8Mn2eeyyjWKc7h9AI1T2kbvxC65JBYO22Rf6/5AM/kY3bi7NtTXIYmv1uNjnxF
         OG4SAjM/EqIf6K8G/YZRUG8ftal7zInbgYkEYlGtLTwE3wZjyYWdkQbe+km8PnkTA8
         z4+QjS9Z24/fB9O6o5JyCReXobmUPlurQlGy2HzregNb2V/t26hB7NkA+rlyzL5AjI
         Rbt/y2gDw/ChKkRVDyIol0x4FDvA2DVgAm1P8NzvrVca8FiE9/tvMNk00aeGdL94HA
         wUrnoYgjmgrjQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Warner Losh <imp@bsdimp.com>, Willy Tarreau <w@1wt.eu>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.1 28/53] tools/nolibc: Fix S_ISxxx macros
Date:   Mon, 16 Jan 2023 09:01:28 -0500
Message-Id: <20230116140154.114951-28-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Warner Losh <imp@bsdimp.com>

[ Upstream commit 16f5cea74179b5795af7ce359971f5128d10f80e ]

The mode field has the type encoded as an value in a field, not as a bit
mask. Mask the mode with S_IFMT instead of each type to test. Otherwise,
false positives are possible: eg S_ISDIR will return true for block
devices because S_IFDIR = 0040000 and S_IFBLK = 0060000 since mode is
masked with S_IFDIR instead of S_IFMT. These macros now match the
similar definitions in tools/include/uapi/linux/stat.h.

Signed-off-by: Warner Losh <imp@bsdimp.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/types.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/include/nolibc/types.h b/tools/include/nolibc/types.h
index 300e0ff1cd58..f1d64fca7cf0 100644
--- a/tools/include/nolibc/types.h
+++ b/tools/include/nolibc/types.h
@@ -26,13 +26,13 @@
 #define S_IFSOCK       0140000
 #define S_IFMT         0170000
 
-#define S_ISDIR(mode)  (((mode) & S_IFDIR)  == S_IFDIR)
-#define S_ISCHR(mode)  (((mode) & S_IFCHR)  == S_IFCHR)
-#define S_ISBLK(mode)  (((mode) & S_IFBLK)  == S_IFBLK)
-#define S_ISREG(mode)  (((mode) & S_IFREG)  == S_IFREG)
-#define S_ISFIFO(mode) (((mode) & S_IFIFO)  == S_IFIFO)
-#define S_ISLNK(mode)  (((mode) & S_IFLNK)  == S_IFLNK)
-#define S_ISSOCK(mode) (((mode) & S_IFSOCK) == S_IFSOCK)
+#define S_ISDIR(mode)  (((mode) & S_IFMT) == S_IFDIR)
+#define S_ISCHR(mode)  (((mode) & S_IFMT) == S_IFCHR)
+#define S_ISBLK(mode)  (((mode) & S_IFMT) == S_IFBLK)
+#define S_ISREG(mode)  (((mode) & S_IFMT) == S_IFREG)
+#define S_ISFIFO(mode) (((mode) & S_IFMT) == S_IFIFO)
+#define S_ISLNK(mode)  (((mode) & S_IFMT) == S_IFLNK)
+#define S_ISSOCK(mode) (((mode) & S_IFMT) == S_IFSOCK)
 
 /* dirent types */
 #define DT_UNKNOWN     0x0
-- 
2.35.1

