Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C4963D616E
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232719AbhGZPbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:31:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237876AbhGZP31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 42E976105A;
        Mon, 26 Jul 2021 16:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315746;
        bh=SycoK9Apc5fzkZVGfDL1xHHqUE6lAi0ZxHmGoBYbLzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yVKFTOWotWMYpo6fbZD1tgHd6BEKJAF1/6xQghhAS2KwEPEYZVibcJZBfchCxWzN+
         QolarSya4onMk1Pn22C+bS7AGFTe8jfkjYtKlxdyIyMFybfcmwlZmUhvIu3C7NY5IY
         Gbx4FOMnMOvLMRCxI/llraNtVuqmCFOFC6QgM2Zw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Riccardo Mancini <rickyman7@gmail.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Krister Johansen <kjlx@templeofstupid.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 050/223] perf map: Fix dso->nsinfo refcounting
Date:   Mon, 26 Jul 2021 17:37:22 +0200
Message-Id: <20210726153847.904724898@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Riccardo Mancini <rickyman7@gmail.com>

[ Upstream commit 2d6b74baa7147251c30a46c4996e8cc224aa2dc5 ]

ASan reports a memory leak of nsinfo during the execution of

  # perf test "31: Lookup mmap thread"

The leak is caused by a refcounted variable being replaced without
dropping the refcount.

This patch makes sure that the refcnt of nsinfo is decreased whenever a
refcounted variable is replaced with a new value.

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Fixes: bf2e710b3cb8445c ("perf maps: Lookup maps in both intitial mountns and inner mountns.")
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Krister Johansen <kjlx@templeofstupid.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/55223bc8821b34ccb01f92ef1401c02b6a32e61f.1626343282.git.rickyman7@gmail.com
[ Split from a larger patch ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/map.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/map.c b/tools/perf/util/map.c
index 8af693d9678c..72e7f3616157 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -192,6 +192,8 @@ struct map *map__new(struct machine *machine, u64 start, u64 len,
 			if (!(prot & PROT_EXEC))
 				dso__set_loaded(dso);
 		}
+
+		nsinfo__put(dso->nsinfo);
 		dso->nsinfo = nsi;
 
 		if (build_id__is_defined(bid))
-- 
2.30.2



