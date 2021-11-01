Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF7F4417C7
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbhKAJkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:40:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:43770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232033AbhKAJiB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:38:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF43260F4F;
        Mon,  1 Nov 2021 09:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758828;
        bh=CDMlvG5duSBUuvRV8fQFE52vESjelhXLk01PF/XH+Hc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YPu5L9M4i1CyS8BZB4/cD35z0sUOrQ85hr0lpwj98wQRQBx+zXjiJlh7VXxUgRIhc
         KmVMPYJYcgdzL9CF0REHU9jsv1dAulgHWh+EMMhGXJumPFnd93M7ugVh2Li4mV97UQ
         WvCBLVKdOdqCCzacUiTTxyqPIp5PZ0ArfuhWgfVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, kernel-team@fb.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 77/77] perf script: Check session->header.env.arch before using it
Date:   Mon,  1 Nov 2021 10:18:05 +0100
Message-Id: <20211101082527.560848483@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082511.254155853@linuxfoundation.org>
References: <20211101082511.254155853@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

commit 29c77550eef31b0d72a45b49eeab03b8963264e8 upstream.

When perf.data is not written cleanly, we would like to process existing
data as much as possible (please see f_header.data.size == 0 condition
in perf_session__read_header). However, perf.data with partial data may
crash perf. Specifically, we see crash in 'perf script' for NULL
session->header.env.arch.

Fix this by checking session->header.env.arch before using it to determine
native_arch. Also split the if condition so it is easier to read.

Committer notes:

If it is a pipe, we already assume is a native arch, so no need to check
session->header.env.arch.

Signed-off-by: Song Liu <songliubraving@fb.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: kernel-team@fb.com
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20211004053238.514936-1-songliubraving@fb.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/builtin-script.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -3820,11 +3820,15 @@ int cmd_script(int argc, const char **ar
 		goto out_delete;
 
 	uname(&uts);
-	if (data.is_pipe ||  /* assume pipe_mode indicates native_arch */
-	    !strcmp(uts.machine, session->header.env.arch) ||
-	    (!strcmp(uts.machine, "x86_64") &&
-	     !strcmp(session->header.env.arch, "i386")))
+	if (data.is_pipe) { /* Assume pipe_mode indicates native_arch */
 		native_arch = true;
+	} else if (session->header.env.arch) {
+		if (!strcmp(uts.machine, session->header.env.arch))
+			native_arch = true;
+		else if (!strcmp(uts.machine, "x86_64") &&
+			 !strcmp(session->header.env.arch, "i386"))
+			native_arch = true;
+	}
 
 	script.session = session;
 	script__setup_sample_type(&script);


