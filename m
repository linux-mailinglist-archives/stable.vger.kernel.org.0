Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A63EA21BD35
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 20:52:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgGJSwI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 14:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgGJSwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 14:52:02 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72208C08C5DD
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 11:52:02 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x8so2604518plm.10
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 11:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mb9O2vonY58SmLkrA3ALuyeYbHan5/59dl3EopR+4JI=;
        b=TXrXcnxKeeytSI744NwwayynrsSw5XkLlrMUku+ZJ9lCRP+fqO8/uh5+RqffjiJrXE
         z7D39x700Z7u5J8Bvh/KbH0pD3iXeAwzCBsarSibgGL/sMg1qvJ1zb0yDDW5utUeUkus
         sUOunu6eHh9IuBkOdk7DUEOImLHM8qT9H/QuU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mb9O2vonY58SmLkrA3ALuyeYbHan5/59dl3EopR+4JI=;
        b=fB11/7EYZzLPWbnlk35CAPvY6m7/XyC7e2D89BrtQSP60Mghm+kVz1Xd+CDOtsPf82
         5YXxwQqqK/HDdVzsyZgZr1uiITi18WMlwZ+1IaKQjY+8vBXcV2eOfqLa/D94O4l+SPkB
         VP4xmUwK3NRof/OBeTVYjN4HF1z14yo7aZ24qaKtDotZVZIeLs98NbUKQKvSCbpyVz9O
         3yHDegy32M9Rt8YE9KijcmHEM4f6pKkuDEI+sRQvsPiG24cPYPCwL78B3vtU/NGfNns1
         tungF+HKEXadwNLcoXKa/JEJORO61oRrdTBZDs13p38QhuwIq7Dbdd6S3sZGLAlrx14Z
         ek5Q==
X-Gm-Message-State: AOAM530DkIWwYWP0vPCBwr//jgCj333sAQhOQ49LWgaQHRecmROFntVF
        xBjnWLwgwMN9H2udnssd4LJrZg==
X-Google-Smtp-Source: ABdhPJyxCk0Y6nYMLmC0PiBcu1x/20ofDeWPHvD1zPrvpGZOML90rH3EEcNAiYpy3Wvvq16rxEVM8g==
X-Received: by 2002:a17:90a:e602:: with SMTP id j2mr6867543pjy.200.1594407121965;
        Fri, 10 Jul 2020 11:52:01 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id o42sm6776191pje.10.2020.07.10.11.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 11:51:59 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Will Deacon <will@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Tycho Andersen <tycho@tycho.ws>, linux-kernel@vger.kernel.org
Subject: [PATCH for-next/seccomp 2/2] selftests/seccomp: Set NNP for TSYNC ESRCH flag test
Date:   Fri, 10 Jul 2020 11:51:56 -0700
Message-Id: <20200710185156.2437687-3-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200710185156.2437687-1-keescook@chromium.org>
References: <20200710185156.2437687-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The TSYNC ESRCH flag test will fail for regular users because NNP was
not set yet. Add NNP setting.

Fixes: 51891498f2da ("seccomp: allow TSYNC and USER_NOTIF together")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 08bfbb7fc1c2..93de2f1e3a99 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -3238,6 +3238,11 @@ TEST(user_notification_with_tsync)
 	int ret;
 	unsigned int flags;
 
+	ret = prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0);
+	ASSERT_EQ(0, ret) {
+		TH_LOG("Kernel does not support PR_SET_NO_NEW_PRIVS!");
+	}
+
 	/* these were exclusive */
 	flags = SECCOMP_FILTER_FLAG_NEW_LISTENER |
 		SECCOMP_FILTER_FLAG_TSYNC;
-- 
2.25.1

