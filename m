Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F299C49A4B9
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371726AbiAYAJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2364468AbiAXXsP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:48:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF07C07E30F;
        Mon, 24 Jan 2022 13:43:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6394FB81136;
        Mon, 24 Jan 2022 21:43:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860B4C340E4;
        Mon, 24 Jan 2022 21:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060595;
        bh=4ABbKYiiDxKwGitVr08/1AJL/S5WC4/EA9Zq2J99dIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MsDVrIewpK0Cq9Rml56lTAyyef1v+s31oIybBkrMdJ7Z6/OsK3VhUjMroaHF0wZbX
         TQ1MxDnc2poaJsX0l4TTzDpy8wQxHf0FT/McJPOyo/o7BNQgI58FFzjGKhB0PsJTtF
         QeeZ8Z2byoi2x91jr1SB97Qip2vH4/4PjuLNxzX4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.16 1000/1039] perf cputopo: Fix CPU topology reading on s/390
Date:   Mon, 24 Jan 2022 19:46:29 +0100
Message-Id: <20220124184158.895209300@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Richter <tmricht@linux.ibm.com>

commit a6e62743621ea29bea461774c0bcc68e5de59068 upstream.

Commit fdf1e29b6118c18f ("perf expr: Add metric literals for topology.")
fails on s390:

 # ./perf test -Fv 7
   ...
 # FAILED tests/expr.c:173 #num_dies >= #num_packages
   ---- end ----
   Simple expression parser: FAILED!
 #

Investigating this issue leads to these functions:
 build_cpu_topology()
   +--> has_die_topology(void)
        {
           struct utsname uts;

           if (uname(&uts) < 0)
                  return false;
           if (strncmp(uts.machine, "x86_64", 6))
                  return false;
           ....
        }

which always returns false on s390. The caller build_cpu_topology()
checks has_die_topology() return value. On false the
the struct cpu_topology::die_cpu_list is not contructed and has zero
entries. This leads to the failing comparison: #num_dies >= #num_packages.
s390 of course has a positive number of packages.

Fix this by adding s390 architecture to support CPU die list.

Output after:
 # ./perf test -Fv 7
  7: Simple expression parser                                        :
  --- start ---
  division by zero
  syntax error
  ---- end ----
  Simple expression parser: Ok
 #

Fixes: fdf1e29b6118c18f ("perf expr: Add metric literals for topology.")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20211124090343.9436-1-tmricht@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/cputopo.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/perf/util/cputopo.c
+++ b/tools/perf/util/cputopo.c
@@ -165,7 +165,8 @@ static bool has_die_topology(void)
 	if (uname(&uts) < 0)
 		return false;
 
-	if (strncmp(uts.machine, "x86_64", 6))
+	if (strncmp(uts.machine, "x86_64", 6) &&
+	    strncmp(uts.machine, "s390x", 5))
 		return false;
 
 	scnprintf(filename, MAXPATHLEN, DIE_CPUS_FMT,


