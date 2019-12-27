Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1752812B87E
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfL0Rly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:41:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:38374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727631AbfL0Rlx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:53 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2425721D7E;
        Fri, 27 Dec 2019 17:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468512;
        bh=eH1Bug+ns69eCl4OYezFufgJ/9UJKJoBq0c4gH/24ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oG1Lry8mWvrznFXE1RGWhj9mxQ+Xvkt/GuaVExuq2eIbaVPq/FPoERnR+Cn6o9qYy
         MntxX7JGQQ46Ty1pQ2Bg9rFFDGx3YgtBH8lQ3pWbDkV2MjZUgDr5x8H31kyTXGfJtM
         3ser/dhoey3jH19cf6KR9K6YdsN8AE3jsi7GFZqU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 045/187] selftests: safesetid: Check the return value of setuid/setgid
Date:   Fri, 27 Dec 2019 12:38:33 -0500
Message-Id: <20191227174055.4923-45-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 295c4e21cf27ac9af542140e3e797df9e0cf7b5f ]

Check the return value of setuid() and setgid().
This fixes the following warnings and improves test result.

safesetid-test.c: In function ‘main’:
safesetid-test.c:294:2: warning: ignoring return value of ‘setuid’, declared with attribute warn_unused_result [-Wunused-result]
  setuid(NO_POLICY_USER);
  ^~~~~~~~~~~~~~~~~~~~~~
safesetid-test.c:295:2: warning: ignoring return value of ‘setgid’, declared with attribute warn_unused_result [-Wunused-result]
  setgid(NO_POLICY_USER);
  ^~~~~~~~~~~~~~~~~~~~~~
safesetid-test.c:309:2: warning: ignoring return value of ‘setuid’, declared with attribute warn_unused_result [-Wunused-result]
  setuid(RESTRICTED_PARENT);
  ^~~~~~~~~~~~~~~~~~~~~~~~~
safesetid-test.c:310:2: warning: ignoring return value of ‘setgid’, declared with attribute warn_unused_result [-Wunused-result]
  setgid(RESTRICTED_PARENT);
  ^~~~~~~~~~~~~~~~~~~~~~~~~
safesetid-test.c: In function ‘test_setuid’:
safesetid-test.c:216:3: warning: ignoring return value of ‘setuid’, declared with attribute warn_unused_result [-Wunused-result]
   setuid(child_uid);
   ^~~~~~~~~~~~~~~~~

Fixes: c67e8ec03f3f ("LSM: SafeSetID: add selftest")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/safesetid/safesetid-test.c  | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/safesetid/safesetid-test.c b/tools/testing/selftests/safesetid/safesetid-test.c
index 8f40c6ecdad1..0c4d50644c13 100644
--- a/tools/testing/selftests/safesetid/safesetid-test.c
+++ b/tools/testing/selftests/safesetid/safesetid-test.c
@@ -213,7 +213,8 @@ static void test_setuid(uid_t child_uid, bool expect_success)
 	}
 
 	if (cpid == 0) {	    /* Code executed by child */
-		setuid(child_uid);
+		if (setuid(child_uid) < 0)
+			exit(EXIT_FAILURE);
 		if (getuid() == child_uid)
 			exit(EXIT_SUCCESS);
 		else
@@ -291,8 +292,10 @@ int main(int argc, char **argv)
 
 	// First test to make sure we can write userns mappings from a user
 	// that doesn't have any restrictions (as long as it has CAP_SETUID);
-	setuid(NO_POLICY_USER);
-	setgid(NO_POLICY_USER);
+	if (setuid(NO_POLICY_USER) < 0)
+		die("Error with set uid(%d)\n", NO_POLICY_USER);
+	if (setgid(NO_POLICY_USER) < 0)
+		die("Error with set gid(%d)\n", NO_POLICY_USER);
 
 	// Take away all but setid caps
 	drop_caps(true);
@@ -306,8 +309,10 @@ int main(int argc, char **argv)
 		die("test_userns failed when it should work\n");
 	}
 
-	setuid(RESTRICTED_PARENT);
-	setgid(RESTRICTED_PARENT);
+	if (setuid(RESTRICTED_PARENT) < 0)
+		die("Error with set uid(%d)\n", RESTRICTED_PARENT);
+	if (setgid(RESTRICTED_PARENT) < 0)
+		die("Error with set gid(%d)\n", RESTRICTED_PARENT);
 
 	test_setuid(ROOT_USER, false);
 	test_setuid(ALLOWED_CHILD1, true);
-- 
2.20.1

