Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C047BAB04
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:54:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391012AbfIVTdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 15:33:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:43982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390965AbfIVSrc (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:47:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 34434214AF;
        Sun, 22 Sep 2019 18:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178052;
        bh=0DwUbrY2gMUOyVzwXRowA3D8idnT6qABSLQ/kcuTbkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMIXjIdgm8dpurdyoGZFCVK+1tqqdzaoXQBxG9GpgNkQZmV66yPe5Zu3UHY4YbOtd
         wQkNyTomqyoC+mTGpF7Xp+ono/VTJxiTgNbQn0ZL5abICKEgEgR0r98Oecu9P0SSzb
         EDciRs/wpEqHlrE614nrJ+lnMi950d2QOE0U6j6c=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 129/203] perf script: Fix memory leaks in list_scripts()
Date:   Sun, 22 Sep 2019 14:42:35 -0400
Message-Id: <20190922184350.30563-129-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

[ Upstream commit 3b4acbb92dbda4829e021e5c6d5410658849fa1c ]

In case memory resources for *buf* and *paths* were allocated, jump to
*out* and release them before return.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Gustavo A. R. Silva <gustavo@embeddedor.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Addresses-Coverity-ID: 1444328 ("Resource leak")
Fixes: 6f3da20e151f ("perf report: Support builtin perf script in scripts menu")
Link: http://lkml.kernel.org/r/20190408162748.GA21008@embeddedor
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/ui/browsers/scripts.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browsers/scripts.c b/tools/perf/ui/browsers/scripts.c
index 4d565cc14076c..0355d4aaf2eed 100644
--- a/tools/perf/ui/browsers/scripts.c
+++ b/tools/perf/ui/browsers/scripts.c
@@ -131,8 +131,10 @@ static int list_scripts(char *script_name, bool *custom,
 		int key = ui_browser__input_window("perf script command",
 				"Enter perf script command line (without perf script prefix)",
 				script_args, "", 0);
-		if (key != K_ENTER)
-			return -1;
+		if (key != K_ENTER) {
+			ret = -1;
+			goto out;
+		}
 		sprintf(script_name, "%s script %s", perf, script_args);
 	} else if (choice < num + max_std) {
 		strcpy(script_name, paths[choice]);
-- 
2.20.1

