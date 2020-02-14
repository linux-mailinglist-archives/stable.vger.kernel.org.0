Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0062315DE95
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389827AbgBNQEB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:04:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:51774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388942AbgBNQEB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:04:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB3E9217F4;
        Fri, 14 Feb 2020 16:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696240;
        bh=kwYS4IJqe/CCzOFwvS5e6qcl5rOhH6tgd+nA24huEr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O8fD+BQoxM4RL31O0K3xj15fcuBrYOGU18W3evVXBjHkTdi1X5tapkl0XncXl+qY0
         lY1Nl0wZEAN+sRKdg497QPGPgqP/8CDfNNPDVIoRm6KXk6YyIjFvMODzM+rfX3Y4qI
         iK9k7PN0vkd5y5yCTS+IGEfwQi5att6R00kB6Ktk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        Kees Cook <keescook@chromium.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 099/459] selftests: settings: tests can be in subsubdirs
Date:   Fri, 14 Feb 2020 10:55:49 -0500
Message-Id: <20200214160149.11681-99-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthieu Baerts <matthieu.baerts@tessares.net>

[ Upstream commit ac87813d4372f4c005264acbe3b7f00c1dee37c4 ]

Commit 852c8cbf34d3 ("selftests/kselftest/runner.sh: Add 45 second
timeout per test") adds support for a new per-test-directory "settings"
file. But this only works for tests not in a sub-subdirectories, e.g.

 - tools/testing/selftests/rtc (rtc) is OK,
 - tools/testing/selftests/net/mptcp (net/mptcp) is not.

We have to increase the timeout for net/mptcp tests which are not
upstreamed yet but this fix is valid for other tests if they need to add
a "settings" file, see the full list with:

  tools/testing/selftests/*/*/**/Makefile

Note that this patch changes the text header message printed at the end
of the execution but this text is modified only for the tests that are
in sub-subdirectories, e.g.

  ok 1 selftests: net/mptcp: mptcp_connect.sh

Before we had:

  ok 1 selftests: mptcp: mptcp_connect.sh

But showing the full target name is probably better, just in case a
subsubdir has the same name as another one in another subdirectory.

Fixes: 852c8cbf34d3 (selftests/kselftest/runner.sh: Add 45 second timeout per test)
Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest/runner.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kselftest/runner.sh b/tools/testing/selftests/kselftest/runner.sh
index a8d20cbb711cf..e84d901f85672 100644
--- a/tools/testing/selftests/kselftest/runner.sh
+++ b/tools/testing/selftests/kselftest/runner.sh
@@ -91,7 +91,7 @@ run_one()
 run_many()
 {
 	echo "TAP version 13"
-	DIR=$(basename "$PWD")
+	DIR="${PWD#${BASE_DIR}/}"
 	test_num=0
 	total=$(echo "$@" | wc -w)
 	echo "1..$total"
-- 
2.20.1

