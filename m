Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814CB6895E7
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233464AbjBCKYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:24:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbjBCKXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:23:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11129EE27
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:23:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BC32B82A68
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:23:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B439C433D2;
        Fri,  3 Feb 2023 10:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419807;
        bh=8JDGmsW+EDZdp4zJlrpTtfRQzLAL6ptwiShdtutgHTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pXWRJTmz1qV/5v/EMSZEDuiqMM3cmYcMIHtBv+OiwB7LnANpQWy+5hhcOQZEnu5V6
         hFZ6a8EUcr3O9UcEm7II9o1Q6vX9TC87VzKcEtaNuBbkHpfX3oHbUYBPdjidtNy5IZ
         2sL0FrLDYrgfcT3vZii/Eg302/mzkAICLYNY4KLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, K Prateek Nayak <kprateek.nayak@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Subject: [PATCH 5.10 7/9] ACPI: processor idle: Practically limit "Dummy wait" workaround to old Intel systems
Date:   Fri,  3 Feb 2023 11:13:36 +0100
Message-Id: <20230203101006.716757022@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101006.422534094@linuxfoundation.org>
References: <20230203101006.422534094@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_idle.c |   23 ++++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

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
 


