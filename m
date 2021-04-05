Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD0B35404B
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240783AbhDEJRA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:38636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240774AbhDEJQ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:16:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F36D661002;
        Mon,  5 Apr 2021 09:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614210;
        bh=N+CSAYy1zGMVjbnAPkfmD7wBZE7bLj/mVqEwwm1YubY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cpok/Cd4EDBeTtmEA+sIfP8pW0VMA3S+gJVwS8f9Ph8o92LdmKBC3Q1sEJv/g2Ie5
         UlqMrj6/G8EoDoX+3hsQQ9sXf8LLuXi8dnKQK+LRVXYwmYRzAsPgNr5V5kTqipCoMZ
         eoJKoLFyCT77hyDYVDubGvt8ub8GC7JOsy1NV27A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 124/152] powerpc/pseries/mobility: use struct for shared state
Date:   Mon,  5 Apr 2021 10:54:33 +0200
Message-Id: <20210405085038.264786120@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Lynch <nathanl@linux.ibm.com>

[ Upstream commit e834df6cfc71d8e5ce2c27a0184145ea125c3f0f ]

The atomic_t counter is the only shared state for the join/suspend
sequence so far, but that will change. Contain it in a
struct (pseries_suspend_info), and document its intended use. No
functional change.

Signed-off-by: Nathan Lynch <nathanl@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210315080045.460331-2-nathanl@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/mobility.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/mobility.c b/arch/powerpc/platforms/pseries/mobility.c
index ea4d6a660e0d..a6739ce9feac 100644
--- a/arch/powerpc/platforms/pseries/mobility.c
+++ b/arch/powerpc/platforms/pseries/mobility.c
@@ -452,9 +452,21 @@ static int do_suspend(void)
 	return ret;
 }
 
+/**
+ * struct pseries_suspend_info - State shared between CPUs for join/suspend.
+ * @counter: Threads are to increment this upon resuming from suspend
+ *           or if an error is received from H_JOIN. The thread which performs
+ *           the first increment (i.e. sets it to 1) is responsible for
+ *           waking the other threads.
+ */
+struct pseries_suspend_info {
+	atomic_t counter;
+};
+
 static int do_join(void *arg)
 {
-	atomic_t *counter = arg;
+	struct pseries_suspend_info *info = arg;
+	atomic_t *counter = &info->counter;
 	long hvrc;
 	int ret;
 
@@ -535,11 +547,15 @@ static int pseries_suspend(u64 handle)
 	int ret;
 
 	while (true) {
-		atomic_t counter = ATOMIC_INIT(0);
+		struct pseries_suspend_info info;
 		unsigned long vasi_state;
 		int vasi_err;
 
-		ret = stop_machine(do_join, &counter, cpu_online_mask);
+		info = (struct pseries_suspend_info) {
+			.counter = ATOMIC_INIT(0),
+		};
+
+		ret = stop_machine(do_join, &info, cpu_online_mask);
 		if (ret == 0)
 			break;
 		/*
-- 
2.30.2



