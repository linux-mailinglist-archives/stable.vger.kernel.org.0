Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C08E3FDB88
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343913AbhIAMmF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:42:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:40918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344944AbhIAMkP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0A75610CB;
        Wed,  1 Sep 2021 12:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499776;
        bh=n2AqwMKuQb72O62Paj8wB1wCCdCMphlf74YBf5JDzfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TP0dOTBAVzctdt0mv6dY/lvTzZtCLjL/YkxYfa22VnI4RCRBDaP7n1jOL41LWTFsR
         9idHt236DjtWAbQo4Ht9JcPzLgnKnIPwhOZFYEM8f9Pdo620qsRI1dCh7cH1qiXt92
         U4hcDbYj5or4SmGVseuJtHf2WgGBcOSzUyPcgDQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Fabian Hemmer <copy@copy.sh>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Remi Bernon <rbernon@codeweavers.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.10 081/103] perf symbol-elf: Fix memory leak by freeing sdt_note.args
Date:   Wed,  1 Sep 2021 14:28:31 +0200
Message-Id: <20210901122303.275332386@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/symbol-elf.c |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -2360,6 +2360,7 @@ int cleanup_sdt_note_list(struct list_he
 
 	list_for_each_entry_safe(pos, tmp, sdt_notes, note_list) {
 		list_del_init(&pos->note_list);
+		zfree(&pos->args);
 		zfree(&pos->name);
 		zfree(&pos->provider);
 		free(pos);


