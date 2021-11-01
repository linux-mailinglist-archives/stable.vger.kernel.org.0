Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0AB4418D9
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232428AbhKAJwb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:52:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:52156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233436AbhKAJu3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:50:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CED3361411;
        Mon,  1 Nov 2021 09:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759113;
        bh=qyP7yX4a41zPNxZ/dvq89YRR8LfqoDP3oX5QF4+EMN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=no/vWchTafDM1p9p1a8607QZQIxyBr9xxPuCHCWIBqSn1LCbUJTmngaNrDGBBxs8g
         W4DmsUDM7jyVWYMb9S8PG7QVt3y/33KrRRFrUf9XI0W4Py6PfnUvDR7J5b5noblmk9
         lV+FaNz27oTDVJvWmNhkm+xid3D1OBC3mEVanVWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Peter Zijlstra <peterz@infradead.org>, kernel-team@fb.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.14 121/125] perf script: Check session->header.env.arch before using it
Date:   Mon,  1 Nov 2021 10:18:14 +0100
Message-Id: <20211101082555.964972905@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
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
@@ -4024,11 +4024,15 @@ script_found:
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


