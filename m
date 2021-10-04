Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69170420F1E
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbhJDNbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:31:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237223AbhJDN30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:29:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A845463156;
        Mon,  4 Oct 2021 13:13:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353192;
        bh=syoi54lLnqYHCtaom7LtCHJmFpzpOzVVYJp+F4xZI9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K0CtpAijW/9W6wP8JHwBNCNsOjNUqD64qIvME4/bRIlrU43skeuxBvGDx7MLzYTnf
         4MLkHQl/RE2R06YZQ4mSNKFTBy07MgqwNx+y6AGETpYNjVJZwQ7iup3APXSQGZwpu7
         7U8IYAzslUus7daZ6UXNhjyB0ByV3DtVqWmWUEa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Like Xu <likexu@tencent.com>,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 024/172] perf iostat: Use system-wide mode if the target cpu_list is unspecified
Date:   Mon,  4 Oct 2021 14:51:14 +0200
Message-Id: <20211004125045.744239612@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Like Xu <likexu@tencent.com>

[ Upstream commit e4fe5d7349e0b1c0d3da5b6b3e1efce591e85bd2 ]

An iostate use case like "perf iostat 0000:16,0000:97 -- ls" should be
implemented to work in system-wide mode to ensure that the output from
print_header() is consistent with the user documentation perf-iostat.txt,
rather than incorrectly assuming that the kernel does not support it:

 Error:
 The sys_perf_event_open() syscall returned with 22 (Invalid argument) \
 for event (uncore_iio_0/event=0x83,umask=0x04,ch_mask=0xF,fc_mask=0x07/).
 /bin/dmesg | grep -i perf may provide additional information.

This error is easily fixed by assigning system-wide mode by default
for IOSTAT_RUN only when the target cpu_list is unspecified.

Fixes: f07952b179697771 ("perf stat: Basic support for iostat in perf")
Signed-off-by: Like Xu <likexu@tencent.com>
Cc: Alexander Antonov <alexander.antonov@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20210927081115.39568-1-likexu@tencent.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 634375937db9..36033a7372f9 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -2406,6 +2406,8 @@ int cmd_stat(int argc, const char **argv)
 			goto out;
 		} else if (verbose)
 			iostat_list(evsel_list, &stat_config);
+		if (iostat_mode == IOSTAT_RUN && !target__has_cpu(&target))
+			target.system_wide = true;
 	}
 
 	if (add_default_attributes())
-- 
2.33.0



