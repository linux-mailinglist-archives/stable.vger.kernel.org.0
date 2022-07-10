Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86D8856CF3B
	for <lists+stable@lfdr.de>; Sun, 10 Jul 2022 15:11:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbiGJNLV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 09:11:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiGJNLT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 09:11:19 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DD810FC8
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 06:11:18 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id w12so2713224edd.13
        for <stable@vger.kernel.org>; Sun, 10 Jul 2022 06:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3tPrCShgjHQ67M6DbmwQSJsM9FT/QD9O9OeTwNbvMu0=;
        b=esXBGU1xft8QVE4TzntbFy8Ahxh5utXF9m2KhJLyurxLKek75qjXEO8OOKSEJL0lfN
         1ZMW7yFf23YKjF1Nk0Qol8o3TiVda8bTpA2WtvqlXG00l2rv9+lyYa6sgNHkzu3t2HlA
         y181IPWOjyu2FGdmoOfDSO5LlqG9o617BtYLKL0OJ7RMeVa7LKe6iZcKrs4/DrxNR4tT
         DbFgqPwNqzmDtaD8gOy5I+P833gOSLSxvyWMXmNX8AZ6IUQQvRCzEU8YZVjRBMsnLnOv
         ifie2jEb+3f8b971YUmNdFpBTidGOYmZEgeACi5pShqOjvVUpA3t1zFqyGqm6oQr064c
         BUHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3tPrCShgjHQ67M6DbmwQSJsM9FT/QD9O9OeTwNbvMu0=;
        b=GMk98pS6HgNfTeUAlIqq6tp0y5I1wOxZdxnQXZLLacYJB07ll+iv3G/soSoR+4lxql
         tB7dVd7kEVx00V7Twf5HxtXL6UsK1UY//Ho+uOeZrkf2H0szSHWf7wMoluusNUr0bvIp
         5C34cTQapMMm9sCP6f0IKA8MjEJJ7E2nkgjhuJBhYbLMxck2aHb1rUsqnwdfyL82yPRz
         3iPlRB686V90rif3LOTe67sHQ0Xe+Gu/nyqzoL//jKYC9jdHoZLRWeh7/zZX7UKS0sph
         LmBqDClCeI2eNzkeZYrPnwAUUSsF2sgWmbBhAbzl6errLtZkWgrcLcm6KVf7A4Xb9aVp
         IAng==
X-Gm-Message-State: AJIora8NhftW6OgK8EL4g9RWatD4IODOyLBHF97ml5xe6kR38wIkh0Fi
        u3goJD8WlJ2ml+QJQ1y9LNBn+2Agh/K//Q==
X-Google-Smtp-Source: AGRyM1t5vHS6y1sANRuAyNibisJRkiaeO15H3Zw//nX3+H7qAld3UDl8mh5ObjH3R4S13ufUgHq4Fg==
X-Received: by 2002:a05:6402:1cc8:b0:437:a61a:5713 with SMTP id ds8-20020a0564021cc800b00437a61a5713mr18365924edb.340.1657458676887;
        Sun, 10 Jul 2022 06:11:16 -0700 (PDT)
Received: from alex-Mint.fritz.box (p200300f6af42a000bd655b56da6a0a3d.dip0.t-ipconnect.de. [2003:f6:af42:a000:bd65:5b56:da6a:a3d])
        by smtp.googlemail.com with ESMTPSA id i19-20020a170906115300b007262b9f7120sm1565763eja.167.2022.07.10.06.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Jul 2022 06:11:16 -0700 (PDT)
From:   theflamefire89@gmail.com
To:     stable@vger.kernel.org
Cc:     James Morris <jmorris@namei.org>
Subject: [PATCH 1/2] security: introduce CONFIG_SECURITY_WRITABLE_HOOKS
Date:   Sun, 10 Jul 2022 15:10:54 +0200
Message-Id: <20220710131055.12934-1-theflamefire89@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morris <jmorris@namei.org>

commit dd0859dccbe291cf8179a96390f5c0e45cb9af1d upstream.

Subsequent patches will add RO hardening to LSM hooks, however, SELinux
still needs to be able to perform runtime disablement after init to handle
architectures where init-time disablement via boot parameters is not feasible.

Introduce a new kernel configuration parameter CONFIG_SECURITY_WRITABLE_HOOKS,
and a helper macro __lsm_ro_after_init, to handle this case.

Signed-off-by: James Morris <james.l.morris@oracle.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Alexander Grund <git@grundis.de>
---
 include/linux/lsm_hooks.h | 7 +++++++
 security/Kconfig          | 5 +++++
 security/selinux/Kconfig  | 6 ++++++
 3 files changed, 18 insertions(+)

diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 53ac461f342b..65dfda2623c2 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -1921,6 +1921,13 @@ static inline void security_delete_hooks(struct security_hook_list *hooks,
 }
 #endif /* CONFIG_SECURITY_SELINUX_DISABLE */
 
+/* Currently required to handle SELinux runtime hook disable. */
+#ifdef CONFIG_SECURITY_WRITABLE_HOOKS
+#define __lsm_ro_after_init
+#else
+#define __lsm_ro_after_init	__ro_after_init
+#endif /* CONFIG_SECURITY_WRITABLE_HOOKS */
+
 extern int __init security_module_enable(const char *module);
 extern void __init capability_add_hooks(void);
 #ifdef CONFIG_SECURITY_YAMA
diff --git a/security/Kconfig b/security/Kconfig
index 32f36b40e9f0..7d6edc5829a1 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -31,6 +31,11 @@ config SECURITY
 
 	  If you are unsure how to answer this question, answer N.
 
+config SECURITY_WRITABLE_HOOKS
+	depends on SECURITY
+	bool
+	default n
+
 config PAGE_TABLE_ISOLATION
 	bool "Remove the kernel mapping in user mode"
 	default y
diff --git a/security/selinux/Kconfig b/security/selinux/Kconfig
index ea7e3efbe0f7..8af7a690eb40 100644
--- a/security/selinux/Kconfig
+++ b/security/selinux/Kconfig
@@ -40,6 +40,7 @@ config SECURITY_SELINUX_BOOTPARAM_VALUE
 config SECURITY_SELINUX_DISABLE
 	bool "NSA SELinux runtime disable"
 	depends on SECURITY_SELINUX
+	select SECURITY_WRITABLE_HOOKS
 	default n
 	help
 	  This option enables writing to a selinuxfs node 'disable', which
@@ -50,6 +51,11 @@ config SECURITY_SELINUX_DISABLE
 	  portability across platforms where boot parameters are difficult
 	  to employ.
 
+	  NOTE: selecting this option will disable the '__ro_after_init'
+	  kernel hardening feature for security hooks.   Please consider
+	  using the selinux=0 boot parameter instead of enabling this
+	  option.
+
 	  If you are unsure how to answer this question, answer N.
 
 config SECURITY_SELINUX_DEVELOP
-- 
2.25.1

