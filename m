Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8C32E1352
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:36:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730587AbgLWCZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:25:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:55796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730585AbgLWCZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 316722333F;
        Wed, 23 Dec 2020 02:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690328;
        bh=0kn8mXbauLR+UF9rzbNPjRzYTRxHh/jSmbKpqQlLlIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tFBLF8luowHC7bdb9oZglbx9W0I3V1shyeDaRTq6XCusmL4LLZLRmEizRd7l/BCFV
         xja8mSp4H5oD76vCS5ZxGdVzpTjqArSQh1t/qJ4J8Up14f/WDb+Jrbo7pTS+6venOK
         d7gzcSxitj3hjKNI/KB+eVTJ7WNbaIAqlylh5CUelrQjx1Hp56tDMoCxlPnUDn8EJi
         euXGTAEIcREhXrxN+FrERWjY5Y2qjL/Pyh5zi7Sw7opperbT781GGP1+/UF+z6wRdg
         CsJjnQzyCkbqTxVKjNKQhZH9ah4PTPgXrUS1vMK09IIHxnzQ4XQARbA+5f5kJYidi4
         lCZ6pZ14kTqxQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 09/38] rcutorture: Prevent hangs for invalid arguments
Date:   Tue, 22 Dec 2020 21:24:47 -0500
Message-Id: <20201223022516.2794471-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022516.2794471-1-sashal@kernel.org>
References: <20201223022516.2794471-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

[ Upstream commit 4994684ce10924a0302567c315c91b0a64eeef46 ]

If an rcutorture torture-test run is given a bad kvm.sh argument, the
test will complain to the console, which is good.  What is bad is that
from the user's perspective, it will just hang for the time specified
by the --duration argument.  This commit therefore forces an immediate
kernel shutdown if a rcu_torture_init()-time error occurs, thus avoiding
the appearance of a hang.  It also forces a console splat in this case
to clearly indicate the presence of an error.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rcu/rcutorture.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 041a02b334d73..d808212822d71 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1914,6 +1914,10 @@ rcu_torture_init(void)
 unwind:
 	torture_init_end();
 	rcu_torture_cleanup();
+	if (shutdown_secs) {
+		WARN_ON(!IS_MODULE(CONFIG_RCU_TORTURE_TEST));
+		kernel_power_off();
+	}
 	return firsterr;
 }
 
-- 
2.27.0

