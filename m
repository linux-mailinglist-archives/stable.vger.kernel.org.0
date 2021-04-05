Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0EE353FFE
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239441AbhDEJPg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:15:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:34106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239948AbhDEJOa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:14:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 92B8361393;
        Mon,  5 Apr 2021 09:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614064;
        bh=3BvR0ffp7+3mRB0vqYFJ4S/UdIIp26m/T6ItaId+zvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8CIEhuuLXK3JAOXQb0aW6qwWeYG33jfzEB6p+Xv/nBw1eASbYzrQwgEt8RXjlRwO
         ltq2RrE7t5u7IBTjFGiiuK+XoxT7jlKM4R/8UwVl1a1xxQxX62ZQdlgLibuwIrEZgI
         T+rNe3nmqNb334yK4ukED8EnqPdUXjodbS95r8XI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 035/152] Revert "PM: ACPI: reboot: Use S5 for reboot"
Date:   Mon,  5 Apr 2021 10:53:04 +0200
Message-Id: <20210405085035.400511931@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



