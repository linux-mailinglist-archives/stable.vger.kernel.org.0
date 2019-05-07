Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F3CC15924
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbfEGFeL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:34:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:54052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727444AbfEGFeK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:34:10 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB73C20989;
        Tue,  7 May 2019 05:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207249;
        bh=7Z761sNeO2nvTu5s6V6Emy+f8PxvWLCpKr4OVlqQjQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oL1Ft6cXRMISbzGfqyD+kMpJ7cjlBiLWhLmjfnuoT7Z3MFaTKbDGdQcL5HSecAFkH
         XWBrOpyROyKwaZrfmr9V28G4O78P3W0ffcRaL1jQGdZZPWE6D/OIKPc4dtTQtGPALb
         w+O/v+bLV5+IWl+tTnEHJ4an4JHT1cf6jrU7FVls=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Bastian Beischer <bastian.beischer@rwth-aachen.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 50/99] perf top: Always sample time to satisfy needs of use of ordered queuing
Date:   Tue,  7 May 2019 01:31:44 -0400
Message-Id: <20190507053235.29900-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053235.29900-1-sashal@kernel.org>
References: <20190507053235.29900-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 1e6db2ee86e6a4399fc0ae5689e55e0fd1c43caf ]

Bastian reported broken 'perf top -p PID' command, it won't display any
data.

The problem is that for -p option we monitor single thread, so we don't
enable time in samples, because it's not needed.

However since commit 16c66bc167cc we use ordered queues to stash data
plus later commits added logic for dropping samples in case there's big
load and we don't keep up. All this needs timestamp for sample. Enabling
it unconditionally for perf top.

Reported-by: Bastian Beischer <bastian.beischer@rwth-aachen.de>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: bastian beischer <bastian.beischer@rwth-aachen.de>
Fixes: 16c66bc167cc ("perf top: Add processing thread")
Link: http://lkml.kernel.org/r/20190415125333.27160-1-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-top.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 616408251e25..63750a711123 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1393,6 +1393,7 @@ int cmd_top(int argc, const char **argv)
 			 * */
 			.overwrite	= 0,
 			.sample_time	= true,
+			.sample_time_set = true,
 		},
 		.max_stack	     = sysctl__max_stack(),
 		.annotation_opts     = annotation__default_options,
-- 
2.20.1

