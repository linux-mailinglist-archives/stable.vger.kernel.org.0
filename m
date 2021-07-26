Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2148A3D5E5B
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 17:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235979AbhGZPHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:07:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235762AbhGZPGl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:06:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A48C160F8F;
        Mon, 26 Jul 2021 15:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627314429;
        bh=aJcJ10TLmqHJfpQYmWj+uIqqZLuPUFhpimqjLGIrdfo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gCxe003JbaVn2cl01mLH9rHP9pNHdpmgcLUdVoLlNXpv2iZPRXx6tKYCCAF7VYddX
         zHjKTYwvfV/ATkxHIAPkVqcUDZRERMop9Rz68ZIYWLIztDrS0V+eyQY5FD7YIHEaj2
         +t3wEpQxxGHz0F3oi1lGCDJx69reYViEvZIa+yH8=
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
Subject: [PATCH 4.14 43/82] perf probe: Fix dso->nsinfo refcounting
Date:   Mon, 26 Jul 2021 17:38:43 +0200
Message-Id: <20210726153829.564982150@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153828.144714469@linuxfoundation.org>
References: <20210726153828.144714469@linuxfoundation.org>
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
index 7c286756c34b..a0597e417ca3 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -197,8 +197,10 @@ struct map *get_target_map(const char *target, struct nsinfo *nsi, bool user)
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



