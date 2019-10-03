Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED2ACAABC
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:26:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388851AbfJCRMO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390445AbfJCQaj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:30:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0844620700;
        Thu,  3 Oct 2019 16:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120238;
        bh=SDlAYI9BhqBHRdwdkMZlPxl5JV58fBNfvFUMaH7kJuQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zeccw3kcw059DsjUHAneiuyltUE2eFhm3/NoE7WJvAFVpLINZmn4Jh4Bvb//1zd7D
         0NH/65XgDGWFSsqR4PhO7UaS9KeWGKHIMugfk8n7UIF6nONJEeHZjYdKd5UAUDGaGi
         djZApuC86NNTSonTMcx/sXUXufqhvL3REBqt9nkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 147/313] perf script: Fix memory leaks in list_scripts()
Date:   Thu,  3 Oct 2019 17:52:05 +0200
Message-Id: <20191003154547.411558084@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

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
index 27cf3ab88d13f..f4edb18f67ec9 100644
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



