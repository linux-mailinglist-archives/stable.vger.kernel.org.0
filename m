Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD5F4B0391
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 03:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230354AbiBJCxX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 21:53:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231646AbiBJCxX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 21:53:23 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C794F240B3
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 18:53:24 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id v13-20020a17090ac90d00b001b87bc106bdso7102149pjt.4
        for <stable@vger.kernel.org>; Wed, 09 Feb 2022 18:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e+pXz6MJQQE9ge1AxmSCkxXIFbo0QVYRSttlemPgs4o=;
        b=aodHG0a1app1EsXmVOZMmZMgNEV+QVMFGkYeX2Fpx9EuXbboPulJap3+2nmClHC0yv
         5s0JAfBse4hzE/66dSMNsCrwf5dZUJb2Orz0guzzaXJMdhLFbNoYiY438usdn9tFl4LC
         RGJlyKLROLbeby9MxAt8ymOuIkK2k3pxFAjwI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e+pXz6MJQQE9ge1AxmSCkxXIFbo0QVYRSttlemPgs4o=;
        b=O5tPaLtVA838mcXNT2nMB/yUuLTax+629NQXzs+onYH/klMKRpFQZmBIdw77ufxH/j
         xyfTc5Yr9qX/MRsggm2qCB65eDAUtGIAKJ9zj+ToZbFGF7Tj20Lo8jmoNIsUiims7I7l
         dvwwZ2r+cPRggr6mcKbehzXd4jboM3cHr2PMYAomlr+Voc7y473VyJhTnDZ5Urp1Qqu1
         E5VJcCLsGjGV9CVqkV9I2Vaj9bUzXr0gf7i8afKM1jGZ+KBuJ2dMS+41t5ejH+zz+Er8
         LWtfU/CIiNTT3gy5X7XWww7QJ/qByBRJUpxIT9KiEia0GnRPBpuDgzbD6blnTyzbSJrw
         mU/w==
X-Gm-Message-State: AOAM53333UVhLeorgpKOOSL+uAUyWDzbJQ9yir91keFycIa91zxI60jz
        rdRKxHIE6zK1b9rMVz2CycX+njgxi5ptTQ==
X-Google-Smtp-Source: ABdhPJyvpp/GnnAb2OFSk0N+M/fhefy88WpnRqQnCQiBPyKBvJjbXA3g0Qoqhb/7kBLMen4XuQPMNw==
X-Received: by 2002:a17:903:244a:: with SMTP id l10mr5325874pls.0.1644461604276;
        Wed, 09 Feb 2022 18:53:24 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h6sm21890559pfc.96.2022.02.09.18.53.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 18:53:23 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>, stable@vger.kernel.org,
        =?UTF-8?q?Robert=20=C5=9Awi=C4=99cki?= <robert@swiecki.net>,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH 2/3] seccomp: Invalidate seccomp mode to catch death failures
Date:   Wed,  9 Feb 2022 18:53:20 -0800
Message-Id: <20220210025321.787113-3-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220210025321.787113-1-keescook@chromium.org>
References: <20220210025321.787113-1-keescook@chromium.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1973; h=from:subject; bh=5NQQkQd6GxAQWbeOukH4H4HOeGum7cgpYZaBrQoxSZU=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBiBH4gf71SjtF76KiPChNFB7ZiqREqAirIAm27s0t7 k3NDFxWJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYgR+IAAKCRCJcvTf3G3AJruDD/ 96PTk4kUSwTiqSC6szaPsQXtlvxDTXOM4v7SpnRSBxGZVXJzh6hIYmcG0fx/kTgL0mjl1n4NipRXBx q1ygCXKCVZm9W1nQ6cOqwZGpGpLCvbXNifp6StIJQSFritY7WTrW5YAKfw9Ts8ueI5SMnFe6i2DOa6 lBeqUGR8LJ1v19uuFyA/AxVXvSMdpg0apKI97PS/LKn3aS7WP7Dr7QMMSAuSrSZYY5i4RYuNBjGRJf SdZBhX+J4mUTfbBaJD9nLPdeWuyS8apx0srBcvgtUMPdtoNt24oqGEEb1/dsuwo+dgpyVWO5zX6ub1 5BhPCOKbfoIagD0jdGKAHm2/mrYfET/hu/jWODqo0xpV3Zz6FeFcu9eT6vhe1ln5VrJHmGtBhUULnC imqSkJsTdO02VVNNA52T4CquGAY/r0OKA0NGMANoyPLhAGDkOuEGQZ7IeeJGNiuOUIO9eTRzXSSV6j b7sFnx/wwX4n2Yx8yp72QXnAl0NsLDXrb6FKrA99szBDWILGvchsW7+G0EYEhmv8ZBV1CqzuGb5uaQ ibap9sFhBjvNo2ELLOZn5yYGz7iUL0ged1f/oidiejaJ1OQMc7SbNy20z+s6q2KAh2LYHuTiP/h4Q/ T81QAMuBBVt3ksWOj9tkRhNGFJNnY7iNfDP0w4GrdRyWkKkXLkqEHnKXCU6A==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If seccomp tries to kill a process, it should never see that process
again. To enforce this proactively, switch the mode to something
impossible. If encountered: WARN, reject all syscalls, and attempt to
kill the process again even harder.

Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Will Drewry <wad@chromium.org>
Fixes: 8112c4f140fa ("seccomp: remove 2-phase API")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 kernel/seccomp.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 4d8f44a17727..db10e73d06e0 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -29,6 +29,9 @@
 #include <linux/syscalls.h>
 #include <linux/sysctl.h>
 
+/* Not exposed in headers: strictly internal use only. */
+#define SECCOMP_MODE_DEAD	(SECCOMP_MODE_FILTER + 1)
+
 #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
 #include <asm/syscall.h>
 #endif
@@ -1010,6 +1013,7 @@ static void __secure_computing_strict(int this_syscall)
 #ifdef SECCOMP_DEBUG
 	dump_stack();
 #endif
+	current->seccomp.mode = SECCOMP_MODE_DEAD;
 	seccomp_log(this_syscall, SIGKILL, SECCOMP_RET_KILL_THREAD, true);
 	do_exit(SIGKILL);
 }
@@ -1261,6 +1265,7 @@ static int __seccomp_filter(int this_syscall, const struct seccomp_data *sd,
 	case SECCOMP_RET_KILL_THREAD:
 	case SECCOMP_RET_KILL_PROCESS:
 	default:
+		current->seccomp.mode = SECCOMP_MODE_DEAD;
 		seccomp_log(this_syscall, SIGSYS, action, true);
 		/* Dump core only if this is the last remaining thread. */
 		if (action != SECCOMP_RET_KILL_THREAD ||
@@ -1309,6 +1314,11 @@ int __secure_computing(const struct seccomp_data *sd)
 		return 0;
 	case SECCOMP_MODE_FILTER:
 		return __seccomp_filter(this_syscall, sd, false);
+	/* Surviving SECCOMP_RET_KILL_* must be proactively impossible. */
+	case SECCOMP_MODE_DEAD:
+		WARN_ON_ONCE(1);
+		do_exit(SIGKILL);
+		return -1;
 	default:
 		BUG();
 	}
-- 
2.30.2

