Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE153D5F5C
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236847AbhGZPRp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:17:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:54616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237411AbhGZPPo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92B2360FF1;
        Mon, 26 Jul 2021 15:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314839;
        bh=HehFALCfaO6LmBqoIvwYYPiOV06SD/sX6ScgeNrY3kg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lx69LikQnvwRYgu0Iogb26xYOCikF+luiM+50qy0vOhac7JhsYcoMMnz2OY0WvNhZ
         9dP+CsBQoibCOFalmIT2fmmrlm/+cwzPPwEzI+tT1oNBlnp4G2IERrBDDzcUN4wQVI
         uobwM3uXn/ua0FBCK55tASuPnxnzdb2tzoiIAdtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Kan Liang <kan.liang@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 065/120] perf test session_topology: Delete session->evlist
Date:   Mon, 26 Jul 2021 17:38:37 +0200
Message-Id: <20210726153834.463666741@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153832.339431936@linuxfoundation.org>
References: <20210726153832.339431936@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Mancini <rickyman7@gmail.com>

[ Upstream commit 233f2dc1c284337286f9a64c0152236779a42f6c ]

ASan reports a memory leak related to session->evlist while running:

  # perf test "41: Session topology".

When perf_data is in write mode, session->evlist is owned by the caller,
which should also take care of deleting it.

This patch adds the missing evlist__delete().

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Fixes: c84974ed9fb67293 ("perf test: Add entry to test cpu topology")
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kan Liang <kan.liang@intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/822f741f06eb25250fb60686cf30a35f447e9e91.1626343282.git.rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/topology.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/tests/topology.c b/tools/perf/tests/topology.c
index 9497d02f69e6..bed53ed82af7 100644
--- a/tools/perf/tests/topology.c
+++ b/tools/perf/tests/topology.c
@@ -52,6 +52,7 @@ static int session_write_header(char *path)
 	TEST_ASSERT_VAL("failed to write header",
 			!perf_session__write_header(session, session->evlist, data.file.fd, true));
 
+	evlist__delete(session->evlist);
 	perf_session__delete(session);
 
 	return 0;
-- 
2.30.2



