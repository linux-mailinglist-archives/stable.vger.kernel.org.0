Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7BE3DECE6
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 13:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236293AbhHCLov (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 07:44:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:35212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236168AbhHCLo1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Aug 2021 07:44:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B374060EFD;
        Tue,  3 Aug 2021 11:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627991056;
        bh=6pfrQY5QyDEqVrt2lMWcXkE5SO4dTw+z8f67Irfj2EA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExIOw9ueZBbSesxTUQxpRWpj75BmWqluzoSr8MF4TzrM2UjyTxSMdqlkHxudoQhvM
         HLx5DQ0yVgdx6Ds7TNGz7zlIWHoIocq2DihvE97w+Mq3V+pRpaOJX2NRnWY4iPhEMn
         rsi2K5zJBqTIFtebMU0SzRIC/3XrO6bqwZQreSd1bGuGIB1gbjff2ykK/Xqdj0xyAq
         D82pqZQ8IeYJu5WYhc2uMn5IUD6PXeK3EHfWFALjUUT0kYiclzLGMCmtapzrnll4oO
         CR+4jq3RRqyxHFN7AyS0e04UhJ9R0WhESDeBCF0ZbhG0c7f3tA9OXcrGKizwLel3z/
         dYghaQsU+HB7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prarit Bhargava <prarit@redhat.com>,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-alpha@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 6/9] alpha: Send stop IPI to send to online CPUs
Date:   Tue,  3 Aug 2021 07:44:05 -0400
Message-Id: <20210803114408.2252713-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210803114408.2252713-1-sashal@kernel.org>
References: <20210803114408.2252713-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prarit Bhargava <prarit@redhat.com>

[ Upstream commit caace6ca4e06f09413fb8f8a63319594cfb7d47d ]

This issue was noticed while debugging a shutdown issue where some
secondary CPUs are not being shutdown correctly.  A fix for that [1] requires
that secondary cpus be offlined using the cpu_online_mask so that the
stop operation is a no-op if CPU HOTPLUG is disabled.  I, like the author in
[1] looked at the architectures and found that alpha is one of two
architectures that executes smp_send_stop() on all possible CPUs.

On alpha, smp_send_stop() sends an IPI to all possible CPUs but only needs
to send them to online CPUs.

Send the stop IPI to only the online CPUs.

[1] https://lkml.org/lkml/2020/1/10/250

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Signed-off-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 4b2575f936d4..cb64e4797d2a 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -582,7 +582,7 @@ void
 smp_send_stop(void)
 {
 	cpumask_t to_whom;
-	cpumask_copy(&to_whom, cpu_possible_mask);
+	cpumask_copy(&to_whom, cpu_online_mask);
 	cpumask_clear_cpu(smp_processor_id(), &to_whom);
 #ifdef DEBUG_IPI_MSG
 	if (hard_smp_processor_id() != boot_cpu_id)
-- 
2.30.2

