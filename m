Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2D91D2530
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387968AbfJJIzL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:55:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:56468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389850AbfJJIto (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:49:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DA8B218AC;
        Thu, 10 Oct 2019 08:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570697384;
        bh=PtwfxrY3qGfEkoS0hbLCZk9IvD+Q3DudzZOkh7MLpI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pXJoTDlgie8a0r/oap6oWs32jzJAZ8h0CAKId1hA/bzrrgpA/hkek+SKVS9rczipD
         /jv1KAlbCr7r5jryQxqfqEV51WGkWwtHeHsfL6j63W6lNvq+Yzo9YSxWmwlYaIBcnZ
         y1bpQhEMvbXQ5t87G2skCQsWbPxvrLfP3PtvmOVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 083/114] tools lib traceevent: Do not free tep->cmdlines in add_new_comm() on failure
Date:   Thu, 10 Oct 2019 10:36:30 +0200
Message-Id: <20191010083612.408800292@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083544.711104709@linuxfoundation.org>
References: <20191010083544.711104709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

[ Upstream commit e0d2615856b2046c2e8d5bfd6933f37f69703b0b ]

If the re-allocation of tep->cmdlines succeeds, then the previous
allocation of tep->cmdlines will be freed. If we later fail in
add_new_comm(), we must not free cmdlines, and also should assign
tep->cmdlines to the new allocation. Otherwise when freeing tep, the
tep->cmdlines will be pointing to garbage.

Fixes: a6d2a61ac653a ("tools lib traceevent: Remove some die() calls")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: linux-trace-devel@vger.kernel.org
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/20190828191819.970121417@goodmis.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/traceevent/event-parse.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 6ccfd13d5cf9c..382e476629fb1 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -254,10 +254,10 @@ static int add_new_comm(struct tep_handle *pevent, const char *comm, int pid)
 		errno = ENOMEM;
 		return -1;
 	}
+	pevent->cmdlines = cmdlines;
 
 	cmdlines[pevent->cmdline_count].comm = strdup(comm);
 	if (!cmdlines[pevent->cmdline_count].comm) {
-		free(cmdlines);
 		errno = ENOMEM;
 		return -1;
 	}
@@ -268,7 +268,6 @@ static int add_new_comm(struct tep_handle *pevent, const char *comm, int pid)
 		pevent->cmdline_count++;
 
 	qsort(cmdlines, pevent->cmdline_count, sizeof(*cmdlines), cmdline_cmp);
-	pevent->cmdlines = cmdlines;
 
 	return 0;
 }
-- 
2.20.1



