Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15B2664AC8
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239369AbjAJSgH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239427AbjAJSfL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:35:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5362F9B2A2
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:30:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0175EB81903
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:30:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BECC433D2;
        Tue, 10 Jan 2023 18:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673375436;
        bh=MazqOz3mBOgpLDVrM8IiQPoQnCER46oXA8YS7qQjh20=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m7lZYuUNsoSOdOm3Ywewkae63zuQEIBHeeQdliJtJ9/HLx8oJF7hKcJ7zURYAcWdi
         NKP+IvVy9te/gG1dvjTdTD2TcccmZl9sU0nfb+Y5Cn245iJKhDukGhuz52/fx3Nrmj
         RXsnzL3hpnHNtxU+70plmLXJW30sql/jWwBM1mHU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 188/290] perf probe: Fix to get the DW_AT_decl_file and DW_AT_call_file as unsinged data
Date:   Tue, 10 Jan 2023 19:04:40 +0100
Message-Id: <20230110180038.443835403@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit a9dfc46c67b52ad43b8e335e28f4cf8002c67793 ]

DWARF version 5 standard Sec 2.14 says that

  Any debugging information entry representing the declaration of an object,
  module, subprogram or type may have DW_AT_decl_file, DW_AT_decl_line and
  DW_AT_decl_column attributes, each of whose value is an unsigned integer
  constant.

So it should be an unsigned integer data. Also, even though the standard
doesn't clearly say the DW_AT_call_file is signed or unsigned, the
elfutils (eu-readelf) interprets it as unsigned integer data and it is
natural to handle it as unsigned integer data as same as DW_AT_decl_file.
This changes the DW_AT_call_file as unsigned integer data too.

Fixes: 3f4460a28fb2f73d ("perf probe: Filter out redundant inline-instances")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Link: https://lore.kernel.org/r/166761727445.480106.3738447577082071942.stgit@devnote3
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dwarf-aux.c | 21 ++++-----------------
 1 file changed, 4 insertions(+), 17 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index a07efbadb775..623527edeac1 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -315,19 +315,6 @@ static int die_get_attr_udata(Dwarf_Die *tp_die, unsigned int attr_name,
 	return 0;
 }
 
-/* Get attribute and translate it as a sdata */
-static int die_get_attr_sdata(Dwarf_Die *tp_die, unsigned int attr_name,
-			      Dwarf_Sword *result)
-{
-	Dwarf_Attribute attr;
-
-	if (dwarf_attr_integrate(tp_die, attr_name, &attr) == NULL ||
-	    dwarf_formsdata(&attr, result) != 0)
-		return -ENOENT;
-
-	return 0;
-}
-
 /**
  * die_is_signed_type - Check whether a type DIE is signed or not
  * @tp_die: a DIE of a type
@@ -467,9 +454,9 @@ int die_get_data_member_location(Dwarf_Die *mb_die, Dwarf_Word *offs)
 /* Get the call file index number in CU DIE */
 static int die_get_call_fileno(Dwarf_Die *in_die)
 {
-	Dwarf_Sword idx;
+	Dwarf_Word idx;
 
-	if (die_get_attr_sdata(in_die, DW_AT_call_file, &idx) == 0)
+	if (die_get_attr_udata(in_die, DW_AT_call_file, &idx) == 0)
 		return (int)idx;
 	else
 		return -ENOENT;
@@ -478,9 +465,9 @@ static int die_get_call_fileno(Dwarf_Die *in_die)
 /* Get the declared file index number in CU DIE */
 static int die_get_decl_fileno(Dwarf_Die *pdie)
 {
-	Dwarf_Sword idx;
+	Dwarf_Word idx;
 
-	if (die_get_attr_sdata(pdie, DW_AT_decl_file, &idx) == 0)
+	if (die_get_attr_udata(pdie, DW_AT_decl_file, &idx) == 0)
 		return (int)idx;
 	else
 		return -ENOENT;
-- 
2.35.1



