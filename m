Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18485452625
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241097AbhKPCCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:02:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:46092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240015AbhKOSF3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8333A63376;
        Mon, 15 Nov 2021 17:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998086;
        bh=aNF68QxE4wGq0KdsKMD62usCtLzUnnsvJbcTwAEp5dg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B7PVK658Dhu9tx3gG7lcJ8Dnaifio2pJwtA0xxggp3k/tnC1UQ2h1NyyQakNLNoGv
         /WYCe2i4Hp2g5rJL/bCQNN2+N4oV61ltilIO0msG5KGh4sqFhnasoP7Ju0E3eiKPlf
         76sGnDlJ6rd5vedje/+Lz7KHs80QpwPyN2B5yqR8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Schatzberg <schatzberg.dan@gmail.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 382/575] cgroup: Fix rootcg cpu.stat guest double counting
Date:   Mon, 15 Nov 2021 18:01:47 +0100
Message-Id: <20211115165356.994356315@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Schatzberg <schatzberg.dan@gmail.com>

[ Upstream commit 81c49d39aea8a10e6d05d3aa1cb65ceb721e19b0 ]

In account_guest_time in kernel/sched/cputime.c guest time is
attributed to both CPUTIME_NICE and CPUTIME_USER in addition to
CPUTIME_GUEST_NICE and CPUTIME_GUEST respectively. Therefore, adding
both to calculate usage results in double counting any guest time at
the rootcg.

Fixes: 936f2a70f207 ("cgroup: add cpu.stat file to root cgroup")
Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/rstat.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index d51175cedfca4..89ca9b61aa0d9 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -421,8 +421,6 @@ static void root_cgroup_cputime(struct task_cputime *cputime)
 		cputime->sum_exec_runtime += user;
 		cputime->sum_exec_runtime += sys;
 		cputime->sum_exec_runtime += cpustat[CPUTIME_STEAL];
-		cputime->sum_exec_runtime += cpustat[CPUTIME_GUEST];
-		cputime->sum_exec_runtime += cpustat[CPUTIME_GUEST_NICE];
 	}
 }
 
-- 
2.33.0



