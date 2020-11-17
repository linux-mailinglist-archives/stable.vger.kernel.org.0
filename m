Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D86DF2B64CE
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:50:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733055AbgKQNt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:49:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:42906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732342AbgKQNc4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:32:56 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8D0DD2078E;
        Tue, 17 Nov 2020 13:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619975;
        bh=FAz45edYcDOPoU1UEOnqtcQ0Iju9wq3mNRIDKwqj654=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n6bBIEjkYo6puqeXlI1oAftmgRt6hyCg81QvXaQ2oWeT9lDgl1vY/UJ1mQSG6wd3J
         +cqieWBx6iA/uG7ijviz2cweGWvcE+k4lgU+YCgo6tRlvWAwjjY6lFJJflBP96cbP/
         JSqCf1PCAWyFy274w/bLFpZaAze3k8WaHvsrP1ho=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tommi Rantala <tommi.t.rantala@nokia.com>,
        Kees Cook <keescook@chromium.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 067/255] selftests: binderfs: use SKIP instead of XFAIL
Date:   Tue, 17 Nov 2020 14:03:27 +0100
Message-Id: <20201117122142.213045519@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tommi Rantala <tommi.t.rantala@nokia.com>

[ Upstream commit 7d764b685ee1bc73a9fa2b6cb4d42fa72b943145 ]

XFAIL is gone since commit 9847d24af95c ("selftests/harness: Refactor XFAIL
into SKIP"), use SKIP instead.

Fixes: 9847d24af95c ("selftests/harness: Refactor XFAIL into SKIP")
Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/filesystems/binderfs/binderfs_test.c        | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/filesystems/binderfs/binderfs_test.c b/tools/testing/selftests/filesystems/binderfs/binderfs_test.c
index 1d27f52c61e61..477cbb042f5ba 100644
--- a/tools/testing/selftests/filesystems/binderfs/binderfs_test.c
+++ b/tools/testing/selftests/filesystems/binderfs/binderfs_test.c
@@ -74,7 +74,7 @@ static int __do_binderfs_test(struct __test_metadata *_metadata)
 	ret = mount(NULL, binderfs_mntpt, "binder", 0, 0);
 	EXPECT_EQ(ret, 0) {
 		if (errno == ENODEV)
-			XFAIL(goto out, "binderfs missing");
+			SKIP(goto out, "binderfs missing");
 		TH_LOG("%s - Failed to mount binderfs", strerror(errno));
 		goto rmdir;
 	}
@@ -475,10 +475,10 @@ TEST(binderfs_stress)
 TEST(binderfs_test_privileged)
 {
 	if (geteuid() != 0)
-		XFAIL(return, "Tests are not run as root. Skipping privileged tests");
+		SKIP(return, "Tests are not run as root. Skipping privileged tests");
 
 	if (__do_binderfs_test(_metadata))
-		XFAIL(return, "The Android binderfs filesystem is not available");
+		SKIP(return, "The Android binderfs filesystem is not available");
 }
 
 TEST(binderfs_test_unprivileged)
@@ -511,7 +511,7 @@ TEST(binderfs_test_unprivileged)
 	ret = wait_for_pid(pid);
 	if (ret) {
 		if (ret == 2)
-			XFAIL(return, "The Android binderfs filesystem is not available");
+			SKIP(return, "The Android binderfs filesystem is not available");
 		ASSERT_EQ(ret, 0) {
 			TH_LOG("wait_for_pid() failed");
 		}
-- 
2.27.0



