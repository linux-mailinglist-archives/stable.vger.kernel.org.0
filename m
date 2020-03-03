Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 333F31780BF
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:00:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387422AbgCCR6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:58:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:41414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732871AbgCCR6e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:58:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73ABB20728;
        Tue,  3 Mar 2020 17:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258313;
        bh=7tV0NVotmzh0q+KwNJ3XzdXzL+Cvualt8ZjzXVFz42E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zylpXeisxOBxR0NQlx9S2GDPruXkDhv7rGroAF6nnYWflaIlFd7eAPYS/arGeY5oD
         JlgnJKWDWGOkbkha9JJGKSM5RBX35es7BrmeiRocPd9MzegygTikk9H6dLXPp2JzJX
         fHnIj5osg+zcqF9gWZoMM+GSIPVqwFBrg8OhMCQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jelle van der Waa <jelle@vdwaa.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.4 133/152] perf ui gtk: Add missing zalloc object
Date:   Tue,  3 Mar 2020 18:43:51 +0100
Message-Id: <20200303174317.931341457@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174302.523080016@linuxfoundation.org>
References: <20200303174302.523080016@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

commit 604e2139a1026793b8c2172bd92c7e9d039a5cf0 upstream.

When we moved zalloc.o to the library we missed gtk library which needs
it compiled in, otherwise the missing __zfree symbol will cause the
library to fail to load.

Adding the zalloc object to the gtk library build.

Fixes: 7f7c536f23e6 ("tools lib: Adopt zalloc()/zfree() from tools/perf")
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Jelle van der Waa <jelle@vdwaa.nl>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/20200113104358.123511-1-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/ui/gtk/Build |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/perf/ui/gtk/Build
+++ b/tools/perf/ui/gtk/Build
@@ -7,3 +7,8 @@ gtk-y += util.o
 gtk-y += helpline.o
 gtk-y += progress.o
 gtk-y += annotate.o
+gtk-y += zalloc.o
+
+$(OUTPUT)ui/gtk/zalloc.o: ../lib/zalloc.c FORCE
+	$(call rule_mkdir)
+	$(call if_changed_dep,cc_o_c)


