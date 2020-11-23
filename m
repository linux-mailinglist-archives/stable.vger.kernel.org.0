Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C202D2C0833
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732742AbgKWMq3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:46:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:60030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732737AbgKWMq1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:46:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 899D920857;
        Mon, 23 Nov 2020 12:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135586;
        bh=dIRLnhRg/baSpycpsKUNXko8Wb8EAhAPwqn2dphLdfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N9jqg+lkitRPo4jKcEfmV7XSvvdDL+rTEQanWdqhyh1IJSKAD/S0KeAvB9isauoGa
         dwRXCjjt+oSUDtMnjqMTb7pOy+kMRqW5C/UKDxVbGpnVwxothSXJenLwhg7FLR00tN
         Bk6Vw68MAG2PrOJMQE/ulpYHDLgA7MaeHxRWzcW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leo Yan <leo.yan@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 122/252] perf lock: Correct field name "flags"
Date:   Mon, 23 Nov 2020 13:21:12 +0100
Message-Id: <20201123121841.479526414@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leo Yan <leo.yan@linaro.org>

[ Upstream commit e24a87b54ef3e39261f1d859b7f78416349dfb14 ]

The tracepoint "lock:lock_acquire" contains field "flags" but not
"flag".  Current code wrongly retrieves value from field "flag" and it
always gets zero for the value, thus "perf lock" doesn't report the
correct result.

This patch replaces the field name "flag" with "flags", so can read out
the correct flags for locking.

Fixes: e4cef1f65061 ("perf lock: Fix state machine to recognize lock sequence")
Signed-off-by: Leo Yan <leo.yan@linaro.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Link: https://lore.kernel.org/r/20201104094229.17509-1-leo.yan@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-lock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index f0a1dbacb46c7..5cecc1ad78e1f 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -406,7 +406,7 @@ static int report_lock_acquire_event(struct evsel *evsel,
 	struct lock_seq_stat *seq;
 	const char *name = evsel__strval(evsel, sample, "name");
 	u64 tmp	 = evsel__intval(evsel, sample, "lockdep_addr");
-	int flag = evsel__intval(evsel, sample, "flag");
+	int flag = evsel__intval(evsel, sample, "flags");
 
 	memcpy(&addr, &tmp, sizeof(void *));
 
-- 
2.27.0



