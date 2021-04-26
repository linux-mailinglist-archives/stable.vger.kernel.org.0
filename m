Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAB236AE32
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhDZHlz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:41:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:50350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232788AbhDZHjt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:39:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 617FD613E3;
        Mon, 26 Apr 2021 07:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422711;
        bh=WA+hp9zzQ6k702CVT4hO1F/VsZZ0r5aaOv+Hng2CqMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IiEZHQ9NKXByavmcMk0aB7U5Pkr+Qw1KUx21nFxYfG4XFkkH02fh/+T53y4BgI8jO
         mOaJBdAA7l6LzNGcZ8cZUs5pqqlG8guawEjx/7zEBKZxaYPz/A9limbBj/gW0f0AAh
         wi23SR+Hnw21960Sl4EKH3/xJOofr2c2AonhFe48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tiezhu Yang <yangtiezhu@loongson.cn>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/20] perf auxtrace: Fix potential NULL pointer dereference
Date:   Mon, 26 Apr 2021 09:29:59 +0200
Message-Id: <20210426072816.958871353@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072816.686976183@linuxfoundation.org>
References: <20210426072816.686976183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit b14585d9f18dc617e975815570fe836be656b1da ]

In the function auxtrace_parse_snapshot_options(), the callback pointer
"itr->parse_snapshot_options" can be NULL if it has not been set during
the AUX record initialization.  This can cause tool crashing if the
callback pointer "itr->parse_snapshot_options" is dereferenced without
performing NULL check.

Add a NULL check for the pointer "itr->parse_snapshot_options" before
invoke the callback.

Fixes: d20031bb63dd6dde ("perf tools: Add AUX area tracing Snapshot Mode")
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Link: http://lore.kernel.org/lkml/20210420151554.2031768-1-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/auxtrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/auxtrace.c b/tools/perf/util/auxtrace.c
index 61b8dc45428f..ae5b97427192 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -586,7 +586,7 @@ int auxtrace_parse_snapshot_options(struct auxtrace_record *itr,
 		break;
 	}
 
-	if (itr)
+	if (itr && itr->parse_snapshot_options)
 		return itr->parse_snapshot_options(itr, opts, str);
 
 	pr_err("No AUX area tracing to snapshot\n");
-- 
2.30.2



