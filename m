Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B3E42908D
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241564AbhJKOJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:09:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238695AbhJKOHq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:07:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 358E66121E;
        Mon, 11 Oct 2021 14:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960862;
        bh=Y5X/JRLpfSXGCf4ACzbHxINvhR0B8c8nJ+TAdSRTyu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1z/4zlh4eewhHU4454wN48ES29SaA+LMUfcLgSpaB2mpGKwjXfxavfyLCiy5iqvCC
         TcMEvlsuSRPn80s7bfGZvA6BGsZV999DvCaDFQutGNvVbZRieZZdgwP0IsKRM7w0ho
         ATQS7RHjxim+C+eTQmMmgrTFTpwEpB4KN22knTb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Like Xu <likexu@tencent.com>,
        John Garry <john.garry@huawei.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 097/151] perf jevents: Free the sys_event_tables list after processing entries
Date:   Mon, 11 Oct 2021 15:46:09 +0200
Message-Id: <20211011134520.961474511@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Like Xu <likexu@tencent.com>

[ Upstream commit b94729919db2c6737501c36ea6526a36d5d63fa2 ]

The compiler reports that free_sys_event_tables() is dead code.

But according to the semantics, the "LIST_HEAD(sys_event_tables)" should
also be released, just like we do with 'arch_std_events' in main().

Fixes: e9d32c1bf0cd7a98 ("perf vendor events: Add support for arch standard events")
Signed-off-by: Like Xu <likexu@tencent.com>
Reviewed-by: John Garry <john.garry@huawei.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20210928102938.69681-1-likexu@tencent.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/pmu-events/jevents.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/pmu-events/jevents.c b/tools/perf/pmu-events/jevents.c
index 9604446f8360..8b536117e154 100644
--- a/tools/perf/pmu-events/jevents.c
+++ b/tools/perf/pmu-events/jevents.c
@@ -1284,6 +1284,7 @@ int main(int argc, char *argv[])
 	}
 
 	free_arch_std_events();
+	free_sys_event_tables();
 	free(mapfile);
 	return 0;
 
@@ -1305,6 +1306,7 @@ err_close_eventsfp:
 		create_empty_mapping(output_file);
 err_out:
 	free_arch_std_events();
+	free_sys_event_tables();
 	free(mapfile);
 	return ret;
 }
-- 
2.33.0



