Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7206522D109
	for <lists+stable@lfdr.de>; Fri, 24 Jul 2020 23:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgGXVic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jul 2020 17:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgGXVgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jul 2020 17:36:49 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24F29C08C5C0
        for <stable@vger.kernel.org>; Fri, 24 Jul 2020 14:36:49 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id t6so6155606pgq.1
        for <stable@vger.kernel.org>; Fri, 24 Jul 2020 14:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vcN9YX8ekyRngE6bYuM+DpwcbgbhaICM+gIK3/spxEo=;
        b=Nc4diiOSieMuCnwFnM1yLq67WkmNMLzX2630xjI5cNAoihRYSscqjCh5iq+xIqV8Rf
         C/nzz1nmc+3U8+Im2MKoaswgBHNvpJxQ3RTT0CH0MqwRrrRlXHub57dfzOjxLRMe/pUb
         BbFOK0m7fuKN+YQoWATIv6L6EH0a2FruUCsI0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vcN9YX8ekyRngE6bYuM+DpwcbgbhaICM+gIK3/spxEo=;
        b=rWwchnYyFW0hXVptZGBg6iA7qSsWHqAHagsQgRD5UQ65xzi3YuHBDOXhNgd1j6pTXm
         6gQVh+Ve9zogL3v8tVvDR10uUvFn5AF4Z/hRoz7LinJrH2oOy3SRqFva9HOwMdew6fCe
         P+kGhK3U341RZ6QvhA67ehs0iDqWqauYhmUO4BK7n3L+LxLVEl6eY9+ENcy4MDPcjiUb
         +ADDwH8KBxcejwj4Yoy3USH/SCEerCMmcM34eoACA4gYby/CPoWB4clwtsaPG8unLCBt
         lTP8DWXgTHUp1v72D/Hq5j5ahVgjmbLtaQzu36cCZfWWQkGd2k2ucY5d8R1y7ejBOFHi
         177A==
X-Gm-Message-State: AOAM5333kpcJc9ut2LHmuzH4sW3uSQGhljYosf8rHf/C5e+J81+2kAVz
        LsZdWFhXpxK9n6vAlnhK5qtIZQ==
X-Google-Smtp-Source: ABdhPJyJrXi5k9Qloae7/gFl16disQrz+TOWjexj7lVgRQuvGP6252jBRHdY/u/NQrhbtwjiKq8yXA==
X-Received: by 2002:a62:a217:: with SMTP id m23mr10629324pff.291.1595626608680;
        Fri, 24 Jul 2020 14:36:48 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id q24sm6722845pgg.3.2020.07.24.14.36.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 14:36:47 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Scott Branden <scott.branden@broadcom.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jessica Yu <jeyu@kernel.org>, SeongJae Park <sjpark@amazon.de>,
        KP Singh <kpsingh@chromium.org>, linux-efi@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-integrity@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 05/19] fs/kernel_read_file: Remove FIRMWARE_EFI_EMBEDDED enum
Date:   Fri, 24 Jul 2020 14:36:26 -0700
Message-Id: <20200724213640.389191-6-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200724213640.389191-1-keescook@chromium.org>
References: <20200724213640.389191-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The "FIRMWARE_EFI_EMBEDDED" enum is a "where", not a "what". It
should not be distinguished separately from just "FIRMWARE", as this
confuses the LSMs about what is being loaded. Additionally, there was
no actual validation of the firmware contents happening.

Fixes: e4c2c0ff00ec ("firmware: Add new platform fallback mechanism and firmware_request_platform()")
Cc: stable@vger.kernel.org
Acked-by: Scott Branden <scott.branden@broadcom.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
To aid in backporting, this change is made before moving
kernel_read_file() to separate header/source files.
---
 drivers/base/firmware_loader/fallback_platform.c | 2 +-
 include/linux/fs.h                               | 3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/base/firmware_loader/fallback_platform.c b/drivers/base/firmware_loader/fallback_platform.c
index 685edb7dd05a..6958ab1a8059 100644
--- a/drivers/base/firmware_loader/fallback_platform.c
+++ b/drivers/base/firmware_loader/fallback_platform.c
@@ -17,7 +17,7 @@ int firmware_fallback_platform(struct fw_priv *fw_priv, u32 opt_flags)
 	if (!(opt_flags & FW_OPT_FALLBACK_PLATFORM))
 		return -ENOENT;
 
-	rc = security_kernel_load_data(LOADING_FIRMWARE_EFI_EMBEDDED);
+	rc = security_kernel_load_data(LOADING_FIRMWARE);
 	if (rc)
 		return rc;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 95fc775ed937..f50a35d54a61 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2993,11 +2993,10 @@ static inline void i_readcount_inc(struct inode *inode)
 #endif
 extern int do_pipe_flags(int *, int);
 
-/* This is a list of *what* is being read, not *how*. */
+/* This is a list of *what* is being read, not *how* nor *where*. */
 #define __kernel_read_file_id(id) \
 	id(UNKNOWN, unknown)		\
 	id(FIRMWARE, firmware)		\
-	id(FIRMWARE_EFI_EMBEDDED, firmware)	\
 	id(MODULE, kernel-module)		\
 	id(KEXEC_IMAGE, kexec-image)		\
 	id(KEXEC_INITRAMFS, kexec-initramfs)	\
-- 
2.25.1

