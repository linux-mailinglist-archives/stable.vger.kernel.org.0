Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB484E941B
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 13:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241057AbiC1L0H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 07:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241698AbiC1LYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 07:24:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795CA55BEA;
        Mon, 28 Mar 2022 04:21:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3EA82B80ED8;
        Mon, 28 Mar 2022 11:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC68C340EC;
        Mon, 28 Mar 2022 11:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648466500;
        bh=hOasPOHGeymPIR9CFGjXih8tpW9A6b/MeZtf9fDUetE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M5ne4eXhiwOuMuREOc5wvnIhEt0J7MygTeEmLkI6Zi3amc55DRJJCU9k/FM8w8ZEx
         jJxSkzUU2P4a/NNTBi7Q38A7nSpbNAuX/N8MCALAjRjS2DhaIiWcAmULhz+DVCk7Nf
         dMWbuOJlPbir/MSLsxJI/lmnTIAhXfZXm3ykM8wwvEpWsVij8U0osQQAdABZUivl7g
         1tGV91RL3iMZDgWWa8VrfMlPdxu4VCumi49Xg1xJgiBn8Otv3bYaQVb2KgJhjvvFyT
         8frrwt8U/DLArg76NZthmKdelo6fDoX5qwLwzrPWXBWjwbbaJ5pyXJy6elnSOFElV+
         v8LMuNMDQKhAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Alexander Popov <alex.popov@linux.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-hardening@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 04/29] gcc-plugins/stackleak: Exactly match strings instead of prefixes
Date:   Mon, 28 Mar 2022 07:21:06 -0400
Message-Id: <20220328112132.1555683-4-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220328112132.1555683-1-sashal@kernel.org>
References: <20220328112132.1555683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 27e9faf415dbf94af19b9c827842435edbc1fbbc ]

Since STRING_CST may not be NUL terminated, strncmp() was used for check
for equality. However, this may lead to mismatches for longer section
names where the start matches the tested-for string. Test for exact
equality by checking for the presences of NUL termination.

Cc: Alexander Popov <alex.popov@linux.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gcc-plugins/stackleak_plugin.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/scripts/gcc-plugins/stackleak_plugin.c b/scripts/gcc-plugins/stackleak_plugin.c
index e9db7dcb3e5f..b04aa8e91a41 100644
--- a/scripts/gcc-plugins/stackleak_plugin.c
+++ b/scripts/gcc-plugins/stackleak_plugin.c
@@ -429,6 +429,23 @@ static unsigned int stackleak_cleanup_execute(void)
 	return 0;
 }
 
+/*
+ * STRING_CST may or may not be NUL terminated:
+ * https://gcc.gnu.org/onlinedocs/gccint/Constant-expressions.html
+ */
+static inline bool string_equal(tree node, const char *string, int length)
+{
+	if (TREE_STRING_LENGTH(node) < length)
+		return false;
+	if (TREE_STRING_LENGTH(node) > length + 1)
+		return false;
+	if (TREE_STRING_LENGTH(node) == length + 1 &&
+	    TREE_STRING_POINTER(node)[length] != '\0')
+		return false;
+	return !memcmp(TREE_STRING_POINTER(node), string, length);
+}
+#define STRING_EQUAL(node, str)	string_equal(node, str, strlen(str))
+
 static bool stackleak_gate(void)
 {
 	tree section;
@@ -438,13 +455,13 @@ static bool stackleak_gate(void)
 	if (section && TREE_VALUE(section)) {
 		section = TREE_VALUE(TREE_VALUE(section));
 
-		if (!strncmp(TREE_STRING_POINTER(section), ".init.text", 10))
+		if (STRING_EQUAL(section, ".init.text"))
 			return false;
-		if (!strncmp(TREE_STRING_POINTER(section), ".devinit.text", 13))
+		if (STRING_EQUAL(section, ".devinit.text"))
 			return false;
-		if (!strncmp(TREE_STRING_POINTER(section), ".cpuinit.text", 13))
+		if (STRING_EQUAL(section, ".cpuinit.text"))
 			return false;
-		if (!strncmp(TREE_STRING_POINTER(section), ".meminit.text", 13))
+		if (STRING_EQUAL(section, ".meminit.text"))
 			return false;
 	}
 
-- 
2.34.1

