Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 014443961E1
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232714AbhEaOri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:47:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:40720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233174AbhEaOpi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:45:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0A4336143B;
        Mon, 31 May 2021 13:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469323;
        bh=bWyJKvQVU+kJ1ALVoVaPXvozJvDT8Gaa9rBeUHRNj8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PghvIIgnqHWwDf//khDF/KwnizMjx003ONf/9UqTjf13nlOjsxhhgcCeg3H2WTL/A
         qiFHzKkWrv2kLqAGdGs8U7sVcXOjmm0CJQx8YSHRbJk5tmS7HLIfu0n1DMJPi8Grk2
         nkmMgpAT4mUcn+j7UdCPbTPXsfPtfDlHVBbHRD38=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ian Rogers <irogers@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5.12 154/296] perf debug: Move debug initialization earlier
Date:   Mon, 31 May 2021 15:13:29 +0200
Message-Id: <20210531130709.039488460@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ian Rogers <irogers@google.com>

commit c59870e2110e1229a6e4b2457aece6ffe8d68d99 upstream.

This avoids segfaults during option handlers that use pr_err. For
example, "perf --debug nopager list" segfaults before this change.

Fixes: 8abceacff87d (perf debug: Add debug_set_file function)
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lore.kernel.org/lkml/20210519164447.2672030-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/perf.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -443,6 +443,8 @@ int main(int argc, const char **argv)
 	const char *cmd;
 	char sbuf[STRERR_BUFSIZE];
 
+	perf_debug_setup();
+
 	/* libsubcmd init */
 	exec_cmd_init("perf", PREFIX, PERF_EXEC_PATH, EXEC_PATH_ENVIRONMENT);
 	pager_init(PERF_PAGER_ENVIRONMENT);
@@ -531,8 +533,6 @@ int main(int argc, const char **argv)
 	 */
 	pthread__block_sigwinch();
 
-	perf_debug_setup();
-
 	while (1) {
 		static int done_help;
 


