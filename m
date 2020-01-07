Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA5E713346F
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728188AbgAGU7q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 15:59:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:33260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728174AbgAGU7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:59:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2193B2087F;
        Tue,  7 Jan 2020 20:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430785;
        bh=44x2w1OX8PyamDGDNVHFPXS7thF5220wNWK62MHi+ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KJGUqJWtwru8WcAiin7QBjFPnR7nuXXXWcnQRUW9isWGrAfN8yWbhdjB7aYWtrAZ9
         NwwDRnjnjrNt/R9qPjqB5gVz7gVJ6lUrmnzSPGnBP7iJOIXmjPxVwdC1BLG/Kcnmkh
         SuLfeB0t5nrepz7LbQr4B8GA7mc1jfvlKKaT+wwg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.4 096/191] selftests/seccomp: Catch garbage on SECCOMP_IOCTL_NOTIF_RECV
Date:   Tue,  7 Jan 2020 21:53:36 +0100
Message-Id: <20200107205338.129972282@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sargun Dhillon <sargun@sargun.me>

commit e4ab5ccc357b978999328fadae164e098c26fa40 upstream.

This adds logic to the user_notification_basic test to set a member
of struct seccomp_notif to an invalid value to ensure that the kernel
returns EINVAL if any of the struct seccomp_notif members are set to
invalid values.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Suggested-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/r/20191230203811.4996-1-sargun@sargun.me
Fixes: 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/seccomp/seccomp_bpf.c |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/seccomp/seccomp_bpf.c
+++ b/tools/testing/selftests/seccomp/seccomp_bpf.c
@@ -3147,7 +3147,18 @@ TEST(user_notification_basic)
 	EXPECT_GT(poll(&pollfd, 1, -1), 0);
 	EXPECT_EQ(pollfd.revents, POLLIN);
 
-	EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
+	/* Test that we can't pass garbage to the kernel. */
+	memset(&req, 0, sizeof(req));
+	req.pid = -1;
+	errno = 0;
+	ret = ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req);
+	EXPECT_EQ(-1, ret);
+	EXPECT_EQ(EINVAL, errno);
+
+	if (ret) {
+		req.pid = 0;
+		EXPECT_EQ(ioctl(listener, SECCOMP_IOCTL_NOTIF_RECV, &req), 0);
+	}
 
 	pollfd.fd = listener;
 	pollfd.events = POLLIN | POLLOUT;


