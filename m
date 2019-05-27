Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7213A2BC07
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 00:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727500AbfE0Whz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 May 2019 18:37:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:43624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbfE0Why (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 May 2019 18:37:54 -0400
Received: from quaco.ghostprotocols.net (179-240-171-7.3g.claro.net.br [179.240.171.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 637E520859;
        Mon, 27 May 2019 22:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558996674;
        bh=uZwNlhBK32PUMxr2O23ngaSNno2a+GCU1RyguvKiISY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w++ILzXEqQRYEvJtAlS6GZjWu3sFtI8RuJA1f+YGK1AZ3XyrQ5zFIHFS314Uq6God
         QL5ZR6eDHl4bXwZ3cWo26/xAVe7+HiN8T+TLpbhHpOJnZ6LiMDA2btaXc7Xuh/ZCqW
         50CBufLtEIz6Mgjn1LOCshxk60f/7K1ayNdVBzTc=
From:   Arnaldo Carvalho de Melo <acme@kernel.org>
To:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Jiri Olsa <jolsa@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Clark Williams <williams@redhat.com>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, stable@vger.kernel.org
Subject: [PATCH 03/44] perf auxtrace: Fix itrace defaults for perf script
Date:   Mon, 27 May 2019 19:36:49 -0300
Message-Id: <20190527223730.11474-4-acme@kernel.org>
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

Commit 4eb068157121 ("perf script: Make itrace script default to all
calls") does not work for the case when '--itrace' only is used, because
default_no_sample is not being passed.

Example:

 Before:

  $ perf record -e intel_pt/cyc/u ls
  $ perf script --itrace > cmp1.txt
  $ perf script --itrace=cepwx > cmp2.txt
  $ diff -sq cmp1.txt cmp2.txt
  Files cmp1.txt and cmp2.txt differ

 After:

  $ perf script --itrace > cmp1.txt
  $ perf script --itrace=cepwx > cmp2.txt
  $ diff -sq cmp1.txt cmp2.txt
  Files cmp1.txt and cmp2.txt are identical

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 4eb068157121 ("perf script: Make itrace script default to all calls")
Link: http://lkml.kernel.org/r/20190520113728.14389-3-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/auxtrace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/auxtrace.c b/tools/perf/util/auxtrace.c
index fb76b6b232d4..5dd9d1893b89 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -1010,7 +1010,8 @@ int itrace_parse_synth_opts(const struct option *opt, const char *str,
 	}
 
 	if (!str) {
-		itrace_synth_opts__set_default(synth_opts, false);
+		itrace_synth_opts__set_default(synth_opts,
+					       synth_opts->default_no_sample);
 		return 0;
 	}
 
-- 
2.20.1

