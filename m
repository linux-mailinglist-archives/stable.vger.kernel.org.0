Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD30A2EDAF
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732534AbfE3DVW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:21:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:34358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732527AbfE3DVW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:21:22 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C36DB2499E;
        Thu, 30 May 2019 03:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186479;
        bh=R1Y/Uxnl9zCkAKdG+RQhuidqwjK17ZPDNJ3eFv/YJNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ARmSnt3GBPZd4znfD1cTPpH+auovG+29d+RN08XN9cWfGFeHoqmV3Hkw/KQdgXsob
         KFKcMaHfX2kH5rmis4xOFWF8j86TwdE5/yD1k3dtwCyIJ49XZ0Xk/CG4LvsIWxiWBt
         Y3K/jNISJGiHLV6yzgvjeKOFIbGHUg2YF4MWRxKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 115/128] rcuperf: Fix cleanup path for invalid perf_type strings
Date:   Wed, 29 May 2019 20:07:27 -0700
Message-Id: <20190530030455.194275136@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030432.977908967@linuxfoundation.org>
References: <20190530030432.977908967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ad092c027713a68a34168942a5ef422e42e039f4 ]

If the specified rcuperf.perf_type is not in the rcu_perf_init()
function's perf_ops[] array, rcuperf prints some console messages and
then invokes rcu_perf_cleanup() to set state so that a future torture
test can run.  However, rcu_perf_cleanup() also attempts to end the
test that didn't actually start, and in doing so relies on the value
of cur_ops, a value that is not particularly relevant in this case.
This can result in confusing output or even follow-on failures due to
attempts to use facilities that have not been properly initialized.

This commit therefore sets the value of cur_ops to NULL in this case and
inserts a check near the beginning of rcu_perf_cleanup(), thus avoiding
relying on an irrelevant cur_ops value.

Signed-off-by: Paul E. McKenney <paulmck@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcuperf.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/rcu/rcuperf.c b/kernel/rcu/rcuperf.c
index 123ccbd224492..2b8579d5a5445 100644
--- a/kernel/rcu/rcuperf.c
+++ b/kernel/rcu/rcuperf.c
@@ -453,6 +453,10 @@ rcu_perf_cleanup(void)
 
 	if (torture_cleanup_begin())
 		return;
+	if (!cur_ops) {
+		torture_cleanup_end();
+		return;
+	}
 
 	if (reader_tasks) {
 		for (i = 0; i < nrealreaders; i++)
@@ -574,6 +578,7 @@ rcu_perf_init(void)
 			pr_alert(" %s", perf_ops[i]->name);
 		pr_alert("\n");
 		firsterr = -EINVAL;
+		cur_ops = NULL;
 		goto unwind;
 	}
 	if (cur_ops->init)
-- 
2.20.1



