Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9428029B7DD
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368734AbgJ0P1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:27:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:39892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797605AbgJ0PYe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:24:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AAC1B2064B;
        Tue, 27 Oct 2020 15:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812274;
        bh=aG37qtlgtL3p06wj8CNTqWUrX72gBg8SaFC+DoiK7PA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2RWomiDX9juvlUWnwa7P8rrGOnPvRJKTVcD+dGVk/chpm2T011D4ALUg5WNyq5H0g
         YMJOdGqjB2SLsk3a4v/YN//vfmoKizWKafO8HqJroAivyC4rqfvGFqeVCl/tJ8y1Gd
         o9YvUbb1676gqgB9Rr4TMCHwfptchKsGMbCH5kSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 152/757] selftests/seccomp: Use __NR_mknodat instead of __NR_mknod
Date:   Tue, 27 Oct 2020 14:46:42 +0100
Message-Id: <20201027135457.735333983@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 05b52c6625278cc6ed1245a569167f86a971ff86 ]

The __NR_mknod syscall doesn't exist on arm64 (only __NR_mknodat).
Switch to the modern syscall.

Fixes: ad5682184a81 ("selftests/seccomp: Check for EPOLLHUP for user_notif")
Signed-off-by: Kees Cook <keescook@chromium.org>
Link: https://lore.kernel.org/lkml/20200912110820.597135-16-keescook@chromium.org
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/seccomp/seccomp_bpf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/seccomp/seccomp_bpf.c b/tools/testing/selftests/seccomp/seccomp_bpf.c
index 7a6d40286a421..9dc13be8fe5f5 100644
--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -3715,7 +3715,7 @@ TEST(user_notification_filter_empty)
 	if (pid == 0) {
 		int listener;
 
-		listener = user_notif_syscall(__NR_mknod, SECCOMP_FILTER_FLAG_NEW_LISTENER);
+		listener = user_notif_syscall(__NR_mknodat, SECCOMP_FILTER_FLAG_NEW_LISTENER);
 		if (listener < 0)
 			_exit(EXIT_FAILURE);
 
-- 
2.25.1



