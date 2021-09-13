Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B9A4090D4
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244911AbhIMNzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:55:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:36596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242838AbhIMNxq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:53:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90D3361209;
        Mon, 13 Sep 2021 13:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540106;
        bh=48pu5iASxiNMtjVwU7GIi6iA+uGpxSAHybb0FSBURQ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wedvWKnvmefoY554rfILWWde/tdsYktMR2OZVNj1Yg/Wk5HsZWsv+ZzkGdMGIjlyy
         gZtMaWGcyyaaOIPg/HTLcEqF6/Snh+OFW5NuxWHKRrBCAX5xuH99fa1fN5aghQ4WGh
         WhVxldJXA+RSRst38B6SZEQevhmIBf+kLTw+uOII=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Mika=20Penttil=C3=A4?= <mika.penttila@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Pankaj Gupta <pankaj.gupta@ionos.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 052/300] sched/numa: Fix is_core_idle()
Date:   Mon, 13 Sep 2021 15:11:53 +0200
Message-Id: <20210913131111.109561750@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Penttilä <mika.penttila@gmail.com>

[ Upstream commit 1c6829cfd3d5124b125e6df41158665aea413b35 ]

Use the loop variable instead of the function argument to test the
other SMT siblings for idle.

Fixes: ff7db0bf24db ("sched/numa: Prefer using an idle CPU as a migration target instead of comparing tasks")
Signed-off-by: Mika Penttilä <mika.penttila@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Acked-by: Pankaj Gupta <pankaj.gupta@ionos.com>
Link: https://lkml.kernel.org/r/20210722063946.28951-1-mika.penttila@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/fair.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f60ef0b4ec33..3889fee98d11 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1529,7 +1529,7 @@ static inline bool is_core_idle(int cpu)
 		if (cpu == sibling)
 			continue;
 
-		if (!idle_cpu(cpu))
+		if (!idle_cpu(sibling))
 			return false;
 	}
 #endif
-- 
2.30.2



