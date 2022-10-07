Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B964B5F7E09
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 21:34:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiJGTe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 15:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiJGTez (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 15:34:55 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A226C1CB24
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 12:34:50 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id t10-20020a17090a4e4a00b0020af4bcae10so5546279pjl.3
        for <stable@vger.kernel.org>; Fri, 07 Oct 2022 12:34:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oX31h8BZUKm88S40GGusR6supCx5VMFYPQ0q81Ct3Og=;
        b=ibt7mXcKzpS2FdvlXO8aCKePikGxqHnc3S5vCinTa2v3F1Kls1TCwlqzW17T5mj5w5
         1ZwDf5ii4Yz67yx1qeT7f/KDrIlNZ/7MrTDylrLXsdVdwLAMdXvkbpvUWTFpGXHcMqZg
         Y52CjF0BTicLG1T2YFOraZqu5ElotC2gizxypgyRA5f35aCg7xtDPnr6JUSgiK6aqHFY
         P3DRSJkwciDcalVCi4fGsA3jouq66/OobWRU+b5pVsKKNpTnKzsrht+5dXzotR4I9+j6
         w64Vc8daVRFz45uDEi8lI1ER/MjSBYw8eP9c98QT08nQJHup+W2082KVOl8uNeUq8rLa
         3hfA==
X-Gm-Message-State: ACrzQf3dGrNYz7YrdRNhZPxBsKAsYKxtsTrCRPY38rranhT+MV1d0SYP
        sGBnQXQ/qI7cIngnyxQouF6+VdQG4NM=
X-Google-Smtp-Source: AMsMyM70GiZSoyFIRw5X5W6Y/BgNqB8zYSXe/pJfQn+9QBjj7vYXzdBcLvebMK7lGalhNuptZpsVqQ==
X-Received: by 2002:a17:90b:4c50:b0:202:c7b1:b1f9 with SMTP id np16-20020a17090b4c5000b00202c7b1b1f9mr18269839pjb.77.1665171289468;
        Fri, 07 Oct 2022 12:34:49 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:b72:b06c:f943:31d5])
        by smtp.gmail.com with ESMTPSA id b13-20020a170902d88d00b00176be23bbb3sm1870361plz.172.2022.10.07.12.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 12:34:48 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     stable@vger.kernel.org
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] compiler_attributes.h: move __compiletime_{error|warning}
Date:   Fri,  7 Oct 2022 12:34:36 -0700
Message-Id: <20221007193436.906-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>

commit b83a908498d68fafca931e1276e145b339cac5fb upstream.

Clang 14 will add support for __attribute__((__error__(""))) and
__attribute__((__warning__(""))). To make use of these in
__compiletime_error and __compiletime_warning (as used by BUILD_BUG and
friends) for newer clang and detect/fallback for older versions of
clang, move these to compiler_attributes.h and guard them with
__has_attribute preprocessor guards.

Link: https://reviews.llvm.org/D106030
Link: https://bugs.llvm.org/show_bug.cgi?id=16428
Link: https://github.com/ClangBuiltLinux/linux/issues/1173
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
[Reworded, landed in Clang 14]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 include/linux/compiler-gcc.h        |  3 ---
 include/linux/compiler_attributes.h | 24 ++++++++++++++++++++++++
 include/linux/compiler_types.h      |  6 ------
 3 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index 4cf524ccab43..ae2de4e1cd6f 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -54,9 +54,6 @@
 
 #define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
 
-#define __compiletime_warning(message) __attribute__((__warning__(message)))
-#define __compiletime_error(message) __attribute__((__error__(message)))
-
 #if defined(LATENT_ENTROPY_PLUGIN) && !defined(__CHECKER__)
 #define __latent_entropy __attribute__((latent_entropy))
 #endif
diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index b2a3f4f641a7..08eb06301791 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -30,6 +30,7 @@
 # define __GCC4_has_attribute___assume_aligned__      (__GNUC_MINOR__ >= 9)
 # define __GCC4_has_attribute___copy__                0
 # define __GCC4_has_attribute___designated_init__     0
+# define __GCC4_has_attribute___error__               1
 # define __GCC4_has_attribute___externally_visible__  1
 # define __GCC4_has_attribute___no_caller_saved_registers__ 0
 # define __GCC4_has_attribute___noclone__             1
@@ -37,6 +38,7 @@
 # define __GCC4_has_attribute___no_sanitize_address__ (__GNUC_MINOR__ >= 8)
 # define __GCC4_has_attribute___no_sanitize_undefined__ (__GNUC_MINOR__ >= 9)
 # define __GCC4_has_attribute___fallthrough__         0
+# define __GCC4_has_attribute___warning__             1
 #endif
 
 /*
@@ -136,6 +138,17 @@
 # define __designated_init
 #endif
 
+/*
+ * Optional: only supported since clang >= 14.0
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-error-function-attribute
+ */
+#if __has_attribute(__error__)
+# define __compiletime_error(msg)       __attribute__((__error__(msg)))
+#else
+# define __compiletime_error(msg)
+#endif
+
 /*
  * Optional: not supported by clang
  *
@@ -272,6 +285,17 @@
  */
 #define __used                          __attribute__((__used__))
 
+/*
+ * Optional: only supported since clang >= 14.0
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-warning-function-attribute
+ */
+#if __has_attribute(__warning__)
+# define __compiletime_warning(msg)     __attribute__((__warning__(msg)))
+#else
+# define __compiletime_warning(msg)
+#endif
+
 /*
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-weak-function-attribute
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-weak-variable-attribute
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index 2a1c202baa1f..eb2bda017ccb 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -281,12 +281,6 @@ struct ftrace_likely_data {
 #ifndef __compiletime_object_size
 # define __compiletime_object_size(obj) -1
 #endif
-#ifndef __compiletime_warning
-# define __compiletime_warning(message)
-#endif
-#ifndef __compiletime_error
-# define __compiletime_error(message)
-#endif
 
 #ifdef __OPTIMIZE__
 # define __compiletime_assert(condition, msg, prefix, suffix)		\
