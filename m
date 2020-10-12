Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCFE828BA00
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 16:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390967AbgJLOFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 10:05:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:37228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730262AbgJLNfh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:35:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 14731208B8;
        Mon, 12 Oct 2020 13:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602509728;
        bh=cRZwsTwV1n6Wp1uz0djYGfR4/C8Jq4a8bdMtfvv7hLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHg9D/E2KWti101XC9NyT3b+JHOnWIBoa6nYbZjty3XPTEpOfe1FepBDcmun15QQR
         WWFGIVWSyvC/Woqbz8hw3BWZP28WhaU936cfhTvvNPsgPIrrSoEA+gG+lJrfj3WTTj
         69rWFRz6ANvwUxbzl5kHJA89FJ9V1YGDr7wA7YTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Barret Rhoden <brho@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 52/54] perf: Fix task_function_call() error handling
Date:   Mon, 12 Oct 2020 15:27:14 +0200
Message-Id: <20201012132631.977230363@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012132629.585664421@linuxfoundation.org>
References: <20201012132629.585664421@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kajol Jain <kjain@linux.ibm.com>

[ Upstream commit 6d6b8b9f4fceab7266ca03d194f60ec72bd4b654 ]

The error handling introduced by commit:

  2ed6edd33a21 ("perf: Add cond_resched() to task_function_call()")

looses any return value from smp_call_function_single() that is not
{0, -EINVAL}. This is a problem because it will return -EXNIO when the
target CPU is offline. Worse, in that case it'll turn into an infinite
loop.

Fixes: 2ed6edd33a21 ("perf: Add cond_resched() to task_function_call()")
Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Barret Rhoden <brho@google.com>
Tested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: https://lkml.kernel.org/r/20200827064732.20860-1-kjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index b562467d2d498..7aad4d22b4223 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -94,7 +94,7 @@ static void remote_function(void *data)
  * retry due to any failures in smp_call_function_single(), such as if the
  * task_cpu() goes offline concurrently.
  *
- * returns @func return value or -ESRCH when the process isn't running
+ * returns @func return value or -ESRCH or -ENXIO when the process isn't running
  */
 static int
 task_function_call(struct task_struct *p, remote_function_f func, void *info)
@@ -110,7 +110,8 @@ task_function_call(struct task_struct *p, remote_function_f func, void *info)
 	for (;;) {
 		ret = smp_call_function_single(task_cpu(p), remote_function,
 					       &data, 1);
-		ret = !ret ? data.ret : -EAGAIN;
+		if (!ret)
+			ret = data.ret;
 
 		if (ret != -EAGAIN)
 			break;
-- 
2.25.1



