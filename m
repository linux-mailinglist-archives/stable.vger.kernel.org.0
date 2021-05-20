Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5490E38A694
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236821AbhETK22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:28:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236432AbhETK00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:26:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0748A61C21;
        Thu, 20 May 2021 09:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504215;
        bh=7RWaWjYveePaY8Mpxqu4kZZKehtD0m+H22q+9jrGGSc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AxguqGI2wJ7Sv9Z0SShBW6uFqQN3oI0Q3byGixMZ/E9wL/TQJOgdCqkor+fE8YnjN
         JQ632rwOx/He6+I87d+EEy1QSFpeVeRYkBi0QdCzaL/zYGkpY86V9TKSUsVfVB0Cwy
         3BLpmX3BV4M3xtrArjWhOPbnzGAK88yHpYFLiRqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Otavio Pontes <otavio.pontes@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>,
        Ashok Raj <ashok.raj@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 145/323] x86/microcode: Check for offline CPUs before requesting new microcode
Date:   Thu, 20 May 2021 11:20:37 +0200
Message-Id: <20210520092125.070854324@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Otavio Pontes <otavio.pontes@intel.com>

[ Upstream commit 7189b3c11903667808029ec9766a6e96de5012a5 ]

Currently, the late microcode loading mechanism checks whether any CPUs
are offlined, and, in such a case, aborts the load attempt.

However, this must be done before the kernel caches new microcode from
the filesystem. Otherwise, when offlined CPUs are onlined later, those
cores are going to be updated through the CPU hotplug notifier callback
with the new microcode, while CPUs previously onine will continue to run
with the older microcode.

For example:

Turn off one core (2 threads):

  echo 0 > /sys/devices/system/cpu/cpu3/online
  echo 0 > /sys/devices/system/cpu/cpu1/online

Install the ucode fails because a primary SMT thread is offline:

  cp intel-ucode/06-8e-09 /lib/firmware/intel-ucode/
  echo 1 > /sys/devices/system/cpu/microcode/reload
  bash: echo: write error: Invalid argument

Turn the core back on

  echo 1 > /sys/devices/system/cpu/cpu3/online
  echo 1 > /sys/devices/system/cpu/cpu1/online
  cat /proc/cpuinfo |grep microcode
  microcode : 0x30
  microcode : 0xde
  microcode : 0x30
  microcode : 0xde

The rationale for why the update is aborted when at least one primary
thread is offline is because even if that thread is soft-offlined
and idle, it will still have to participate in broadcasted MCE's
synchronization dance or enter SMM, and in both examples it will execute
instructions so it better have the same microcode revision as the other
cores.

 [ bp: Heavily edit and extend commit message with the reasoning behind all
   this. ]

Fixes: 30ec26da9967 ("x86/microcode: Do not upload microcode if CPUs are offline")
Signed-off-by: Otavio Pontes <otavio.pontes@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Acked-by: Ashok Raj <ashok.raj@intel.com>
Link: https://lkml.kernel.org/r/20210319165515.9240-2-otavio.pontes@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/microcode/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 93c22e7ee424..51583a5d656d 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -627,16 +627,16 @@ static ssize_t reload_store(struct device *dev,
 	if (val != 1)
 		return size;
 
-	tmp_ret = microcode_ops->request_microcode_fw(bsp, &microcode_pdev->dev, true);
-	if (tmp_ret != UCODE_NEW)
-		return size;
-
 	get_online_cpus();
 
 	ret = check_online_cpus();
 	if (ret)
 		goto put;
 
+	tmp_ret = microcode_ops->request_microcode_fw(bsp, &microcode_pdev->dev, true);
+	if (tmp_ret != UCODE_NEW)
+		goto put;
+
 	mutex_lock(&microcode_mutex);
 	ret = microcode_reload_late();
 	mutex_unlock(&microcode_mutex);
-- 
2.30.2



