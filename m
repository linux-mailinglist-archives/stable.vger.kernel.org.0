Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 496E537CAA4
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241875AbhELQbD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:31:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240930AbhELQ0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6729061DA3;
        Wed, 12 May 2021 15:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834540;
        bh=brDECwq0ads36K/hjlP+Sn6y3VTsqo9k6dOwc+CzcbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpJ36PfDQMyMDJqmYyBKBx3S+TlWdJm6CpWHEfUTiYoeESFbn5PpetwOdTKznArl2
         Uza3DByigasi2ceoD9ZzGzicntQULfh9nNmXX0VgqVA2FZPCN2avsxOseFaPvVRbIN
         7tYEzbvUSaPGSXrIvHAgF/r8kcyAIz9xGR8qQ0cY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Leo Yan <leo.yan@linaro.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steve MacLean <Steve.MacLean@Microsoft.com>,
        Yonatan Goldschmidt <yonatan.goldschmidt@granulate.io>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 584/601] perf tools: Change fields type in perf_record_time_conv
Date:   Wed, 12 May 2021 16:51:01 +0200
Message-Id: <20210512144847.078101552@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit e1d380ea8b00db4bb14d1f513000d4b62aa9d3f0 ]

C standard claims "An object declared as type _Bool is large enough to
store the values 0 and 1", bool type size can be 1 byte or larger than
1 byte.  Thus it's uncertian for bool type size with different
compilers.

This patch changes the bool type in structure perf_record_time_conv to
__u8 type, and pads extra bytes for 8-byte alignment; this can give
reliable structure size.

Fixes: d110162cafc8 ("perf tsc: Support cap_user_time_short for event TIME_CONV")
Suggested-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steve MacLean <Steve.MacLean@Microsoft.com>
Cc: Yonatan Goldschmidt <yonatan.goldschmidt@granulate.io>
Link: https://lore.kernel.org/r/20210428120915.7123-2-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/perf/include/perf/event.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/perf/include/perf/event.h b/tools/lib/perf/include/perf/event.h
index 988c539bedb6..baf64ea74e10 100644
--- a/tools/lib/perf/include/perf/event.h
+++ b/tools/lib/perf/include/perf/event.h
@@ -336,8 +336,9 @@ struct perf_record_time_conv {
 	__u64			 time_zero;
 	__u64			 time_cycles;
 	__u64			 time_mask;
-	bool			 cap_user_time_zero;
-	bool			 cap_user_time_short;
+	__u8			 cap_user_time_zero;
+	__u8			 cap_user_time_short;
+	__u8			 reserved[6];	/* For alignment */
 };
 
 struct perf_record_header_feature {
-- 
2.30.2



