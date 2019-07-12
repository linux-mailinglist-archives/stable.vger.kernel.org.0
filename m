Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A731C66DA4
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 14:32:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728538AbfGLMcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 08:32:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:49736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727685AbfGLMcL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 08:32:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A8C2216C8;
        Fri, 12 Jul 2019 12:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562934730;
        bh=+e9Edw7YbeCFDvCcDZYcLDS9Se8nRrWp5jfEKv9W+I4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ftEbICo3hQ5tnf4oSYxa17spPBJPiFGeb+APZIS0uBq48ZPQEjFCzVk0rG0W9uNju
         YQ97XPoVN9Uj7Ad8yjVvhZcbCP2IRXWSlPe1xhqHAVuopnzwUTPV+DA3NtNnPU3YOn
         aRaEVCnXPsVC5pgaJdsYStTOj4VzQAfrZW7BTvS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 5.2 13/61] perf intel-pt: Fix itrace defaults for perf script
Date:   Fri, 12 Jul 2019 14:19:26 +0200
Message-Id: <20190712121621.327039153@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190712121620.632595223@linuxfoundation.org>
References: <20190712121620.632595223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 26f19c2eb7e54015564ff133b91983a74e84541b upstream.

Commit 4eb068157121 ("perf script: Make itrace script default to all
calls") does not work because 'use_browser' is being used to determine
whether to default to periodic sampling (i.e. better for perf report).
The result is that nothing but CBR events display for perf script when
no --itrace option is specified.

Fix by using 'default_no_sample' and 'inject' instead.

Example:

 Before:

  $ perf record -e intel_pt/cyc/u ls
  $ perf script > cmp1.txt
  $ perf script --itrace=cepwx > cmp2.txt
  $ diff -sq cmp1.txt cmp2.txt
  Files cmp1.txt and cmp2.txt differ

 After:

  $ perf script > cmp1.txt
  $ perf script --itrace=cepwx > cmp2.txt
  $ diff -sq cmp1.txt cmp2.txt
  Files cmp1.txt and cmp2.txt are identical

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org # v4.20+
Fixes: 90e457f7be08 ("perf tools: Add Intel PT support")
Link: http://lkml.kernel.org/r/20190520113728.14389-2-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/intel-pt.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -2579,7 +2579,8 @@ int intel_pt_process_auxtrace_info(union
 	} else {
 		itrace_synth_opts__set_default(&pt->synth_opts,
 				session->itrace_synth_opts->default_no_sample);
-		if (use_browser != -1) {
+		if (!session->itrace_synth_opts->default_no_sample &&
+		    !session->itrace_synth_opts->inject) {
 			pt->synth_opts.branches = false;
 			pt->synth_opts.callchain = true;
 		}


