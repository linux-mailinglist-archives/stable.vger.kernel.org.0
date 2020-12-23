Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793E12E133D
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgLWCZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:25:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:55298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728837AbgLWCZJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:25:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC25E22AAF;
        Wed, 23 Dec 2020 02:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690269;
        bh=c3buPnnkwx3H0BgnT3QToIHSkur/PTHg/tUxxAmW6RM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lMKWu4Nb8X9x4S5pjEL0JppDyb3voHAEb/EZKhK4XHuLAWnpQbBtk6wPYs9J94ZAF
         aUbitd8RIgl9XkLqae4Is/SMxiCcTFvYUxJBWc/CXnJ4Dk+y9MSNveHlDYN6JNy3EQ
         HoNW6n2+PMDSBya14KO07mVl8pHS6eV/tdPYUyC+ZBUbhHAYrg3kyriyjJRJOg+ZsF
         KbE3W1yXY5Efg09Bqnwy4E4JewRasfQP61ExOCRnKT8UuyOVCEDJJifppKp/XSbwyx
         oQkaJmIxsaV7vWcUB5LK6g/zWW8Nbcw/RB69XYx3b+RREOw05VD5iAPgVnsgLKoFJR
         I7wXhrrkLsUCQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 10/48] rcutorture: Prevent hangs for invalid arguments
Date:   Tue, 22 Dec 2020 21:23:38 -0500
Message-Id: <20201223022417.2794032-10-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022417.2794032-1-sashal@kernel.org>
References: <20201223022417.2794032-1-sashal@kernel.org>
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
index 5393bbcf3c1ad..1e3c28e9bf0de 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1902,6 +1902,10 @@ rcu_torture_init(void)
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

