Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA05638A40D
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 11:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232939AbhETKA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:60376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234796AbhETJ6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:58:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBF586162B;
        Thu, 20 May 2021 09:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503502;
        bh=+dR417BbqYZAraeubI92vhWNwp4S7HDTUA298DmE2MU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nKENSJrwAcP0tMop7FkQ9kkAGqJO25sSX3DelpYxfjhU3YCcOScioYfq/XZaJbpVj
         dghUqGHtRdMbZ1/7vytuFsKab1Wcf0xtaYhdRz/aR4tVPNRyL80H1moKMIsvJ3t8O7
         5LpQlE9YoZZ4pyaAVaGmKdIp5qgAgEXRhv7ujtyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Li <yang.lee@linux.alibaba.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 249/425] perf symbols: Fix dso__fprintf_symbols_by_name() to return the number of printed chars
Date:   Thu, 20 May 2021 11:20:18 +0200
Message-Id: <20210520092139.600684140@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 210e4c89ef61432040c6cd828fefa441f4887186 ]

The 'ret' variable was initialized to zero but then it was not updated
from the fprintf() return, fix it.

Reported-by: Yang Li <yang.lee@linux.alibaba.com>
cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
cc: Ingo Molnar <mingo@redhat.com>
cc: Jiri Olsa <jolsa@redhat.com>
cc: Mark Rutland <mark.rutland@arm.com>
cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Fixes: 90f18e63fbd00513 ("perf symbols: List symbols in a dso in ascending name order")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol_fprintf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol_fprintf.c b/tools/perf/util/symbol_fprintf.c
index ed0205cc7942..1fd175bb4600 100644
--- a/tools/perf/util/symbol_fprintf.c
+++ b/tools/perf/util/symbol_fprintf.c
@@ -66,7 +66,7 @@ size_t dso__fprintf_symbols_by_name(struct dso *dso,
 
 	for (nd = rb_first(&dso->symbol_names); nd; nd = rb_next(nd)) {
 		pos = rb_entry(nd, struct symbol_name_rb_node, rb_node);
-		fprintf(fp, "%s\n", pos->sym.name);
+		ret += fprintf(fp, "%s\n", pos->sym.name);
 	}
 
 	return ret;
-- 
2.30.2



