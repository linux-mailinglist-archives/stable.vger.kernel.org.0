Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5918147BBE
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:48:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731825AbgAXJlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:41:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:38504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732698AbgAXJlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:41:04 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 587C82070A;
        Fri, 24 Jan 2020 09:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579858864;
        bh=tiERmv/8h8E8De24hSoO7PsoVcthP/fVu/lPSIIUBUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rAs3N4DABhBT9C9FsT5VbqUYQLX5h1vu4DFQf8F91g7xQKxeLaX/xz4Xc3S0fmsRh
         AXcVFh3cEwAzeZhbIhFfn4LjlkffZOqd3mzuBINuGYdvCTZqDfVA7rKMn3m1PusGcK
         RicHWYJ4NMxhFOjEYPVVgjYD/en44JeyA0JMcT0Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 068/102] rcu: Fix uninitialized variable in nocb_gp_wait()
Date:   Fri, 24 Jan 2020 10:31:09 +0100
Message-Id: <20200124092816.849855361@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092806.004582306@linuxfoundation.org>
References: <20200124092806.004582306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b8889c9c89a2655a231dfed93cc9bdca0930ea67 ]

We never set this to false.  This probably doesn't affect most people's
runtime because GCC will automatically initialize it to false at certain
common optimization levels.  But that behavior is related to a bug in
GCC and obviously should not be relied on.

Fixes: 5d6742b37727 ("rcu/nocb: Use rcu_segcblist for no-CBs CPUs")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/tree_plugin.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 2defc7fe74c39..fa08d55f7040c 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -1946,7 +1946,7 @@ static void nocb_gp_wait(struct rcu_data *my_rdp)
 	int __maybe_unused cpu = my_rdp->cpu;
 	unsigned long cur_gp_seq;
 	unsigned long flags;
-	bool gotcbs;
+	bool gotcbs = false;
 	unsigned long j = jiffies;
 	bool needwait_gp = false; // This prevents actual uninitialized use.
 	bool needwake;
-- 
2.20.1



