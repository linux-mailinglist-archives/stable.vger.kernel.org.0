Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D6A66CBC7
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:17:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234549AbjAPRRl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234386AbjAPRQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:16:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554EA3FF2A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:57:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E944461086
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:57:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DF3C433D2;
        Mon, 16 Jan 2023 16:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888237;
        bh=CWKN4ecTqNUqHsp84U3ofto2zEEfSyClrv6O5eYdfk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zGBcCNwka3N975nPcIrnz3DW1eIKmgk2iTa6LOWzfjPkcdhLXa+1gGvG8sUTamIRy
         lT6Lc/DibsehIpMyVuf6htU29eUo5Hn7MC73lrNbPH2U+7REXAXNW8zoyI+fmTkDOe
         Ul6vdxHEZGRMBHmJH54KiKNlFBj1CCzEMhBKdvAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 425/521] perf probe: Use dwarf_attr_integrate as generic DWARF attr accessor
Date:   Mon, 16 Jan 2023 16:51:27 +0100
Message-Id: <20230116154906.136525028@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

[ Upstream commit f828929ab7f0dc3353e4a617f94f297fa8f3dec3 ]

Use dwarf_attr_integrate() instead of dwarf_attr() for generic attribute
acccessor functions, so that it can find the specified attribute from
abstact origin DIE etc.

Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Link: https://lore.kernel.org/r/166731051988.2100653.13595339994343449770.stgit@devnote3
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: a9dfc46c67b5 ("perf probe: Fix to get the DW_AT_decl_file and DW_AT_call_file as unsinged data")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dwarf-aux.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index 230e94bf7775..3b7386527794 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -267,7 +267,7 @@ static int die_get_attr_udata(Dwarf_Die *tp_die, unsigned int attr_name,
 {
 	Dwarf_Attribute attr;
 
-	if (dwarf_attr(tp_die, attr_name, &attr) == NULL ||
+	if (dwarf_attr_integrate(tp_die, attr_name, &attr) == NULL ||
 	    dwarf_formudata(&attr, result) != 0)
 		return -ENOENT;
 
@@ -280,7 +280,7 @@ static int die_get_attr_sdata(Dwarf_Die *tp_die, unsigned int attr_name,
 {
 	Dwarf_Attribute attr;
 
-	if (dwarf_attr(tp_die, attr_name, &attr) == NULL ||
+	if (dwarf_attr_integrate(tp_die, attr_name, &attr) == NULL ||
 	    dwarf_formsdata(&attr, result) != 0)
 		return -ENOENT;
 
-- 
2.35.1



