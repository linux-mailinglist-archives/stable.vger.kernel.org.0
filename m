Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F8D4BE5E5
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237219AbiBUJ72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:59:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354094AbiBUJ6J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:58:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2E7A49257;
        Mon, 21 Feb 2022 01:27:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACDDCB80ECF;
        Mon, 21 Feb 2022 09:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3BEFC340E9;
        Mon, 21 Feb 2022 09:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435642;
        bh=YPmrjZCA/qvxTOK2iFsBy8+N9NJ3GXDz4AwzbwadkqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OglP0Avy5MqEUcI3Mxg+EkSLiG2emylJa0H9q8L6rTe+vfAQciNHK8aCD+tTR/6/D
         89gi9tj+zBxM9wjFgyz9Zq56he6/nOB6z0RLHznMT1VZ0EFbpDyAas11L/Ext2WL1Y
         WAqLltQVBgzIkeIM183PuxL0+LKwCN2fxxYc8/FI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 214/227] ACPI: PM: Revert "Only mark EC GPE for wakeup on Intel systems"
Date:   Mon, 21 Feb 2022 09:50:33 +0100
Message-Id: <20220221084941.931483278@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit d6ebb17ccc7b37872a32bc25b4a21f1e5af8c7e3 ]

Testing on various upcoming OEM systems shows commit 7b167c4cb48e ("ACPI:
PM: Only mark EC GPE for wakeup on Intel systems") was short
sighted and the symptoms were indicative of other problems. Some OEMs
do have the dedicated GPIOs for the power button but also rely upon
an interrupt to the EC SCI to let the lid work.

The original commit showed spurious activity on Lenovo systems:
     * On both Lenovo T14 and P14s the keyboard wakeup doesn't work, and
       sometimes the power button event doesn't work.

This was confirmed on my end at that time.

However further development in the kernel showed that the issue was
actually the IRQ for the GPIO controller was also shared with the EC SCI.
This was actually fixed by commit 2d54067fcd23 ("pinctrl: amd: Fix
wakeups when IRQ is shared with SCI").

The original commit also showed problems with AC adapter:
     * On HP 635 G7 detaching or attaching AC during suspend will cause
       the system not to wakeup
     * On Asus vivobook to prevent detaching AC causing resume problems
     * On Lenovo 14ARE05 to prevent detaching AC causing resume problems
     * On HP ENVY x360  to prevent detaching AC causing resume problems

Detaching AC adapter causing problems appears to have been a problem
because the EC SCI went off to notify the OS of the power adapter change
but the SCI was ignored and there was no other way to wake up this system
since GPIO controller wasn't properly enabled.  The wakeups were fixed by
enabling the GPIO controller in commit acd47b9f28e5 ("pinctrl: amd: Handle
wake-up interrupt").

I've confirmed on a variety of OEM notebooks with the following test

 1) echo 1 | sudo tee /sys/power/pm_debug_messages
 2) sudo systemctl suspend
 3) unplug AC adapter, make sure system is still asleep
 4) wake system from lid (which is provided by ACPI SCI on some of them)
 5) dmesg
    a) see the EC GPE dispatched, timekeeping for X seconds (matching ~time
       until AC adapter plug out)
    b) see timekeeping for Y seconds until woke (matching ~time from AC
       adapter until lid event)
 6) Look at /sys/kernel/debug/amd_pmc/s0ix_stats
    "Time (in us) in S0i3" = X + Y - firmware processing time

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/s2idle.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/acpi/x86/s2idle.c b/drivers/acpi/x86/s2idle.c
index 1c48358b43ba3..e0185e841b2a3 100644
--- a/drivers/acpi/x86/s2idle.c
+++ b/drivers/acpi/x86/s2idle.c
@@ -424,15 +424,11 @@ static int lps0_device_attach(struct acpi_device *adev,
 		mem_sleep_current = PM_SUSPEND_TO_IDLE;
 
 	/*
-	 * Some Intel based LPS0 systems, like ASUS Zenbook UX430UNR/i7-8550U don't
-	 * use intel-hid or intel-vbtn but require the EC GPE to be enabled while
-	 * suspended for certain wakeup devices to work, so mark it as wakeup-capable.
-	 *
-	 * Only enable on !AMD as enabling this universally causes problems for a number
-	 * of AMD based systems.
+	 * Some LPS0 systems, like ASUS Zenbook UX430UNR/i7-8550U, require the
+	 * EC GPE to be enabled while suspended for certain wakeup devices to
+	 * work, so mark it as wakeup-capable.
 	 */
-	if (!acpi_s2idle_vendor_amd())
-		acpi_ec_mark_gpe_for_wake();
+	acpi_ec_mark_gpe_for_wake();
 
 	return 0;
 }
-- 
2.34.1



