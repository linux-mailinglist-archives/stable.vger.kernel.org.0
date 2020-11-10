Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B57E2ACD98
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:04:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732460AbgKJED2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 23:03:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:55876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732876AbgKJDyu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:54:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E38AC208FE;
        Tue, 10 Nov 2020 03:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980489;
        bh=zAo+rX/HJd0EhyEP4ZjfM0EPLEC2xbl048pitavwzjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSuBrWIKX4860vrm+fDSjA7E5dbf78EKhjasx3hEMnpEs7pTwzl3llzw5QutpphXH
         3OeJUiw+yYIFTSs3b6xzukrvkMOqBihnht1/+GARTFO2EUqYaDCS4yxD0dinAGkRcU
         fCZAm6NR0f2KHxM5V4XRSY5gVjwWJE5CKf1e8giA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 06/42] selftests/ftrace: check for do_sys_openat2 in user-memory test
Date:   Mon,  9 Nov 2020 22:54:04 -0500
Message-Id: <20201110035440.424258-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035440.424258-1-sashal@kernel.org>
References: <20201110035440.424258-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit e3e40312567087fbe6880f316cb2b0e1f3d8a82c ]

More recent libc implementations are now using openat/openat2 system
calls so also add do_sys_openat2 to the tracing so that the test
passes on these systems because do_sys_open may not be called.

Thanks to Masami Hiramatsu for the help on getting this fix to work
correctly.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/ftrace/test.d/kprobe/kprobe_args_user.tc        | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_user.tc b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_user.tc
index 0f60087583d8f..a753c73d869ab 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_user.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/kprobe_args_user.tc
@@ -11,12 +11,16 @@ grep -A10 "fetcharg:" README | grep -q '\[u\]<offset>' || exit_unsupported
 :;: "user-memory access syntax and ustring working on user memory";:
 echo 'p:myevent do_sys_open path=+0($arg2):ustring path2=+u0($arg2):string' \
 	> kprobe_events
+echo 'p:myevent2 do_sys_openat2 path=+0($arg2):ustring path2=+u0($arg2):string' \
+	>> kprobe_events
 
 grep myevent kprobe_events | \
 	grep -q 'path=+0($arg2):ustring path2=+u0($arg2):string'
 echo 1 > events/kprobes/myevent/enable
+echo 1 > events/kprobes/myevent2/enable
 echo > /dev/null
 echo 0 > events/kprobes/myevent/enable
+echo 0 > events/kprobes/myevent2/enable
 
 grep myevent trace | grep -q 'path="/dev/null" path2="/dev/null"'
 
-- 
2.27.0

