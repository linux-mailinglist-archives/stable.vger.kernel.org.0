Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAF1A137FC3
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728979AbgAKKWh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:22:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:48082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730700AbgAKKWg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:22:36 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A645120848;
        Sat, 11 Jan 2020 10:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578738155;
        bh=eH1Bug+ns69eCl4OYezFufgJ/9UJKJoBq0c4gH/24ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UlVxlwa66Iv0vER4Cql27a4hAxVQPXbbDplC5kWdl4ddcMxPeuND06tjRYJwto+02
         ZtEwcpJxBWp0NhGPe2wXNIbLewtEcwdb04uxRSTkztFP2Nru6dMLrZpSjYvN5LghnW
         E9+BqlJys+gxs6bQLyiWP6W2Tl0CVHJ+GCygC41U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/165] selftests: safesetid: Check the return value of setuid/setgid
Date:   Sat, 11 Jan 2020 10:49:18 +0100
Message-Id: <20200111094924.299300756@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094921.347491861@linuxfoundation.org>
References: <20200111094921.347491861@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



