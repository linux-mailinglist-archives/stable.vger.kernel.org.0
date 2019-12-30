Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E122612D19F
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 16:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727515AbfL3P4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 10:56:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:45680 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727538AbfL3P4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Dec 2019 10:56:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id BF24DAC35;
        Mon, 30 Dec 2019 15:56:37 +0000 (UTC)
Date:   Mon, 30 Dec 2019 16:56:21 +0100
From:   Borislav Petkov <bp@suse.de>
To:     gregkh@linuxfoundation.org
Cc:     jschoenh@amazon.de, Yazen.Ghannam@amd.com, hpa@zytor.com,
        linux-edac@vger.kernel.org, mingo@kernel.org,
        stable@vger.kernel.org, tglx@linutronix.de, tony.luck@intel.com,
        x86@kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/mce: Fix possibly incorrect severity
 calculation on AMD" failed to apply to 4.19-stable tree
Message-ID: <20191230155621.GA30811@zn.tnic>
References: <157763491612458@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <157763491612458@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 29, 2019 at 04:55:16PM +0100, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's a backport for all 4.x stable series. It only needed a
file-rename.

---
From a3a57ddad061acc90bef39635caf2b2330ce8f21 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <jschoenh@amazon.de>
Date: Tue, 10 Dec 2019 01:07:30 +0100
Subject: [PATCH] x86/mce: Fix possibly incorrect severity calculation on AMD
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

commit a3a57ddad061acc90bef39635caf2b2330ce8f21 upstream.

The function mce_severity_amd_smca() requires m->bank to be initialized
for correct operation. Fix the one case, where mce_severity() is called
without doing so.

Fixes: 6bda529ec42e ("x86/mce: Grade uncorrected errors for SMCA-enabled systems")
Fixes: d28af26faa0b ("x86/MCE: Initialize mce.bank in the case of a fatal error in mce_no_way_out()")
Signed-off-by: Jan H. Schönherr <jschoenh@amazon.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Cc: Yazen Ghannam <Yazen.Ghannam@amd.com>
Link: https://lkml.kernel.org/r/20191210000733.17979-4-jschoenh@amazon.de
---
 arch/x86/kernel/cpu/mcheck/mce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 5f42f25bac8f..2e2a421c8528 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -819,8 +819,8 @@ static int mce_no_way_out(struct mce *m, char **msg, unsigned long *validp,
 		if (quirk_no_way_out)
 			quirk_no_way_out(i, m, regs);
 
+		m->bank = i;
 		if (mce_severity(m, mca_cfg.tolerant, &tmp, true) >= MCE_PANIC_SEVERITY) {
-			m->bank = i;
 			mce_read_aux(m, i);
 			*msg = tmp;
 			return 1;
-- 
2.21.0


-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
