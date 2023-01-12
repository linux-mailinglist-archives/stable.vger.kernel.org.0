Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA756677E5
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:50:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239734AbjALOuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:50:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239535AbjALOuC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:50:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D851AA34
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:36:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C81C162037
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B528EC433D2;
        Thu, 12 Jan 2023 14:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673534205;
        bh=oMisTdy3ctI1aXiYEZk/+ZWUxZaLF4FneRFEPfmLhOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZKmVjBZ8+GiuQk4VRcgwVShYLB9OQVvhSp0g76OMVRme1uSaXHAIrvKjSnwxoVpf
         BcDYQ/hjyE9FBlgh2+OqpRj/mGOj3jAmFOHI3iUglnRh+6xRRFPXLtGArQCNJpb4i4
         5Q1coFw/eWr3XXCQ+pSSi+DLmpamRvWQz0y9U/Wo=
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
Subject: [PATCH 5.10 700/783] perf probe: Fix to get the DW_AT_decl_file and DW_AT_call_file as unsinged data
Date:   Thu, 12 Jan 2023 14:56:56 +0100
Message-Id: <20230112135556.783637514@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
index dc02685a1eec..f8a10d5148f6 100644
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



