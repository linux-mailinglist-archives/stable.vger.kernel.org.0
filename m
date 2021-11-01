Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF1144172D
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbhKAJeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:34:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:36832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233252AbhKAJcE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:32:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D063C61181;
        Mon,  1 Nov 2021 09:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758651;
        bh=bTEJGZmvxKRfATw5kBkG2TDX9WVKyWGSyLMElRUiCus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vLfw+eNnagoow4l+1Tz9SXzLKb0qR75Vwk54aWAbbtMnuADo8xlFGlfJThttt9h13
         MI1e7JQxl9PDvwgY+9kBSUZD1l2Wvc3gCo2ecl87AVKhDDILUUPv9lHKWbMqjz0SbS
         2oPw7w4JGw4kdkxrqcBP9asPAuesNWViO50mFnSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, kernel-team@fb.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 51/51] perf script: Check session->header.env.arch before using it
Date:   Mon,  1 Nov 2021 10:17:55 +0100
Message-Id: <20211101082512.400591717@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082500.203657870@linuxfoundation.org>
References: <20211101082500.203657870@linuxfoundation.org>
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
@@ -3779,11 +3779,15 @@ int cmd_script(int argc, const char **ar
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


