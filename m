Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1EBF44EE4C
	for <lists+stable@lfdr.de>; Fri, 12 Nov 2021 22:03:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235694AbhKLVGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Nov 2021 16:06:02 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:58928 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbhKLVGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Nov 2021 16:06:01 -0500
Date:   Fri, 12 Nov 2021 21:03:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636750989;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O0NXfuL+eTLYI6EaXNCoAYISE5pssQLczx2u9g7Yc8Y=;
        b=WXUinH+PGvWA3rxGvx2qAj/+uSTb61/BM9qETnID/toWV4PnIT67g/EsaXtrDSsiadggf3
        mgi4lVL1iU9214HBZdqs93oWov+5LLQrR5CBHcsxEDfHrISnMb1bjkoMakLY+34aFpkAfN
        2bhm+ZstG5kKvEnRXm1F7zPira9JjmnAcr1j97uwARcF830g1bhHGc0aCDDTIj7aLDYTnW
        /k3B1mgdUgSDmVy0VMJejgS0IOjyeU+BSAr20cvvy+yH/4SKN3ttjbQkVuor4nranm37pu
        MLTyDDvsQBypOIlSjWBxJBYTdOxqs9QnDnG/FXlW54QPmz4eq7HGDeqA13xpNQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636750989;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O0NXfuL+eTLYI6EaXNCoAYISE5pssQLczx2u9g7Yc8Y=;
        b=WYx0N7NsdcWvJYGOoQtEYnrUIO83FfwEzkCtnwN73kMnikCOK+BZcN/dkeTsRlLX00nJDW
        jcZ8ZPjNCJv9tKDg==
From:   "tip-bot2 for Dave Jones" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/mce: Add errata workaround for Skylake SKX37
Cc:     Dave Jones <davej@codemonkey.org.uk>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20211029205759.GA7385@codemonkey.org.uk>
References: <20211029205759.GA7385@codemonkey.org.uk>
MIME-Version: 1.0
Message-ID: <163675098841.414.15295584691020015692.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     e629fc1407a63dbb748f828f9814463ffc2a0af0
Gitweb:        https://git.kernel.org/tip/e629fc1407a63dbb748f828f9814463ffc2a0af0
Author:        Dave Jones <davej@codemonkey.org.uk>
AuthorDate:    Fri, 29 Oct 2021 16:57:59 -04:00
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Fri, 12 Nov 2021 11:43:35 -08:00

x86/mce: Add errata workaround for Skylake SKX37

Errata SKX37 is word-for-word identical to the other errata listed in
this workaround.   I happened to notice this after investigating a CMCI
storm on a Skylake host.  While I can't confirm this was the root cause,
spurious corrected errors does sound like a likely suspect.

Fixes: 2976908e4198 ("x86/mce: Do not log spurious corrected mce errors")
Signed-off-by: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20211029205759.GA7385@codemonkey.org.uk
---
 arch/x86/kernel/cpu/mce/intel.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mce/intel.c b/arch/x86/kernel/cpu/mce/intel.c
index acfd5d9..bb9a46a 100644
--- a/arch/x86/kernel/cpu/mce/intel.c
+++ b/arch/x86/kernel/cpu/mce/intel.c
@@ -547,12 +547,13 @@ bool intel_filter_mce(struct mce *m)
 {
 	struct cpuinfo_x86 *c = &boot_cpu_data;
 
-	/* MCE errata HSD131, HSM142, HSW131, BDM48, and HSM142 */
+	/* MCE errata HSD131, HSM142, HSW131, BDM48, HSM142 and SKX37 */
 	if ((c->x86 == 6) &&
 	    ((c->x86_model == INTEL_FAM6_HASWELL) ||
 	     (c->x86_model == INTEL_FAM6_HASWELL_L) ||
 	     (c->x86_model == INTEL_FAM6_BROADWELL) ||
-	     (c->x86_model == INTEL_FAM6_HASWELL_G)) &&
+	     (c->x86_model == INTEL_FAM6_HASWELL_G) ||
+	     (c->x86_model == INTEL_FAM6_SKYLAKE_X)) &&
 	    (m->bank == 0) &&
 	    ((m->status & 0xa0000000ffffffff) == 0x80000000000f0005))
 		return true;
