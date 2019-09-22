Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 290D5BA57F
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 20:58:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394818AbfIVS6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391760AbfIVS6N (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:58:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBEF3214D9;
        Sun, 22 Sep 2019 18:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178692;
        bh=YguYYRHa7pxbgWOAPbbpBNA7eGUgBYUkdSRQ4YqKIUY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IGd6IpIRzqHgGQBZCOnZCK+1dnF8gfN4LY5I5SbNfQni/YDpaIbvt+QD9nDw5ejcY
         qlBXjM7MJ9xtGIJmfyAU1+Y66UWDnrZ5ikj78xN/6zD5Ed5WQ/nt9DM5iT4pe/sxN2
         lRE/KaOopHkZi+sQm0bmDq8B8MXME5rDfyvtjJQo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        =?UTF-8?q?Luis=20Cl=C3=A1udio=20Gon=C3=A7alves?= 
        <lclaudio@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Taeung Song <treeze.taeung@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 33/89] perf test vfs_getname: Disable ~/.perfconfig to get default output
Date:   Sun, 22 Sep 2019 14:56:21 -0400
Message-Id: <20190922185717.3412-33-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922185717.3412-1-sashal@kernel.org>
References: <20190922185717.3412-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 4fe94ce1c6ba678b5f12b94bb9996eea4fc99e85 ]

To get the expected output we have to ignore whatever changes the user
has in its ~/.perfconfig file, so set PERF_CONFIG to /dev/null to
achieve that.

Before:

  # egrep 'trace|show_' ~/.perfconfig
  [trace]
  	show_zeros = yes
  	show_duration = no
  	show_timestamp = no
  	show_arg_names = no
  	show_prefix = yes
  # echo $PERF_CONFIG

  # perf test "trace + vfs_getname"
  70: Check open filename arg using perf trace + vfs_getname: FAILED!
  # export PERF_CONFIG=/dev/null
  # perf test "trace + vfs_getname"
  70: Check open filename arg using perf trace + vfs_getname: Ok
  #

After:

  # egrep 'trace|show_' ~/.perfconfig
  [trace]
  	show_zeros = yes
  	show_duration = no
  	show_timestamp = no
  	show_arg_names = no
  	show_prefix = yes
  # echo $PERF_CONFIG

  # perf test "trace + vfs_getname"
  70: Check open filename arg using perf trace + vfs_getname: Ok
  #

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Luis Cláudio Gonçalves <lclaudio@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Taeung Song <treeze.taeung@gmail.com>
Link: https://lkml.kernel.org/n/tip-3up27pexg5i3exuzqrvt4m8u@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/trace+probe_vfs_getname.sh | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/tests/shell/trace+probe_vfs_getname.sh b/tools/perf/tests/shell/trace+probe_vfs_getname.sh
index 2a9ef080efd02..a8a516dec4ed2 100755
--- a/tools/perf/tests/shell/trace+probe_vfs_getname.sh
+++ b/tools/perf/tests/shell/trace+probe_vfs_getname.sh
@@ -30,6 +30,10 @@ if [ $err -ne 0 ] ; then
 	exit $err
 fi
 
+# Do not use whatever ~/.perfconfig file, it may change the output
+# via trace.{show_timestamp,show_prefix,etc}
+export PERF_CONFIG=/dev/null
+
 trace_open_vfs_getname
 err=$?
 rm -f ${file}
-- 
2.20.1

