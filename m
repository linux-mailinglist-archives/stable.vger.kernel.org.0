Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F173D5DBA
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235522AbhGZPDY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:03:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235576AbhGZPDX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:03:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F77B60F22;
        Mon, 26 Jul 2021 15:43:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314231;
        bh=JgFSzR8rP3C8322YB7qcrEYYs9pwpwb87AW+G1SjcIs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MfpmrkUPH6QdwPXp/esLV01KNIq3LX3f7QKnrDL+sDajrGpc/bu7OTPW2wg1MYG8s
         xWFgtQxlS75XpOsdbC+6/6YSYL5wLBtwEUCzS7ypbyzj/L0C3vE/zWdhuIqzhVafBi
         wkEQlxnAoG0gAuEWqpwD9V9xUMECjjnmTyovhgDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 33/60] perf probe-file: Delete namelist in del_events() on the error path
Date:   Mon, 26 Jul 2021 17:38:47 +0200
Message-Id: <20210726153825.908914662@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153824.868160836@linuxfoundation.org>
References: <20210726153824.868160836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Mancini <rickyman7@gmail.com>

[ Upstream commit e0fa7ab42232e742dcb3de9f3c1f6127b5adc019 ]

ASan reports some memory leaks when running:

  # perf test "42: BPF filter"

This second leak is caused by a strlist not being dellocated on error
inside probe_file__del_events.

This patch adds a goto label before the deallocation and makes the error
path jump to it.

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Fixes: e7895e422e4da63d ("perf probe: Split del_perf_probe_events()")
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/174963c587ae77fa108af794669998e4ae558338.1626343282.git.rickyman7@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/probe-file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-file.c b/tools/perf/util/probe-file.c
index b9507a8d0e30..293df9409afa 100644
--- a/tools/perf/util/probe-file.c
+++ b/tools/perf/util/probe-file.c
@@ -334,11 +334,11 @@ int probe_file__del_events(int fd, struct strfilter *filter)
 
 	ret = probe_file__get_events(fd, filter, namelist);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	ret = probe_file__del_strlist(fd, namelist);
+out:
 	strlist__delete(namelist);
-
 	return ret;
 }
 
-- 
2.30.2



