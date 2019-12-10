Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5E0011998F
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbfLJVq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:46:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:36176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728853AbfLJVce (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:32:34 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5851020836;
        Tue, 10 Dec 2019 21:32:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013554;
        bh=xPgGuolIKBBRLmnIyzp9EhLsKOvFYf4peESXy1Y6SXw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Jf7nJ3tiLkwiICGYsKyY0Loafb9KtJKSAF21TCFvheac4gSBn/2KUYwIRpS09nTm
         /W7xw+F2eNJxGEKZ1QsIBjfAv4ob/rnpOJUkIFbqZJYO2bfsN4NrO5q1CZpJjUUXLU
         Guqwv5GWS9Tsuv+JSh7lchpBdckEyg3m6BncX7Fs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brendan Higgins <brendanhiggins@google.com>,
        kbuild test robot <lkp@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 010/177] objtool: add kunit_try_catch_throw to the noreturn list
Date:   Tue, 10 Dec 2019 16:29:34 -0500
Message-Id: <20191210213221.11921-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brendan Higgins <brendanhiggins@google.com>

[ Upstream commit 33adf80f5b52e3f7c55ad66ffcaaff93c6888aaa ]

Fix the following warning seen on GCC 7.3:
  kunit/test-test.o: warning: objtool: kunit_test_unsuccessful_try() falls through to next function kunit_test_catch()

kunit_try_catch_throw is a function added in the following patch in this
series; it allows KUnit, a unit testing framework for the kernel, to
bail out of a broken test. As a consequence, it is a new __noreturn
function that objtool thinks is broken (as seen above). So fix this
warning by adding kunit_try_catch_throw to objtool's noreturn list.

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
Acked-by: Josh Poimboeuf <jpoimboe@redhat.com>
Link: https://www.spinics.net/lists/linux-kbuild/msg21708.html
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index ecf5fc77f50b5..89a1a34fffb10 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -168,6 +168,7 @@ static int __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"usercopy_abort",
 		"machine_real_restart",
 		"rewind_stack_do_exit",
+		"kunit_try_catch_throw",
 	};
 
 	if (func->bind == STB_WEAK)
-- 
2.20.1

