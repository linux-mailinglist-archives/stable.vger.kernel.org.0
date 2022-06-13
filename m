Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6AF154896C
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381178AbiFMOH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381463AbiFMOEW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:04:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41B0524093;
        Mon, 13 Jun 2022 04:39:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3D6AB80E2C;
        Mon, 13 Jun 2022 11:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EFBC34114;
        Mon, 13 Jun 2022 11:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120382;
        bh=BdLngRgHCbIHp4DhE0hw41qU3rCB9q/n6eugofvh6Gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEi9MtZm7m83qzJj+uxULmH1nfw7ySjYyg1O+iI0yzw14jMSpmSVvcVmbzAwII3iF
         pVEuRIm273djZX5UaAmCitFjlK+mYZVjOMG39L3dQeLW1GLV0bHpd6ZteMND9ITMHX
         jrRDkZ9WlOogY9ufdH2RAxIDoW+BRFjUfajWhppQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 005/298] lkdtm/bugs: Dont expect thread termination without CONFIG_UBSAN_TRAP
Date:   Mon, 13 Jun 2022 12:08:19 +0200
Message-Id: <20220613094925.084119132@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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
index 4f2808b2ca3c..8cb342c562af 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -351,7 +351,10 @@ void lkdtm_ARRAY_BOUNDS(void)
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
index d6137c70ebbe..cc76ebcca4c7 100644
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



