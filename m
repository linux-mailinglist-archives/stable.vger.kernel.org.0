Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A053F194E
	for <lists+stable@lfdr.de>; Thu, 19 Aug 2021 14:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239752AbhHSMbe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 08:31:34 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:8885 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239665AbhHSMbc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 08:31:32 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Gr3t056GVz8sss;
        Thu, 19 Aug 2021 20:26:48 +0800 (CST)
Received: from dggpemm500002.china.huawei.com (7.185.36.229) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 19 Aug 2021 20:30:52 +0800
Received: from linux-ibm.site (10.175.102.37) by
 dggpemm500002.china.huawei.com (7.185.36.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 19 Aug 2021 20:30:51 +0800
From:   Hanjun Guo <guohanjun@huawei.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, <stable@vger.kernel.org>
CC:     Riccardo Mancini <rickyman7@gmail.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Fabian Hemmer <copy@copy.sh>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Remi Bernon <rbernon@codeweavers.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        "Arnaldo Carvalho de Melo" <acme@redhat.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.10.y 2/6] perf symbol-elf: Fix memory leak by freeing sdt_note.args
Date:   Thu, 19 Aug 2021 20:19:08 +0800
Message-ID: <1629375552-51897-3-git-send-email-guohanjun@huawei.com>
X-Mailer: git-send-email 1.7.12.4
In-Reply-To: <1629375552-51897-1-git-send-email-guohanjun@huawei.com>
References: <1629375552-51897-1-git-send-email-guohanjun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.102.37]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemm500002.china.huawei.com (7.185.36.229)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Mancini <rickyman7@gmail.com>

commit 69c9ffed6cede9c11697861f654946e3ae95a930 upstream.

Reported by ASan.

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Fabian Hemmer <copy@copy.sh>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Remi Bernon <rbernon@codeweavers.com>
Cc: Jiri Slaby <jirislaby@kernel.org>
Link: http://lore.kernel.org/lkml/20210602220833.285226-1-rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
---
 tools/perf/util/symbol-elf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 44dd86a..7356eb3 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -2360,6 +2360,7 @@ int cleanup_sdt_note_list(struct list_head *sdt_notes)
 
 	list_for_each_entry_safe(pos, tmp, sdt_notes, note_list) {
 		list_del_init(&pos->note_list);
+		zfree(&pos->args);
 		zfree(&pos->name);
 		zfree(&pos->provider);
 		free(pos);
-- 
1.7.12.4

