Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B467138A957
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 13:01:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238864AbhETLBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 07:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:52988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238912AbhETK4s (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:56:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9024B61CF0;
        Thu, 20 May 2021 10:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504917;
        bh=eETA7KyYu0qVAUl2uOwkEwWeDfkBXmFMH8I/xFWWqdk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k0lEOklZ9xRNExBkbg0rZMrXWBukdJ0n4WinVrokwfpGYX/ff1f5QElLGWuF3emx3
         FI71/ijEHLsrcemuLtl542g1wbNzONTUKrIPKfkxG/OiGW9ETIYprZCODyrOm1WU5o
         ExOzFsuGjgE4R/ij8NWEgojefIPC8FDfTgMQKDXI=
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
Subject: [PATCH 4.9 138/240] perf symbols: Fix dso__fprintf_symbols_by_name() to return the number of printed chars
Date:   Thu, 20 May 2021 11:22:10 +0200
Message-Id: <20210520092113.281960294@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
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
index a680bdaa65dc..060957aeb79a 100644
--- a/tools/perf/util/symbol_fprintf.c
+++ b/tools/perf/util/symbol_fprintf.c
@@ -64,7 +64,7 @@ size_t dso__fprintf_symbols_by_name(struct dso *dso,
 
 	for (nd = rb_first(&dso->symbol_names[type]); nd; nd = rb_next(nd)) {
 		pos = rb_entry(nd, struct symbol_name_rb_node, rb_node);
-		fprintf(fp, "%s\n", pos->sym.name);
+		ret += fprintf(fp, "%s\n", pos->sym.name);
 	}
 
 	return ret;
-- 
2.30.2



