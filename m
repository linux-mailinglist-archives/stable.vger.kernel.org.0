Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682DF1E2F0B
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:34:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389511AbgEZSz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:55:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:47876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389505AbgEZSz2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:55:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 724A820849;
        Tue, 26 May 2020 18:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519327;
        bh=FqIUcj0/zvBYNmeMXGFKy3xHDAfAvI/YMYfqC8HiR6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oVFLyRh6YGGyTju0o37v0LIgChb0+aBf91sqWfncVNgEEI9gnpz2I6E1HawAgGzNH
         STbXWW2bGcc2hmijlQffXFxsglaaLmlf3Y3uZr9+CF4pruQXYnD6Ydn34eabhRlAtC
         VOxunMiCRPPztw793szzQaH8gFEs7WUEIu2rMDnU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathias Krause <minipli@googlemail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 25/65] padata: set cpu_index of unused CPUs to -1
Date:   Tue, 26 May 2020 20:52:44 +0200
Message-Id: <20200526183915.603271344@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183905.988782958@linuxfoundation.org>
References: <20200526183905.988782958@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 1bd845bcb41d5b7f83745e0cb99273eb376f2ec5 ]

The parallel queue per-cpu data structure gets initialized only for CPUs
in the 'pcpu' CPU mask set. This is not sufficient as the reorder timer
may run on a different CPU and might wrongly decide it's the target CPU
for the next reorder item as per-cpu memory gets memset(0) and we might
be waiting for the first CPU in cpumask.pcpu, i.e. cpu_index 0.

Make the '__this_cpu_read(pd->pqueue->cpu_index) == next_queue->cpu_index'
compare in padata_get_next() fail in this case by initializing the
cpu_index member of all per-cpu parallel queues. Use -1 for unused ones.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 8aef48c3267b..4f860043a8e5 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -461,8 +461,14 @@ static void padata_init_pqueues(struct parallel_data *pd)
 	struct padata_parallel_queue *pqueue;
 
 	cpu_index = 0;
-	for_each_cpu(cpu, pd->cpumask.pcpu) {
+	for_each_possible_cpu(cpu) {
 		pqueue = per_cpu_ptr(pd->pqueue, cpu);
+
+		if (!cpumask_test_cpu(cpu, pd->cpumask.pcpu)) {
+			pqueue->cpu_index = -1;
+			continue;
+		}
+
 		pqueue->pd = pd;
 		pqueue->cpu_index = cpu_index;
 		cpu_index++;
-- 
2.25.1



