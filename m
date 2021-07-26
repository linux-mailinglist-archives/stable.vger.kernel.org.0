Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D88E3D616A
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbhGZPbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237870AbhGZP30 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:29:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B246661058;
        Mon, 26 Jul 2021 16:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627315749;
        bh=oCEfuq0erFN38BM9Nt4G4Ki85N22I0X1IdMoo8p8nyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J1DvhKqAjf/ENHEfvaJi45e6FxkuXZjP2+SetfvkAqMDpAoxd40z7b1eeToyqHsW4
         CHb87AHf7hu60Rp12AJnwx5gdGFQ+K3so/53W5yhivB0PSuXRLWqrMUf4fQWQ63uPV
         V1QrBz4QE9CjDCvLMIUaZGyAsfj6avjuxiZydt/0=
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
Subject: [PATCH 5.13 051/223] perf probe: Fix dso->nsinfo refcounting
Date:   Mon, 26 Jul 2021 17:37:23 +0200
Message-Id: <20210726153847.935593634@linuxfoundation.org>
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

[ Upstream commit dedeb4be203b382ba7245d13079bc3b0f6d40c65 ]

ASan reports a memory leak of nsinfo during the execution of:

 # perf test "31: Lookup mmap thread".

The leak is caused by a refcounted variable being replaced without
dropping the refcount.

This patch makes sure that the refcnt of nsinfo is decreased whenever
a refcounted variable is replaced with a new value.

Signed-off-by: Riccardo Mancini <rickyman7@gmail.com>
Fixes: 544abd44c7064c8a ("perf probe: Allow placing uprobes in alternate namespaces.")
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
 tools/perf/util/probe-event.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index a78c8d59a555..9cc89a047b15 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -180,8 +180,10 @@ struct map *get_target_map(const char *target, struct nsinfo *nsi, bool user)
 		struct map *map;
 
 		map = dso__new_map(target);
-		if (map && map->dso)
+		if (map && map->dso) {
+			nsinfo__put(map->dso->nsinfo);
 			map->dso->nsinfo = nsinfo__get(nsi);
+		}
 		return map;
 	} else {
 		return kernel_get_module_map(target);
-- 
2.30.2



