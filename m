Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5FF32EE94
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732351AbfE3Dsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:48:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732156AbfE3DUT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:19 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1088E248EA;
        Thu, 30 May 2019 03:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186419;
        bh=qhUPIOZDf5n5/v9M18yrBJksrLTGbpEW3T687eaFetg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rsqPxDk5xUXyPMC+E0sKuV9may0ULolsB/bS3gyjc64E9v4cAyo6So/4lHeeS41/e
         HwtiMoRuwpCMGtn+sjh6/38jpzQsmoDXqZmpFomU+qhzmSBcaaCde5jCvSIl3aFVFP
         905o9H2MPYExYFybLuQZxmlZl82U3JuY+ulgLjmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 171/193] rcuperf: Fix cleanup path for invalid perf_type strings
Date:   Wed, 29 May 2019 20:07:05 -0700
Message-Id: <20190530030511.785867340@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
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
index 1f87a02c33999..9b0d38812eb62 100644
--- a/kernel/rcu/rcuperf.c
+++ b/kernel/rcu/rcuperf.c
@@ -542,6 +542,10 @@ rcu_perf_cleanup(void)
 
 	if (torture_cleanup_begin())
 		return;
+	if (!cur_ops) {
+		torture_cleanup_end();
+		return;
+	}
 
 	if (reader_tasks) {
 		for (i = 0; i < nrealreaders; i++)
@@ -663,6 +667,7 @@ rcu_perf_init(void)
 			pr_alert(" %s", perf_ops[i]->name);
 		pr_alert("\n");
 		firsterr = -EINVAL;
+		cur_ops = NULL;
 		goto unwind;
 	}
 	if (cur_ops->init)
-- 
2.20.1



