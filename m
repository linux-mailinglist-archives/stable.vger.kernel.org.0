Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A80652BC03
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 00:38:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbfE0Wh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 18:37:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:43646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbfE0Wh6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 May 2019 18:37:58 -0400
Received: from quaco.ghostprotocols.net (179-240-171-7.3g.claro.net.br [179.240.171.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E8302081C;
        Mon, 27 May 2019 22:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558996677;
        bh=prJoLJpZvpsZ7UJpa2S3f+0ldYisIx7ao2Qz6rGLRPY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=erkoh2AmuokRSfXO3rbITFZB1/OrNXFlJ9XFCucTmKBLBT9Rs6xBDBLLLs2STdw1O
         tUeWRz2aOI3TpEb7ftLkX4yCkkJRFXvYo5hdSO2PbcKT8TToTSgdlkmCXmfyrrhPj7
         i0RaLIGGhR72ufweAm7w6TKuns0AA7RMDZhqSlvU=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>, stable@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/44] perf intel-pt: Fix itrace defaults for perf script intel-pt documentation
Date:   Mon, 27 May 2019 19:36:50 -0300
Message-Id: <20190527223730.11474-5-acme@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190527223730.11474-1-acme@kernel.org>
References: <20190527223730.11474-1-acme@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Fix intel-pt documentation to reflect the change of itrace defaults for
perf script.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 4eb068157121 ("perf script: Make itrace script default to all calls")
Link: http://lkml.kernel.org/r/20190520113728.14389-4-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/intel-pt.txt | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/tools/perf/Documentation/intel-pt.txt b/tools/perf/Documentation/intel-pt.txt
index 115eaacc455f..60d99e5e7921 100644
--- a/tools/perf/Documentation/intel-pt.txt
+++ b/tools/perf/Documentation/intel-pt.txt
@@ -88,16 +88,16 @@ smaller.
 
 To represent software control flow, "branches" samples are produced.  By default
 a branch sample is synthesized for every single branch.  To get an idea what
-data is available you can use the 'perf script' tool with no parameters, which
-will list all the samples.
+data is available you can use the 'perf script' tool with all itrace sampling
+options, which will list all the samples.
 
 	perf record -e intel_pt//u ls
-	perf script
+	perf script --itrace=ibxwpe
 
 An interesting field that is not printed by default is 'flags' which can be
 displayed as follows:
 
-	perf script -Fcomm,tid,pid,time,cpu,event,trace,ip,sym,dso,addr,symoff,flags
+	perf script --itrace=ibxwpe -F+flags
 
 The flags are "bcrosyiABEx" which stand for branch, call, return, conditional,
 system, asynchronous, interrupt, transaction abort, trace begin, trace end, and
@@ -713,7 +713,7 @@ Having no option is the same as
 
 which, in turn, is the same as
 
-	--itrace=ibxwpe
+	--itrace=cepwx
 
 The letters are:
 
-- 
2.20.1

