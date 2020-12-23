Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C0E2E1496
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 03:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730112AbgLWClK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:41:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:52560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728912AbgLWCX2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:23:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E49422AAF;
        Wed, 23 Dec 2020 02:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690188;
        bh=MAJyDIDzl0y0Ea6FEt5VUHOzIfZ9GOV1Yrm1iTEG/mE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=etV1GHRk7nmGM/A6yHmSLZUydQXK33Sf0qDEfDHNNE2I/ziTHqWgv/8DZW58M5CJG
         RhcFwdTtT7M6BMw2wg16li7vIeivRW//qfSognRFhJSjoBF4J7mQfH1UeOsqaQl12i
         f+53B48KldMlc+zf6oQZaMbUm/sfGMRVj8oq9ENZXaNf+fRuYfyHBteQdz5VL2chnx
         CY6xwDQhMlGXCUUx6s1KTRM6vIwmzeIz7P77JiKXOSevMp0eUmZL+dMkMLI8dtCh+a
         LjP++hAu571frMWbgHXW4HKR/A5DGcwx6UEKTCNFb1jFjA9H6W8LjKbK0PZRwW8fDF
         saunSKBVJ6WFg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>, rcu@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 12/66] rcutorture: Prevent hangs for invalid arguments
Date:   Tue, 22 Dec 2020 21:21:58 -0500
Message-Id: <20201223022253.2793452-12-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223022253.2793452-1-sashal@kernel.org>
References: <20201223022253.2793452-1-sashal@kernel.org>
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
index f0c599bf4058c..0904caa1b7344 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -1906,6 +1906,10 @@ rcu_torture_init(void)
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

