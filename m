Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 980984F34EF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242041AbiDEIga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239616AbiDEIUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B730206;
        Tue,  5 Apr 2022 01:17:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40B53B81A32;
        Tue,  5 Apr 2022 08:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC861C385A1;
        Tue,  5 Apr 2022 08:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146665;
        bh=hOasPOHGeymPIR9CFGjXih8tpW9A6b/MeZtf9fDUetE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KIPgJo39hNDl5k/MQ2uJcYBnPXZl8culwnG/eCyueGWw4uQ1OchW5IFQnoDunCSXE
         3gCVVUMCCOxCXvcwwaAMBdkBIQXdW4tbGFTQa3mIc05Iv22ytwSBU13OsPOac/b5AV
         VhuRvFriGeqDdydEjdj5mm6iRXKUcKtGTnkt2J2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Popov <alex.popov@linux.com>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0837/1126] gcc-plugins/stackleak: Exactly match strings instead of prefixes
Date:   Tue,  5 Apr 2022 09:26:24 +0200
Message-Id: <20220405070432.124437321@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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



