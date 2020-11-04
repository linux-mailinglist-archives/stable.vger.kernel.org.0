Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C87E2A6D8E
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 20:11:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgKDTLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 14:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730129AbgKDTLH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 14:11:07 -0500
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C410C0613D4
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 11:11:06 -0800 (PST)
Received: by mail-qv1-xf4a.google.com with SMTP id u3so1384973qvb.19
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 11:11:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=gz5WtjKs0m8q7p+Y5q8+JmbEub8VEm+/kecg2iLZjKw=;
        b=EsW35ZmvLxRuca8q/4WsVMEXKOOcWAI+IZtfjnfqqDE4U4MLjllfGtcsMOf4vN1Z8F
         sCDuQYQEGKAAeuniI68VVBPH4nGP99IJnTLhSX8rCzF1/vTz5aFgVXtY/OTaKF9CaZZK
         Djz3ylgLOzL+Te9i20ZCxN0a096laVkVdb9RlfnsMFhgABTgsPy5ACgXS8UnDCk+B1Fh
         /tfTApWfYkT48/bsDcNN3nWUHgRPr209KCLuurjnhcWL82jbdStOWkq85NMu5BUK3kLB
         /egvdyqSkn/Q2MdaOelejjP9c+CBEPCgZTz1nL8WqgWfafgybvvUR49Cu/qeaCAsnLB+
         lTCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=gz5WtjKs0m8q7p+Y5q8+JmbEub8VEm+/kecg2iLZjKw=;
        b=VI8pf3gWjdxtj/7ZhODkNtluW9Jy6ShUH9AdsJSjJbt1HbjW1nkOCTfyA1srmZMSTn
         1XzEOZxrsFvfGxb2oSGh8zAR6v/O9AsxSvPQmox+Y3ad1zw9XyTxrh7heeMlSR3YTlzl
         nKCwEyV5zm9A+hi1s3JIfg8tGpKr+oBNwc/qY3X2K5NdZZNZXJPUlc5LZgEmtH5znLxq
         Q+ePoERDBNNUd6dpdYIyeGIwkF7qwgdTKwugKKBoGm1Li3MZEqkSkEQ70ya0X5QxrMgx
         uvCCqnnyLjXNHjCniRTr0NxbO8hR6DifWnPToqy0+J6OYna1fRzFPyxWIeEdelIXWCCx
         tVhA==
X-Gm-Message-State: AOAM531h+8tjSNA6vO7p0bKL6TcLW0Xzy6d+pV0xCUMkmtkePoM/S7uU
        h0gCIhiGtm+dLOrRGI/UkebDNckdLY+g9T2gIG0=
X-Google-Smtp-Source: ABdhPJyQtmG0KXYIon8XRTO/l+GuGjkNMEgT2DkP9uvR9AgSNTEqc7Cjl9cQ1CKa3Pb65D8Ff3QgJyMABq9VwnEEk6s=
Sender: "ndesaulniers via sendgmr" 
        <ndesaulniers@ndesaulniers1.mtv.corp.google.com>
X-Received: from ndesaulniers1.mtv.corp.google.com ([2620:15c:211:202:f693:9fff:fef4:4d25])
 (user=ndesaulniers job=sendgmr) by 2002:a05:6214:186b:: with SMTP id
 eh11mr33319123qvb.49.1604517064979; Wed, 04 Nov 2020 11:11:04 -0800 (PST)
Date:   Wed,  4 Nov 2020 11:10:51 -0800
Message-Id: <20201104191052.390657-1-ndesaulniers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.1.341.ge80a0c044ae-goog
Subject: [PATCH] compiler-clang: remove version check for BPF Tracing
From:   Nick Desaulniers <ndesaulniers@google.com>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Nick Desaulniers <ndesaulniers@google.com>, stable@vger.kernel.org,
        Chen Yu <yu.chen.surf@gmail.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Marco Elver <elver@google.com>,
        Arvind Sankar <nivedita@alum.mit.edu>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

bpftrace parses the kernel headers and uses Clang under the hood. Remove
the version check when __BPF_TRACING__ is defined (as bpftrace does) so
that this tool can continue to parse kernel headers, even with older
clang sources.

Cc: <stable@vger.kernel.org>
Fixes: commit 1f7a44f63e6c ("compiler-clang: add build check for clang 10.0.1")
Reported-by: Chen Yu <yu.chen.surf@gmail.com>
Reported-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 include/linux/compiler-clang.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
index dd7233c48bf3..98cff1b4b088 100644
--- a/include/linux/compiler-clang.h
+++ b/include/linux/compiler-clang.h
@@ -8,8 +8,10 @@
 		     + __clang_patchlevel__)
 
 #if CLANG_VERSION < 100001
+#ifndef __BPF_TRACING__
 # error Sorry, your version of Clang is too old - please use 10.0.1 or newer.
 #endif
+#endif
 
 /* Compiler specific definitions for Clang compiler */
 
-- 
2.29.1.341.ge80a0c044ae-goog

