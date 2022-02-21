Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C804BE4A5
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350633AbiBUJf2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:35:28 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350603AbiBUJem (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:34:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94C442AE15;
        Mon, 21 Feb 2022 01:14:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34FD860E05;
        Mon, 21 Feb 2022 09:14:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46869C340F3;
        Mon, 21 Feb 2022 09:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434876;
        bh=YPmrjZCA/qvxTOK2iFsBy8+N9NJ3GXDz4AwzbwadkqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lDeuHoclI19EmvxE6U/7AKE3B6FtXc3TtziuJ0vN1ecInJtGpZLr+NHsyx2HkC70k
         ZO8Ef5421KjfpMD6enuZnhSwBsRIQSrIYnrFIz8w2lH3cJu7xt7LwIE34mWk0NgUlh
         HOjWZG7y96asaLUSpiY6BpImcgRXGstCzJj4dvCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/196] ACPI: PM: Revert "Only mark EC GPE for wakeup on Intel systems"
Date:   Mon, 21 Feb 2022 09:49:55 +0100
Message-Id: <20220221084936.402708050@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
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



