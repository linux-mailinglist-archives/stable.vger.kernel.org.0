Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB75579C64
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:40:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238053AbiGSMkB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241313AbiGSMjU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:39:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EC8C52FC8;
        Tue, 19 Jul 2022 05:15:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9C90B81B08;
        Tue, 19 Jul 2022 12:15:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B69C341CA;
        Tue, 19 Jul 2022 12:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232939;
        bh=cG48VpzWujqCH5sdjCd+09tH1Hd3kq6jlJ2Ki0S3mII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KskVcakUJBWozpQTKT44aXSo36ORgS9Wy1C6775JnsX9IiNMCNO4Ix0E4eETeefKT
         6g6e/xsnfldTtmWqHzldhTdnlSpiBTU+nMqVnNGE5wvrCmg72RElmHACzLPnH3+VFQ
         EDK7zCOfNBdsPfZYWMR5H68tl5i8q1wceQ9xGK04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coiby Xu <coxu@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 095/167] ima: force signature verification when CONFIG_KEXEC_SIG is configured
Date:   Tue, 19 Jul 2022 13:53:47 +0200
Message-Id: <20220719114705.675324341@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
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
index 33be67c2f7ff..cf042d41c87b 100644
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
index e289e60ba3ad..f7a4fd4d243f 100644
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



