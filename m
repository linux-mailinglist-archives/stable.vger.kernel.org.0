Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF01D37C1F7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232438AbhELPGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:06:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:59036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233169AbhELPEs (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:04:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A76C161433;
        Wed, 12 May 2021 14:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831564;
        bh=nN2Pz8T7E5xRcPqnS3oc20AuOaEiDJUAxZswVHHZqbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zb/SJ94HMsK17asEwn5z217VSPwBjsMS5+UHUEG5GCU3juPfZ702O080QCr3MrgR0
         FbcUm6WIQvv2MfzVdoNEa1CHfRsi/0kWkZBYYi7FpaCAW1P+tv8ZhdVVs9llrXdbl5
         r1o/MyaR3EmWnPdhq/vLPCs4NBQKQ/mDUSlCFZb0=
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
Subject: [PATCH 5.4 171/244] perf symbols: Fix dso__fprintf_symbols_by_name() to return the number of printed chars
Date:   Wed, 12 May 2021 16:49:02 +0200
Message-Id: <20210512144748.476045069@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
index 35c936ce33ef..2664fb65e47a 100644
--- a/tools/perf/util/symbol_fprintf.c
+++ b/tools/perf/util/symbol_fprintf.c
@@ -68,7 +68,7 @@ size_t dso__fprintf_symbols_by_name(struct dso *dso,
 
 	for (nd = rb_first_cached(&dso->symbol_names); nd; nd = rb_next(nd)) {
 		pos = rb_entry(nd, struct symbol_name_rb_node, rb_node);
-		fprintf(fp, "%s\n", pos->sym.name);
+		ret += fprintf(fp, "%s\n", pos->sym.name);
 	}
 
 	return ret;
-- 
2.30.2



