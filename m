Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE9A65D489
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 14:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239068AbjADNl2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 08:41:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239508AbjADNlZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 08:41:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5553FE49
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 05:41:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E707661733
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 13:41:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6347C433D2;
        Wed,  4 Jan 2023 13:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672839678;
        bh=7LaSX3H2Y9mF9xK1UITqEfYgDkmFj3g9YEdb+rqvOLQ=;
        h=Subject:To:Cc:From:Date:From;
        b=vRzjWTgP46UpVUSA4K45OiRA0xEhwTyoOjxBbSVPf0L6RvJvcp1bNv0bCKnotIqsL
         MsXlKB8bq7MI86k9MvXZ95TnHnN+qooHXU4CUlBvdpiwkpJv+jKKC7L2LgjIQBfv/1
         U6/3P2YJXGa8mRYmXZbKhRjIoxRu0LXmn7qneWK4=
Subject: FAILED: patch "[PATCH] perf probe: Fix to get the DW_AT_decl_file and" failed to apply to 6.0-stable tree
To:     mhiramat@kernel.org, acme@redhat.com,
        alexander.shishkin@linux.intel.com, jolsa@kernel.org,
        mark.rutland@arm.com, masami.hiramatsu.pt@hitachi.com,
        mingo@redhat.com, namhyung@kernel.org, peterz@infradead.org,
        rostedt@goodmis.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 14:41:12 +0100
Message-ID: <167283967226226@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

a9dfc46c67b5 ("perf probe: Fix to get the DW_AT_decl_file and DW_AT_call_file as unsinged data")
f828929ab7f0 ("perf probe: Use dwarf_attr_integrate as generic DWARF attr accessor")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a9dfc46c67b52ad43b8e335e28f4cf8002c67793 Mon Sep 17 00:00:00 2001
From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Date: Sat, 5 Nov 2022 12:01:14 +0900
Subject: [PATCH] perf probe: Fix to get the DW_AT_decl_file and
 DW_AT_call_file as unsinged data

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

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 30b36b525681..b07414409771 100644
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

