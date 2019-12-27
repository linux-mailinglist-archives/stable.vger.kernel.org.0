Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8045012B8A0
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbfL0R5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:57:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:38340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727617AbfL0Rlv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:41:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EECC7222C3;
        Fri, 27 Dec 2019 17:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468510;
        bh=EydVJe9a2aFceUo5JpBojCfmSL5Lb+6U5EVpz1YQors=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcQH1k2S8rmSmk496usrwWckQZ6jw9H1vlHpMRAtpCS03A88KuDsBjQKwsX8Qg8mm
         JyXdjYj1CZtYmXwKZKHvN/JFKJZYIvfvkS4g5cjQ7f5U93x9B+Y1aQsUufWNyu2oOu
         8RQyTtC7QW5f+uUP2x/7zyTbUXh0VPlNiNngK46s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 043/187] selftests/ftrace: Fix multiple kprobe testcase
Date:   Fri, 27 Dec 2019 12:38:31 -0500
Message-Id: <20191227174055.4923-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174055.4923-1-sashal@kernel.org>
References: <20191227174055.4923-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 5cc6c8d4a99d0ee4d5466498e258e593df1d3eb6 ]

Fix multiple kprobe event testcase to work it correctly.
There are 2 bugfixes.
 - Since `wc -l FILE` returns not only line number but also
   FILE filename, following "if" statement always failed.
   Fix this bug by replacing it with 'cat FILE | wc -l'
 - Since "while do-done loop" block with pipeline becomes a
   subshell, $N local variable is not update outside of
   the loop.
   Fix this bug by using actual target number (256) instead
   of $N.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/ftrace/test.d/kprobe/multiple_kprobes.tc      | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/ftrace/test.d/kprobe/multiple_kprobes.tc b/tools/testing/selftests/ftrace/test.d/kprobe/multiple_kprobes.tc
index 5862eee91e1d..6e3dbe5f96b7 100644
--- a/tools/testing/selftests/ftrace/test.d/kprobe/multiple_kprobes.tc
+++ b/tools/testing/selftests/ftrace/test.d/kprobe/multiple_kprobes.tc
@@ -20,9 +20,9 @@ while read i; do
   test $N -eq 256 && break
 done
 
-L=`wc -l kprobe_events`
-if [ $L -ne $N ]; then
-  echo "The number of kprobes events ($L) is not $N"
+L=`cat kprobe_events | wc -l`
+if [ $L -ne 256 ]; then
+  echo "The number of kprobes events ($L) is not 256"
   exit_fail
 fi
 
-- 
2.20.1

