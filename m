Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8220C348F35
	for <lists+stable@lfdr.de>; Thu, 25 Mar 2021 12:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbhCYL0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Mar 2021 07:26:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230051AbhCYLZt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Mar 2021 07:25:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53B9661A2E;
        Thu, 25 Mar 2021 11:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616671548;
        bh=3BvR0ffp7+3mRB0vqYFJ4S/UdIIp26m/T6ItaId+zvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UiFTwtSt2RYZ022DE/Tr8nD7q2n4HL9xjz2xdaX+7CNPKWsKNRCd115qwgQAEnpb4
         3MiUbbqwQRtdzpb/OaU3Uw9HHWLnpfRPKV6RbE5u21K7izEm8vKwTPj2UqMOvhyx6z
         fJdFx8dUZUv5YIYYlxFMPxz+jyM55aJ+kK0JfaVCS030LZ5yOvXyWDz4a1yhmCshFB
         25Kua2vLNJVsTkc/K5KhpMrR8ISTpD1kxmd952xNO9BK6sL5E0chcUi1ST6fjsN4cJ
         +Ngi8jHxw7KfdvtZ32bwIMb6KqUl0kn0a2u2/N0rnxNz3kEXmtk3y7NA1d/SxbPDj3
         Ft/C/FDJ3PgEQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Josef Bacik <josef@toxicpanda.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.11 38/44] Revert "PM: ACPI: reboot: Use S5 for reboot"
Date:   Thu, 25 Mar 2021 07:24:53 -0400
Message-Id: <20210325112459.1926846-38-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210325112459.1926846-1-sashal@kernel.org>
References: <20210325112459.1926846-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 9d3fcb28f9b9750b474811a2964ce022df56336e ]

This reverts commit d60cd06331a3566d3305b3c7b566e79edf4e2095.

This patch causes a panic when rebooting my Dell Poweredge r440.  I do
not have the full panic log as it's lost at that stage of the reboot and
I do not have a serial console.  Reverting this patch makes my system
able to reboot again.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/reboot.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index eb1b15850761..a6ad5eb2fa73 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -244,8 +244,6 @@ void migrate_to_reboot_cpu(void)
 void kernel_restart(char *cmd)
 {
 	kernel_restart_prepare(cmd);
-	if (pm_power_off_prepare)
-		pm_power_off_prepare();
 	migrate_to_reboot_cpu();
 	syscore_shutdown();
 	if (!cmd)
-- 
2.30.1

