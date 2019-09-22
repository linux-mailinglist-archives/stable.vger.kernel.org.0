Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9240FBA983
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbfIVTQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:16:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438498AbfIVS4K (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:56:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BE3F206C2;
        Sun, 22 Sep 2019 18:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178569;
        bh=C6bM2lkrmxaRi+8ngCo47RBCDNww5tM1dx0eSaBFFeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sr40dr0AdoX857ivPHkOroiNJsrLT8JHm3OhzZ3COc7nMBkj1lmSeEpZPpi9cS9tm
         +fhlwWsgZqHL0JGbQI/EKkpNPgeuFtyI8Uekd0bb61zOazITv3KuECFetvvvkHN3rg
         VKhSHZBRguZlrpGsAqRCtmXvl4xe4P4Mss2AtHA8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Peterson <benjamin@python.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 081/128] perf trace beauty ioctl: Fix off-by-one error in cmd->string table
Date:   Sun, 22 Sep 2019 14:53:31 -0400
Message-Id: <20190922185418.2158-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185418.2158-1-sashal@kernel.org>
References: <20190922185418.2158-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Peterson <benjamin@python.org>

[ Upstream commit b92675f4a9c02dd78052645597dac9e270679ddf ]

While tracing a program that calls isatty(3), I noticed that strace
reported TCGETS for the request argument of the underlying ioctl(2)
syscall while perf trace reported TCSETS. strace is corrrect. The bug in
perf was due to the tty ioctl beauty table starting at 0x5400 rather
than 0x5401.

Committer testing:

  Using augmented_raw_syscalls.o and settings to make 'perf trace'
  use strace formatting, i.e. with this in ~/.perfconfig

  # cat ~/.perfconfig
  [trace]
	add_events = /home/acme/git/linux/tools/perf/examples/bpf/augmented_raw_syscalls.c
	show_zeros = yes
	show_duration = no
	no_inherit = yes
	show_timestamp = no
	show_arg_names = no
	args_alignment = 40
	show_prefix = yes

  # strace -e ioctl stty > /dev/null
  ioctl(0, TCGETS, {B38400 opost isig icanon echo ...}) = 0
  ioctl(1, TIOCGWINSZ, 0x7fff8a9b0860)    = -1 ENOTTY (Inappropriate ioctl for device)
  ioctl(1, TCGETS, 0x7fff8a9b0540)        = -1 ENOTTY (Inappropriate ioctl for device)
  +++ exited with 0 +++
  #

Before:

  # perf trace -e ioctl stty > /dev/null
  ioctl(0, TCSETS, 0x7fff2cf79f20)        = 0
  ioctl(1, TIOCSWINSZ, 0x7fff2cf79f40)    = -1 ENOTTY (Inappropriate ioctl for device)
  ioctl(1, TCSETS, 0x7fff2cf79c20)        = -1 ENOTTY (Inappropriate ioctl for device)
  #

After:

  # perf trace -e ioctl stty > /dev/null
  ioctl(0, TCGETS, 0x7ffed0763920)        = 0
  ioctl(1, TIOCGWINSZ, 0x7ffed0763940)    = -1 ENOTTY (Inappropriate ioctl for device)
  ioctl(1, TCGETS, 0x7ffed0763620)        = -1 ENOTTY (Inappropriate ioctl for device)
  #

Signed-off-by: Benjamin Peterson <benjamin@python.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Fixes: 1cc47f2d46206d67285aea0ca7e8450af571da13 ("perf trace beauty ioctl: Improve 'cmd' beautifier")
Link: http://lkml.kernel.org/r/20190823033625.18814-1-benjamin@python.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/trace/beauty/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/trace/beauty/ioctl.c b/tools/perf/trace/beauty/ioctl.c
index 1be3b4cf08270..82346ca06f171 100644
--- a/tools/perf/trace/beauty/ioctl.c
+++ b/tools/perf/trace/beauty/ioctl.c
@@ -22,7 +22,7 @@
 static size_t ioctl__scnprintf_tty_cmd(int nr, int dir, char *bf, size_t size)
 {
 	static const char *ioctl_tty_cmd[] = {
-	"TCGETS", "TCSETS", "TCSETSW", "TCSETSF", "TCGETA", "TCSETA", "TCSETAW",
+	[_IOC_NR(TCGETS)] = "TCGETS", "TCSETS", "TCSETSW", "TCSETSF", "TCGETA", "TCSETA", "TCSETAW",
 	"TCSETAF", "TCSBRK", "TCXONC", "TCFLSH", "TIOCEXCL", "TIOCNXCL", "TIOCSCTTY",
 	"TIOCGPGRP", "TIOCSPGRP", "TIOCOUTQ", "TIOCSTI", "TIOCGWINSZ", "TIOCSWINSZ",
 	"TIOCMGET", "TIOCMBIS", "TIOCMBIC", "TIOCMSET", "TIOCGSOFTCAR", "TIOCSSOFTCAR",
-- 
2.20.1

