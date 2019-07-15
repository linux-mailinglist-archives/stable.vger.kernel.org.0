Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE36968C25
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 15:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730607AbfGONt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 09:49:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730347AbfGONt1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 09:49:27 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 914942083D;
        Mon, 15 Jul 2019 13:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198567;
        bh=SDZnlxReGbUHEbh3F9XiUbaTFPuTAyuqLbFVyaw5hbM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hhRCwox5wKqPVY2UZ+4cvNJMr8MaH++y1eVK5S1M6QWHGFR94FfmRjqMPCVpPK0gL
         vmhNM/UkVX4305RGKpdkgbaxpppWDVm8AabBVvCThHGnMrIvw786s+YGUEj9LtGW9g
         L88nW8D928Je1+LMlbhw73AetJY1PU7Hxs6jULlM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 5.2 046/249] perf annotate TUI browser: Do not use member from variable within its own initialization
Date:   Mon, 15 Jul 2019 09:43:31 -0400
Message-Id: <20190715134655.4076-46-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit da2019633f0b5c105ce658aada333422d8cb28fe ]

Some compilers will complain when using a member of a struct to
initialize another member, in the same struct initialization.

For instance:

  debian:8      Debian clang version 3.5.0-10 (tags/RELEASE_350/final) (based on LLVM 3.5.0)
  oraclelinux:7 clang version 3.4.2 (tags/RELEASE_34/dot2-final)

Produce:

  ui/browsers/annotate.c:104:12: error: variable 'ops' is uninitialized when used within its own initialization [-Werror,-Wuninitialized]
                                              (!ops.current_entry ||
                                                ^~~
  1 error generated.

So use an extra variable, initialized just before that struct, to have
the value used in the expressions used to init two of the struct
members.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Fixes: c298304bd747 ("perf annotate: Use a ops table for annotation_line__write()")
Link: https://lkml.kernel.org/n/tip-f9nexro58q62l3o9hez8hr0i@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/ui/browsers/annotate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 98d934a36d86..b0d089a95dac 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -97,11 +97,12 @@ static void annotate_browser__write(struct ui_browser *browser, void *entry, int
 	struct annotate_browser *ab = container_of(browser, struct annotate_browser, b);
 	struct annotation *notes = browser__annotation(browser);
 	struct annotation_line *al = list_entry(entry, struct annotation_line, node);
+	const bool is_current_entry = ui_browser__is_current_entry(browser, row);
 	struct annotation_write_ops ops = {
 		.first_line		 = row == 0,
-		.current_entry		 = ui_browser__is_current_entry(browser, row),
+		.current_entry		 = is_current_entry,
 		.change_color		 = (!notes->options->hide_src_code &&
-					    (!ops.current_entry ||
+					    (!is_current_entry ||
 					     (browser->use_navkeypressed &&
 					      !browser->navkeypressed))),
 		.width			 = browser->width,
-- 
2.20.1

