Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF9428B7FC
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731932AbgJLNsV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:48:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731913AbgJLNsT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:48:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E9E622261;
        Mon, 12 Oct 2020 13:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510462;
        bh=BmMkscqni3z3kbdxQ8N1/oxND7uMdaOTIwS2+O997cs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WGwB50YeSkVFuK/N/YQsQnPNgGknH4zDvZJjIN4swcLrACa+KoMUrZXlxzCws8Qlc
         0uzhs3z9HBg45c1oc9/pXS/IU/6hORS1V0aKE68iTnY1mbADthWhd2azcg5zBdrs7L
         YFVjtlHwohIbCPfRJFrRH8YnMELg2LDAyXfA9inE=
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
Subject: [PATCH 5.8 109/124] perf: Fix task_function_call() error handling
Date:   Mon, 12 Oct 2020 15:31:53 +0200
Message-Id: <20201012133152.134871810@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
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
index 856d98c36f562..fd8cd00099dae 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -99,7 +99,7 @@ static void remote_function(void *data)
  * retry due to any failures in smp_call_function_single(), such as if the
  * task_cpu() goes offline concurrently.
  *
- * returns @func return value or -ESRCH when the process isn't running
+ * returns @func return value or -ESRCH or -ENXIO when the process isn't running
  */
 static int
 task_function_call(struct task_struct *p, remote_function_f func, void *info)
@@ -115,7 +115,8 @@ task_function_call(struct task_struct *p, remote_function_f func, void *info)
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



