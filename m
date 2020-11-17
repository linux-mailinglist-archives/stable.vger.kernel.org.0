Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E99A2B5FBC
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:00:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgKQM57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:57:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:55086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728790AbgKQM56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:57:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A922124654;
        Tue, 17 Nov 2020 12:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617877;
        bh=0A66eNDJ2aZU+lf9L5muAqnCOkTKeAP0usRGZ3A0xHs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ddibk3dXNmY4Nj6u/Kh3p4V+EiNkUKAdB1hWmK4KP7WQXlF6plnGkVJXWWKp7l/mV
         wqB2/IhSFsgssdiPpOUoCdyRvJPeWF4mTVhdv3yUGxg5doEF0XA6+4PaDh7dBi0yid
         tSD1ka/sGcMcMh17PIjGaDhFQl2p6pB6iBXXaaLY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Will Deacon <will@kernel.org>, Qian Cai <cai@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 2/3] arm64: psci: Avoid printing in cpu_psci_cpu_die()
Date:   Tue, 17 Nov 2020 07:57:52 -0500
Message-Id: <20201117125753.600073-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117125753.600073-1-sashal@kernel.org>
References: <20201117125753.600073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

[ Upstream commit 891deb87585017d526b67b59c15d38755b900fea ]

cpu_psci_cpu_die() is called in the context of the dying CPU, which
will no longer be online or tracked by RCU. It is therefore not generally
safe to call printk() if the PSCI "cpu off" request fails, so remove the
pr_crit() invocation.

Cc: Qian Cai <cai@redhat.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/20201106103602.9849-2-will@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/psci.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/psci.c b/arch/arm64/kernel/psci.c
index 3856d51c645b5..3ebb2a56e5f7b 100644
--- a/arch/arm64/kernel/psci.c
+++ b/arch/arm64/kernel/psci.c
@@ -69,7 +69,6 @@ static int cpu_psci_cpu_disable(unsigned int cpu)
 
 static void cpu_psci_cpu_die(unsigned int cpu)
 {
-	int ret;
 	/*
 	 * There are no known implementations of PSCI actually using the
 	 * power state field, pass a sensible default for now.
@@ -77,9 +76,7 @@ static void cpu_psci_cpu_die(unsigned int cpu)
 	u32 state = PSCI_POWER_STATE_TYPE_POWER_DOWN <<
 		    PSCI_0_2_POWER_STATE_TYPE_SHIFT;
 
-	ret = psci_ops.cpu_off(state);
-
-	pr_crit("unable to power off CPU%u (%d)\n", cpu, ret);
+	psci_ops.cpu_off(state);
 }
 
 static int cpu_psci_cpu_kill(unsigned int cpu)
-- 
2.27.0

