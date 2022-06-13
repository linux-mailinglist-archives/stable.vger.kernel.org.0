Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19508549285
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358395AbiFMMzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355685AbiFMMxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:53:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C4B34672;
        Mon, 13 Jun 2022 04:12:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6FA1F60B60;
        Mon, 13 Jun 2022 11:12:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B25CC3411C;
        Mon, 13 Jun 2022 11:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118765;
        bh=Mix0VWXF4cyZnnNbsNPNkwbVHXLXIUNzPGfCx/ggO3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W5x0h8Q38zKxnBP0elSzgq/RAe80C+gvwZUkz7FY0p1k5G4DO3VOksLjE0sSl3Gtz
         Fs/y9vY3XsTdpCvUpfQLXe5fNQcP4kPN6e3syQB0VoWahfZHyjikryv08fJ1BX3zuK
         l2WbjlEklx2INHInOMc6Czf1oMjSUysVKV1z9+Qg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 005/247] lkdtm/bugs: Dont expect thread termination without CONFIG_UBSAN_TRAP
Date:   Mon, 13 Jun 2022 12:08:27 +0200
Message-Id: <20220613094923.069831631@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 8bfdbddd68249e0d8598777cca8249619ee51df0 ]

When you don't select CONFIG_UBSAN_TRAP, you get:

  # echo ARRAY_BOUNDS > /sys/kernel/debug/provoke-crash/DIRECT
[  102.265827] ================================================================================
[  102.278433] UBSAN: array-index-out-of-bounds in drivers/misc/lkdtm/bugs.c:342:16
[  102.287207] index 8 is out of range for type 'char [8]'
[  102.298722] ================================================================================
[  102.313712] lkdtm: FAIL: survived array bounds overflow!
[  102.318770] lkdtm: Unexpected! This kernel (5.16.0-rc1-s3k-dev-01884-g720dcf79314a ppc) was built with CONFIG_UBSAN_BOUNDS=y

It is not correct because when CONFIG_UBSAN_TRAP is not selected
you can't expect array bounds overflow to kill the thread.

Modify the logic so that when the kernel is built with
CONFIG_UBSAN_BOUNDS but without CONFIG_UBSAN_TRAP, you get a warning
about CONFIG_UBSAN_TRAP not been selected instead.

This also require a fix of pr_expected_config(), otherwise the
following error is encountered.

  CC      drivers/misc/lkdtm/bugs.o
drivers/misc/lkdtm/bugs.c: In function 'lkdtm_ARRAY_BOUNDS':
drivers/misc/lkdtm/bugs.c:351:2: error: 'else' without a previous 'if'
  351 |  else
      |  ^~~~

Fixes: c75be56e35b2 ("lkdtm/bugs: Add ARRAY_BOUNDS to selftests")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/r/363b58690e907c677252467a94fe49444c80ea76.1649704381.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/lkdtm/bugs.c  | 5 ++++-
 drivers/misc/lkdtm/lkdtm.h | 8 ++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index 072e3b742edf..fac4a811b97b 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -272,7 +272,10 @@ void lkdtm_ARRAY_BOUNDS(void)
 	kfree(not_checked);
 	kfree(checked);
 	pr_err("FAIL: survived array bounds overflow!\n");
-	pr_expected_config(CONFIG_UBSAN_BOUNDS);
+	if (IS_ENABLED(CONFIG_UBSAN_BOUNDS))
+		pr_expected_config(CONFIG_UBSAN_TRAP);
+	else
+		pr_expected_config(CONFIG_UBSAN_BOUNDS);
 }
 
 void lkdtm_CORRUPT_LIST_ADD(void)
diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
index c212a253edde..ef9a24aabfc3 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -9,19 +9,19 @@
 extern char *lkdtm_kernel_info;
 
 #define pr_expected_config(kconfig)				\
-{								\
+do {								\
 	if (IS_ENABLED(kconfig)) 				\
 		pr_err("Unexpected! This %s was built with " #kconfig "=y\n", \
 			lkdtm_kernel_info);			\
 	else							\
 		pr_warn("This is probably expected, since this %s was built *without* " #kconfig "=y\n", \
 			lkdtm_kernel_info);			\
-}
+} while (0)
 
 #ifndef MODULE
 int lkdtm_check_bool_cmdline(const char *param);
 #define pr_expected_config_param(kconfig, param)		\
-{								\
+do {								\
 	if (IS_ENABLED(kconfig)) {				\
 		switch (lkdtm_check_bool_cmdline(param)) {	\
 		case 0:						\
@@ -52,7 +52,7 @@ int lkdtm_check_bool_cmdline(const char *param);
 			break;					\
 		}						\
 	}							\
-}
+} while (0)
 #else
 #define pr_expected_config_param(kconfig, param) pr_expected_config(kconfig)
 #endif
-- 
2.35.1



