Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AEE01677E5
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgBUHtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 02:49:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:46528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728425AbgBUHtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 02:49:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A16A222C4;
        Fri, 21 Feb 2020 07:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582271391;
        bh=udPBDdvdYkxFiN4/6jnqwJPzNWTrlv9XsXtSLkNELoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RRlTphl/ugZbLaYTVMmjCWRBg8+8EL+cemH0kY3O7Uq79HxottvEXVgqOT7Jx3BIA
         0mn25CtzwTAQiPaF+9PbQM0HOMqsA6rE0UyjJRTx8XiWnqDI3yRRoy3pcIt1F9VDDa
         KPYWu8oubASY9/8DC9qmfFGbsRqBbEc1WMkbFBxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Borislav Petkov <bp@suse.de>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        bberg@redhat.com, ckellner@redhat.com, hdegoede@redhat.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        linux-edac <linux-edac@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 147/399] x86/mce/therm_throt: Mark throttle_active_work() as __maybe_unused
Date:   Fri, 21 Feb 2020 08:37:52 +0100
Message-Id: <20200221072416.791486452@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072402.315346745@linuxfoundation.org>
References: <20200221072402.315346745@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit db1ae0314f47e88ae06679270adf17ffa245afd4 ]

throttle_active_work() is only called if CONFIG_SYSFS is set, otherwise
we get a harmless warning:

  arch/x86/kernel/cpu/mce/therm_throt.c:238:13: error: 'throttle_active_work' \
	  defined but not used [-Werror=unused-function]

Mark the function as __maybe_unused to avoid the warning.

Fixes: f6656208f04e ("x86/mce/therm_throt: Optimize notifications of thermal throttle")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: bberg@redhat.com
Cc: ckellner@redhat.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: hdegoede@redhat.com
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20191210203925.3119091-1-arnd@arndb.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/mce/therm_throt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/therm_throt.c b/arch/x86/kernel/cpu/mce/therm_throt.c
index 6c3e1c92f1835..58b4ee3cda777 100644
--- a/arch/x86/kernel/cpu/mce/therm_throt.c
+++ b/arch/x86/kernel/cpu/mce/therm_throt.c
@@ -235,7 +235,7 @@ static void get_therm_status(int level, bool *proc_hot, u8 *temp)
 	*temp = (msr_val >> 16) & 0x7F;
 }
 
-static void throttle_active_work(struct work_struct *work)
+static void __maybe_unused throttle_active_work(struct work_struct *work)
 {
 	struct _thermal_state *state = container_of(to_delayed_work(work),
 						struct _thermal_state, therm_work);
-- 
2.20.1



