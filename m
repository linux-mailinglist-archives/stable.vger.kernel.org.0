Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E94628B732
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389221AbgJLNl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389009AbgJLNlA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:41:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1956E20678;
        Mon, 12 Oct 2020 13:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510058;
        bh=0eJa7RhJIardyML5iBkzlYb6QbrNEuYZ1CbCF0lDW1s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oC4+Wl+WbZFwrzhradSr6rI+5z12uIF268AQ3486b/J9XveIaAhdoIlp7Rjgrd19M
         vG8X4z5IqSBM4ulTGah8i8ZrXS4p3DAuz6GRZwS/gKJMqusmhI+Xt0Xsaly/7+4H24
         cjzj2mtywQ7JJwR9Vlb0BjIxidUflZF9c5Ny1nvA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tommi Rantala <tommi.t.rantala@nokia.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 5.4 23/85] perf top: Fix stdio interface input handling with glibc 2.28+
Date:   Mon, 12 Oct 2020 15:26:46 +0200
Message-Id: <20201012132633.966541649@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132632.846779148@linuxfoundation.org>
References: <20201012132632.846779148@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tommi Rantala <tommi.t.rantala@nokia.com>

commit 29b4f5f188571c112713c35cc87eefb46efee612 upstream.

Since glibc 2.28 when running 'perf top --stdio', input handling no
longer works, but hitting any key always just prints the "Mapped keys"
help text.

To fix it, call clearerr() in the display_thread() loop to clear any EOF
sticky errors, as instructed in the glibc NEWS file
(https://sourceware.org/git/?p=glibc.git;a=blob;f=NEWS):

 * All stdio functions now treat end-of-file as a sticky condition.  If you
   read from a file until EOF, and then the file is enlarged by another
   process, you must call clearerr or another function with the same effect
   (e.g. fseek, rewind) before you can read the additional data.  This
   corrects a longstanding C99 conformance bug.  It is most likely to affect
   programs that use stdio to read interactive input from a terminal.
   (Bug #1190.)

Signed-off-by: Tommi Rantala <tommi.t.rantala@nokia.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20200305083714.9381-2-tommi.t.rantala@nokia.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/builtin-top.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -683,7 +683,9 @@ repeat:
 	delay_msecs = top->delay_secs * MSEC_PER_SEC;
 	set_term_quiet_input(&save);
 	/* trash return*/
-	getc(stdin);
+	clearerr(stdin);
+	if (poll(&stdin_poll, 1, 0) > 0)
+		getc(stdin);
 
 	while (!done) {
 		perf_top__print_sym_table(top);


