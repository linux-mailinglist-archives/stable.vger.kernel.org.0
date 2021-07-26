Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CE033D5F0F
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236302AbhGZPQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236559AbhGZPLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:11:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBE4D60F44;
        Mon, 26 Jul 2021 15:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314713;
        bh=cX+DrYEYKeDG07eyLoc/AgQZsn9E90LLNcseBmHRgdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LiO+s9KRZWKqKUgFzGtfqD+NKSk01RPk5h9UykDnE5LP9Jq1Xx2rZBDZTLf/lSGAR
         evIFoP3c9JDrKfmTmWlRE3A18k0qO6bPxUKp4C8nevlkX/A6t9JoQbdY5bHAf61+NM
         xA50hkbZl2uy+zDHUaLAE/okf0HHF6LVKQQrLM08=
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
Subject: [PATCH 4.19 063/120] perf map: Fix dso->nsinfo refcounting
Date:   Mon, 26 Jul 2021 17:38:35 +0200
Message-Id: <20210726153834.402956766@linuxfoundation.org>
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
index 769d11575a7b..603086692290 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -209,6 +209,8 @@ struct map *map__new(struct machine *machine, u64 start, u64 len,
 			if (!(prot & PROT_EXEC))
 				dso__set_loaded(dso);
 		}
+
+		nsinfo__put(dso->nsinfo);
 		dso->nsinfo = nsi;
 		dso__put(dso);
 	}
-- 
2.30.2



