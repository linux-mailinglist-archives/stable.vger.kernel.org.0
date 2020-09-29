Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7094F27C69A
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730316AbgI2Lqu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:46:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730795AbgI2LqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:46:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 095C1206E5;
        Tue, 29 Sep 2020 11:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379971;
        bh=qSBxa+hR0DswKEbGWHDjnrrfzx2tHi92FAoUi0YWZ6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnQ/eTM0QkP7Qa83ul6G5i/PX7ua1jVZprw+VUBX9FqSihlCfrR0Gu61NwcDPWLil
         XXJc/x/OJrj9cxvjQVolW7FNVWuyGmSd5l9r1/ffp5d10Unsri+7wDOGiV0lzttLgN
         1sYNt8L5IajM429l39Z0Kd54Mcz/P74dHHHRVzr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 10/99] lockdep: fix order in trace_hardirqs_off_caller()
Date:   Tue, 29 Sep 2020 13:00:53 +0200
Message-Id: <20200929105930.227242587@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

[ Upstream commit 73ac74c7d489756d2313219a108809921dbfaea1 ]

Switch order so that locking state is consistent even
if the IRQ tracer calls into lockdep again.

Acked-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_preemptirq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_preemptirq.c b/kernel/trace/trace_preemptirq.c
index f10073e626030..f4938040c2286 100644
--- a/kernel/trace/trace_preemptirq.c
+++ b/kernel/trace/trace_preemptirq.c
@@ -102,14 +102,14 @@ NOKPROBE_SYMBOL(trace_hardirqs_on_caller);
 
 __visible void trace_hardirqs_off_caller(unsigned long caller_addr)
 {
+	lockdep_hardirqs_off(CALLER_ADDR0);
+
 	if (!this_cpu_read(tracing_irq_cpu)) {
 		this_cpu_write(tracing_irq_cpu, 1);
 		tracer_hardirqs_off(CALLER_ADDR0, caller_addr);
 		if (!in_nmi())
 			trace_irq_disable_rcuidle(CALLER_ADDR0, caller_addr);
 	}
-
-	lockdep_hardirqs_off(CALLER_ADDR0);
 }
 EXPORT_SYMBOL(trace_hardirqs_off_caller);
 NOKPROBE_SYMBOL(trace_hardirqs_off_caller);
-- 
2.25.1



