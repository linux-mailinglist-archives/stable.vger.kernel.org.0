Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45DE6687197
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 00:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjBAXDQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 18:03:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjBAXDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 18:03:15 -0500
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 277B666ED0
        for <stable@vger.kernel.org>; Wed,  1 Feb 2023 15:03:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
        s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dHFNUTKB0uKqi8DS58Tupf1zg7xK20+jiRop7d7FRAk=; b=QDd4+51AoQdln992XDuohoD5hj
        6+hXWktoovJ8EWzHTKmThGitmSHRhWItZ0bm2DSK12kXGHqQwKzUm6R/t1QlDRxLuMNOJp42qMn0E
        VC3CUyInrHFs0Ox0U/5PcfFmOeJFHp0gSqmStKyfJXNkUq2bw4SZt3qkYdz4YkhmqDe8E5gc8r1DK
        eZvm5PYo6xtBz3bzjRC6DjXIN+JJmUntpAc/tftSvIY51yN7LobP4t6l5bkq0zhmO50I2a4IvcHq+
        0ZO8KOO2dorE/fdJBWcit5B4rlBcFqI+ietwAeZmq1bAXraz/wSHJVt+JmAFKThHhqrdaJY1NkOg2
        p/KFuPvA==;
Received: from [187.10.60.187] (helo=localhost)
        by fanzine2.igalia.com with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
        id 1pNM88-006pvN-Bi; Thu, 02 Feb 2023 00:03:05 +0100
From:   "Guilherme G. Piccoli" <gpiccoli@igalia.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org, x86@kernel.org,
        kernel@gpiccoli.net, kernel-dev@igalia.com,
        Dave Hansen <dave.hansen@intel.com>,
        K Prateek Nayak <kprateek.nayak@amd.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Guilherme G . Piccoli" <gpiccoli@igalia.com>
Subject: [PATCH 5.10 / 5.15] ACPI: processor idle: Practically limit "Dummy wait" workaround to old Intel systems
Date:   Wed,  1 Feb 2023 20:02:48 -0300
Message-Id: <20230201230248.1372903-1-gpiccoli@igalia.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Hansen <dave.hansen@intel.com>

commit e400ad8b7e6a1b9102123c6240289a811501f7d9 upstream.

Old, circa 2002 chipsets have a bug: they don't go idle when they are
supposed to.  So, a workaround was added to slow the CPU down and
ensure that the CPU waits a bit for the chipset to actually go idle.
This workaround is ancient and has been in place in some form since
the original kernel ACPI implementation.

But, this workaround is very painful on modern systems.  The "inl()"
can take thousands of cycles (see Link: for some more detailed
numbers and some fun kernel archaeology).

First and foremost, modern systems should not be using this code.
Typical Intel systems have not used it in over a decade because it is
horribly inferior to MWAIT-based idle.

Despite this, people do seem to be tripping over this workaround on
AMD system today.

Limit the "dummy wait" workaround to Intel systems.  Keep Modern AMD
systems from tripping over the workaround.  Remotely modern Intel
systems use intel_idle instead of this code and will, in practice,
remain unaffected by the dummy wait.

Reported-by: K Prateek Nayak <kprateek.nayak@amd.com>
Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://lore.kernel.org/all/20220921063638.2489-1-kprateek.nayak@amd.com/
Link: https://lkml.kernel.org/r/20220922184745.3252932-1-dave.hansen@intel.com
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
---


Hi folks, seems the intention was to send this to stable [0], so here it is,
lemme know if you see any issues with that - build tested in 5.10/5.15, also
it has been running for a while on Steam Deck's kernel.

Thanks,

Guilherme

[0] https://lore.kernel.org/stable/faa01372-07b0-3438-9305-123a3de9cc47@intel.com/


 drivers/acpi/processor_idle.c | 23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index e5dd87ddc6b3..59781e765e0e 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -536,10 +536,27 @@ static void wait_for_freeze(void)
 	/* No delay is needed if we are in guest */
 	if (boot_cpu_has(X86_FEATURE_HYPERVISOR))
 		return;
+	/*
+	 * Modern (>=Nehalem) Intel systems use ACPI via intel_idle,
+	 * not this code.  Assume that any Intel systems using this
+	 * are ancient and may need the dummy wait.  This also assumes
+	 * that the motivating chipset issue was Intel-only.
+	 */
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return;
 #endif
-	/* Dummy wait op - must do something useless after P_LVL2 read
-	   because chipsets cannot guarantee that STPCLK# signal
-	   gets asserted in time to freeze execution properly. */
+	/*
+	 * Dummy wait op - must do something useless after P_LVL2 read
+	 * because chipsets cannot guarantee that STPCLK# signal gets
+	 * asserted in time to freeze execution properly
+	 *
+	 * This workaround has been in place since the original ACPI
+	 * implementation was merged, circa 2002.
+	 *
+	 * If a profile is pointing to this instruction, please first
+	 * consider moving your system to a more modern idle
+	 * mechanism.
+	 */
 	inl(acpi_gbl_FADT.xpm_timer_block.address);
 }
 
-- 
2.39.0

