Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4124C887A
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 10:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbiCAJro (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 04:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233903AbiCAJrh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 04:47:37 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 579268C7CD;
        Tue,  1 Mar 2022 01:46:53 -0800 (PST)
Received: from integral2.. (unknown [182.2.70.248])
        by gnuweeb.org (Postfix) with ESMTPSA id 284457ED80;
        Tue,  1 Mar 2022 09:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646128012;
        bh=j98NA/icKc1vIKoEwnqpn4Du2N9NevWPX/k0GkOdjAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fm5AOB6qvULrfkk5Xz+tfEN27TFtT2xY2zQScl9ibHQTSJXY3u0R6VgJuLevnXhh3
         dw027FYdZ1dRhgPbsTkhjuvnELrSjCPWEOvDmte6ZpF7J/KcgGaP9WGdzVWN8x433s
         lQRwhhfXNBpohckavPsAhFPfeIYHuqctJwB7RVjKNWw6IiQY36qGmEM2QpudJgAoNz
         lI4oQ5dMwv7Q8vjs9ZZvngYqbdcyQiv1VrcS0i07+oE8e7zbFP/X6qd+iMYPve/0Pg
         2/4Poa3lHEvPJVRAKh/s4DbO2Uo5Qre0viSbf0R4o1mUy35oAAQKs8WDvry8HVDyqo
         Kd82nPyya9FjQ==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, gwml@vger.gnuweeb.org,
        x86@kernel.org, stable@vger.kernel.org,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Jiri Hladky <hladky.jiri@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v4 2/2] x86/mce/amd: Fix memory leak when `threshold_create_bank()` fails
Date:   Tue,  1 Mar 2022 16:46:08 +0700
Message-Id: <20220301094608.118879-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org>
References: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

@bp is a local variable, calling mce_threshold_remove_device() when
threshold_create_bank() fails will not free the @bp. Note that
mce_threshold_remove_device() frees the @bp only if it's already
stored in the @threshold_banks per-CPU variable.

At that point, the @threshold_banks per-CPU variable is still NULL,
so the mce_threshold_remove_device() will just be a no-op and the
@bp is leaked.

Fix this by storing @bp to @threshold_banks before the loop, so in
case we fail, mce_threshold_remove_device() will free the @bp.

This bug is introduced by commit 6458de97fc15530b544 ("x86/mce/amd:
Straighten CPU hotplug path") [1].

Link: https://lore.kernel.org/all/20200403161943.1458-6-bp@alien8.de [1]

v4:
  - Add the link to the commit reference again.

v3:
  - Fold in changes from Alviro, the previous version is still
    leaking @bank[n].

v2:
  - No changes.

Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: stable@vger.kernel.org # v5.8+
Fixes: 6458de97fc15 ("x86/mce/amd: Straighten CPU hotplug path")
Co-authored-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 arch/x86/kernel/cpu/mce/amd.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index 9f4b508886dd..a5ef161facd9 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -1346,19 +1346,23 @@ int mce_threshold_create_device(unsigned int cpu)
 	if (!bp)
 		return -ENOMEM;
 
+	/*
+	 * If we fail, mce_threshold_remove_device() will free the @bp
+	 * via @threshold_banks.
+	 */
+	this_cpu_write(threshold_banks, bp);
+
 	for (bank = 0; bank < numbanks; ++bank) {
 		if (!(this_cpu_read(bank_map) & (1 << bank)))
 			continue;
 		err = threshold_create_bank(bp, cpu, bank);
-		if (err)
-			goto out_err;
+		if (err) {
+			mce_threshold_remove_device(cpu);
+			return err;
+		}
 	}
-	this_cpu_write(threshold_banks, bp);
 
 	if (thresholding_irq_en)
 		mce_threshold_vector = amd_threshold_interrupt;
 	return 0;
-out_err:
-	mce_threshold_remove_device(cpu);
-	return err;
 }
-- 
2.32.0

