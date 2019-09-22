Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05924BAA51
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727834AbfIVTYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:24:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407969AbfIVSwo (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:52:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DF332190F;
        Sun, 22 Sep 2019 18:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178363;
        bh=V0RnYzcQU1XuCrNHFEnrM5GjrBtSWIbwGLuJ+vIGQHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VV1ABf3LDQBQiUOgKB85wSf5L5Lnjn8Bbo0FfznFmGM/EZF4M+HuhTlYa+Tj7ahIV
         hA/dcp578O1JU/nwih0SgdqmmAP4gaVwvVoIneH5YxLHfC05iEDTdtOfKkXl5JuwD0
         lANs+w0NzMtx13sDusVi9STa1gxEtW4aXw3H5Ug8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Peterson <benjamin@python.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 116/185] perf trace beauty ioctl: Fix off-by-one error in cmd->string table
Date:   Sun, 22 Sep 2019 14:48:14 -0400
Message-Id: <20190922184924.32534-116-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
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
index 52242fa4072b0..e19eb6ea361d7 100644
--- a/tools/perf/trace/beauty/ioctl.c
+++ b/tools/perf/trace/beauty/ioctl.c
@@ -21,7 +21,7 @@
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

