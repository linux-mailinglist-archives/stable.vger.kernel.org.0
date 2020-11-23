Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0682C0AA4
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729661AbgKWMXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:23:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:33020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729399AbgKWMXn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:23:43 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67A31208C3;
        Mon, 23 Nov 2020 12:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134222;
        bh=LgOf4RUUX2aOzmRVCY4k7EOzBrEF5eZj+47Nx5X8j3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AsRzksry6BCS5foRcJIHpD6luBDt6k9twyLnR9ZR7SC4taNXqCtFNyEcjvfhQQRNN
         GtKnYGKIF1Q3pYSY4W5FjFmvPqAvBxlkC7Ca/7IZ+jLYv+8JbCcvBfYcKj8Je7Qlec
         sHq06WqBomDst0V/gQUtGYQgUUVUv0dw/GbTf0FE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 14/38] arm64: psci: Avoid printing in cpu_psci_cpu_die()
Date:   Mon, 23 Nov 2020 13:22:00 +0100
Message-Id: <20201123121804.994617906@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121804.306030358@linuxfoundation.org>
References: <20201123121804.306030358@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e6ad81556575c..ae91d202b7475 100644
--- a/arch/arm64/kernel/psci.c
+++ b/arch/arm64/kernel/psci.c
@@ -136,7 +136,6 @@ static int cpu_psci_cpu_disable(unsigned int cpu)
 
 static void cpu_psci_cpu_die(unsigned int cpu)
 {
-	int ret;
 	/*
 	 * There are no known implementations of PSCI actually using the
 	 * power state field, pass a sensible default for now.
@@ -144,9 +143,7 @@ static void cpu_psci_cpu_die(unsigned int cpu)
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



