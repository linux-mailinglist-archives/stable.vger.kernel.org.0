Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5F3945115E
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243474AbhKOTG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:06:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243472AbhKOTC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:02:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5BBB63376;
        Mon, 15 Nov 2021 18:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000122;
        bh=HjgqYGx+2W5PaRsp50nEwbylJdieHOMgkFTRSmJGtpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nC+ykWROaDUQjHs/wkz6qz23s0IazNihX0GwmVxE1oWjMOG+VbvswT+ND8MeXdjvh
         tnLWi3v0qH65HVxrzS9xDTZax3XWCwf6jAFWlne2vjEBFGQa5TVVVks1JPMvZ3cbh/
         YOtMMtJYsjwksqJYYEvf+aoR/Azkb9t5wSb4XASs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Schatzberg <schatzberg.dan@gmail.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 546/849] cgroup: Fix rootcg cpu.stat guest double counting
Date:   Mon, 15 Nov 2021 18:00:29 +0100
Message-Id: <20211115165438.732748848@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index b264ab5652ba9..1486768f23185 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -433,8 +433,6 @@ static void root_cgroup_cputime(struct task_cputime *cputime)
 		cputime->sum_exec_runtime += user;
 		cputime->sum_exec_runtime += sys;
 		cputime->sum_exec_runtime += cpustat[CPUTIME_STEAL];
-		cputime->sum_exec_runtime += cpustat[CPUTIME_GUEST];
-		cputime->sum_exec_runtime += cpustat[CPUTIME_GUEST_NICE];
 	}
 }
 
-- 
2.33.0



