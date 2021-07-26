Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F873D5F8B
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236467AbhGZPSX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:18:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:54388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237423AbhGZPPp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:15:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 867A761042;
        Mon, 26 Jul 2021 15:55:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314923;
        bh=W9qfR+V68/aK7vLmPpBak2aLgITJ1/4ojpMdzxEveuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HjaQhIT704O/P5CAn+9A+k9rtmA/ev1+qF5ZTCr66rGzlWcXyTRnnZ0OW019i7Api
         PQHdFl3dbkcxPPTIvZoQEu5+HMNGaQ1vt8spPi1HqyoADVYE9Xb5hQHEupihAmwb3E
         kPl0pYFnwRR6trRDROaOEMCXXVYf5rfekxYtNF9M=
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
Subject: [PATCH 5.4 020/108] perf map: Fix dso->nsinfo refcounting
Date:   Mon, 26 Jul 2021 17:38:21 +0200
Message-Id: <20210726153832.341314423@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153831.696295003@linuxfoundation.org>
References: <20210726153831.696295003@linuxfoundation.org>
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
index 571e99c908a0..1ae5c51a7035 100644
--- a/tools/perf/util/map.c
+++ b/tools/perf/util/map.c
@@ -214,6 +214,8 @@ struct map *map__new(struct machine *machine, u64 start, u64 len,
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



