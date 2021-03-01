Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3700C329045
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242793AbhCAUD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:58562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242610AbhCATyN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:54:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13A5C65362;
        Mon,  1 Mar 2021 17:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621266;
        bh=rUQeNsu8YaEmLB4s9TB38k4eeDooQEa70yWxOXMQJcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQhlH7skTrad/VVTy3xTWqk/aXMAM7/U75DkwGiWymA99VsWuJVDNSDlwMY30umj8
         bAJiEjshPhhK8bA6uAXqN6O8jAPi1ovMp+cSgqKy+YgrAc6hfQcDOobVi9VkOr28Uk
         jY2y/cZ5tKDNytCsKpJfaJsc9CiYowO7gRgZ1z8Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Fraser <nfraser@codeweavers.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Huw Davies <huw@codeweavers.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Kim Phillips <kim.phillips@amd.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Remi Bernon <rbernon@codeweavers.com>,
        Song Liu <songliubraving@fb.com>,
        Tommi Rantala <tommi.t.rantala@nokia.com>,
        Ulrich Czekalla <uczekalla@codeweavers.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 453/775] perf symbols: Fix return value when loading PE DSO
Date:   Mon,  1 Mar 2021 17:10:21 +0100
Message-Id: <20210301161223.933285884@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Fraser <nfraser@codeweavers.com>

[ Upstream commit 77771a97011fa9146ccfaf2983a3a2885dc57b6f ]

The first time dso__load() was called on a PE file it always returned -1
error. This caused the first call to map__find_symbol() to always fail
on a PE file so the first sample from each PE file always had symbol
<unknown>. Subsequent samples succeed however because the DSO is already
loaded.

This fixes dso__load() to return 0 when successfully loading a DSO with
libbfd.

Fixes: eac9a4342e5447ca ("perf symbols: Try reading the symbol table with libbfd")
Signed-off-by: Nicholas Fraser <nfraser@codeweavers.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Frank Ch. Eigler <fche@redhat.com>
Cc: Huw Davies <huw@codeweavers.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Kim Phillips <kim.phillips@amd.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Remi Bernon <rbernon@codeweavers.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Tommi Rantala <tommi.t.rantala@nokia.com>
Cc: Ulrich Czekalla <uczekalla@codeweavers.com>
Link: http://lore.kernel.org/lkml/1671b43b-09c3-1911-dbf8-7f030242fbf7@codeweavers.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 1645fb4ec9ed4..7dcf3327c5f7d 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1866,8 +1866,10 @@ int dso__load(struct dso *dso, struct map *map)
 		if (nsexit)
 			nsinfo__mountns_enter(dso->nsinfo, &nsc);
 
-		if (bfdrc == 0)
+		if (bfdrc == 0) {
+			ret = 0;
 			break;
+		}
 
 		if (!is_reg || sirc < 0)
 			continue;
-- 
2.27.0



