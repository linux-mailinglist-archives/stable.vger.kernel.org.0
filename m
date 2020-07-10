Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630A221C03E
	for <lists+stable@lfdr.de>; Sat, 11 Jul 2020 01:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgGJXBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 19:01:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726588AbgGJXBM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 19:01:12 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21240C08E763
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 16:01:11 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id k4so2830812pld.12
        for <stable@vger.kernel.org>; Fri, 10 Jul 2020 16:01:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=plPGzTPn8qeDi7iOgwL0mp+ouaTZyfAGNQFOzP+7U8Y=;
        b=AVULz8YcPhjFqumFxyE6EiQFOzyKP8WlXfdL8dzQANxCxMos6i3W1g9dfcVE2XpITO
         EmnvAfNht4K5U63zDffx2pmWCMA8kTSCUTCxYzKVJhlKI6JOMmmk5sXZsTLA1TPAtdfz
         pF+uQrs0ajxDHBOA39ovBlWQX/K2UsWE52Q5U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=plPGzTPn8qeDi7iOgwL0mp+ouaTZyfAGNQFOzP+7U8Y=;
        b=iA3MIHW8ufNXNkpfQCSC5rhG+6DZGPpqLGBkYfMj1LwRSIf079CiRQY6JX75utrS92
         vpxx4mTiROxBgCHoTuwGKMwIXOdKbpBqwiWFDqurizEQ2+yOVGaYFvdRawv34/I7Eqe9
         rJSaRf+zr6MfL+yPc7b2viIlTao8NkKadtoL0V1csY62Zr7hPOgcR6Cv8MK5CDZ6Uj7J
         b8jz2UZiM35oeE/VrjLPVjUEljJoJ0BlrDpSWT//scFFrOKQeD6MAwTVd6yidDk6wNBj
         ddaGdCzr05C0V/UmnZQ1lSSQ0UHGgLy7BDevsp2GSNofygFq5Wxq2GOZUj1U9KlWuyc9
         g4AA==
X-Gm-Message-State: AOAM533uCHGJ/g2v9Z7B7P0BwAzRioDhE9tlgNlBcgedxWZmIfVvoEBP
        B7YuhhI6urYiatxK1mVECx+KiA==
X-Google-Smtp-Source: ABdhPJxJ3IvgLCB287FazX3iXVmDYo+c5ory2weCQWET53H5hMwkWX4TueUomo9YQx2XmgcY8Z6egg==
X-Received: by 2002:a17:90b:34d:: with SMTP id fh13mr7286518pjb.99.1594422071364;
        Fri, 10 Jul 2020 16:01:11 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id b21sm6946553pfp.172.2020.07.10.16.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 16:01:09 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Will Deacon <will@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Tycho Andersen <tycho@tycho.ws>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Shuah Khan <shuah@kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Will Drewry <wad@chromium.org>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH for-next/seccomp v2 2/2] selftests/seccomp: Set NNP for TSYNC ESRCH flag test
Date:   Fri, 10 Jul 2020 16:01:07 -0700
Message-Id: <20200710230107.2528890-3-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200710230107.2528890-1-keescook@chromium.org>
References: <20200710230107.2528890-1-keescook@chromium.org>
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
Reviewed-by: Tycho Andersen <tycho@tycho.ws>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 14b038361549..0d29114123fa 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -3257,6 +3257,11 @@ TEST(user_notification_with_tsync)
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

