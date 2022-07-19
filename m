Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910EA579E5B
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 15:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243289AbiGSNAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 09:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242633AbiGSM7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:59:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4246A45F4C;
        Tue, 19 Jul 2022 05:24:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8D40618E1;
        Tue, 19 Jul 2022 12:24:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B36C341DB;
        Tue, 19 Jul 2022 12:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233447;
        bh=WYLhbyzG+PR2L8bSmowbBE5Xtl4RQvgXzIf3PnAW4mc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pzyZ1jOGxi3WQBRIS6TePEYUQ+eXa/r/S07i1wY4aeqhKiyTTNPq1W4YxkyFmYDu0
         28zgMNclAMtvaIIXjARnAZ0v1SQq2K+hMVOl5ItB6hvIT6hjACsVQN59Mc4r+ybsTK
         7+9b7NwYN9KXVeBc8hukYJqNaLn8PAC5JdBHhmkg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coiby Xu <coxu@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 126/231] ima: force signature verification when CONFIG_KEXEC_SIG is configured
Date:   Tue, 19 Jul 2022 13:53:31 +0200
Message-Id: <20220719114725.050016696@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coiby Xu <coxu@redhat.com>

[ Upstream commit af16df54b89dee72df253abc5e7b5e8a6d16c11c ]

Currently, an unsigned kernel could be kexec'ed when IMA arch specific
policy is configured unless lockdown is enabled. Enforce kernel
signature verification check in the kexec_file_load syscall when IMA
arch specific policy is configured.

Fixes: 99d5cadfde2b ("kexec_file: split KEXEC_VERIFY_SIG into KEXEC_SIG and KEXEC_SIG_FORCE")
Reported-and-suggested-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Coiby Xu <coxu@redhat.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/kexec.h            |  6 ++++++
 kernel/kexec_file.c              | 11 ++++++++++-
 security/integrity/ima/ima_efi.c |  2 ++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index fcd5035209f1..8d573baaab29 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -452,6 +452,12 @@ static inline int kexec_crash_loaded(void) { return 0; }
 #define kexec_in_progress false
 #endif /* CONFIG_KEXEC_CORE */
 
+#ifdef CONFIG_KEXEC_SIG
+void set_kexec_sig_enforced(void);
+#else
+static inline void set_kexec_sig_enforced(void) {}
+#endif
+
 #endif /* !defined(__ASSEBMLY__) */
 
 #endif /* LINUX_KEXEC_H */
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index c108a2a88754..bb0fb63f563c 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -29,6 +29,15 @@
 #include <linux/vmalloc.h>
 #include "kexec_internal.h"
 
+#ifdef CONFIG_KEXEC_SIG
+static bool sig_enforce = IS_ENABLED(CONFIG_KEXEC_SIG_FORCE);
+
+void set_kexec_sig_enforced(void)
+{
+	sig_enforce = true;
+}
+#endif
+
 static int kexec_calculate_store_digests(struct kimage *image);
 
 /*
@@ -159,7 +168,7 @@ kimage_validate_signature(struct kimage *image)
 					   image->kernel_buf_len);
 	if (ret) {
 
-		if (IS_ENABLED(CONFIG_KEXEC_SIG_FORCE)) {
+		if (sig_enforce) {
 			pr_notice("Enforced kernel signature verification failed (%d).\n", ret);
 			return ret;
 		}
diff --git a/security/integrity/ima/ima_efi.c b/security/integrity/ima/ima_efi.c
index 71786d01946f..9db66fe310d4 100644
--- a/security/integrity/ima/ima_efi.c
+++ b/security/integrity/ima/ima_efi.c
@@ -67,6 +67,8 @@ const char * const *arch_get_ima_policy(void)
 	if (IS_ENABLED(CONFIG_IMA_ARCH_POLICY) && arch_ima_get_secureboot()) {
 		if (IS_ENABLED(CONFIG_MODULE_SIG))
 			set_module_sig_enforced();
+		if (IS_ENABLED(CONFIG_KEXEC_SIG))
+			set_kexec_sig_enforced();
 		return sb_arch_rules;
 	}
 	return NULL;
-- 
2.35.1



