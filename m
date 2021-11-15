Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B6DB4512B9
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347238AbhKOTjK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:39:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244991AbhKOTST (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AD09634E8;
        Mon, 15 Nov 2021 18:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000787;
        bh=Dhp3BJ2GwnWDqF5Y9kUk8zMGnF7gZgqJ0rp8i4g7Vo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JBvyKlySAu4kvd+1XYBoGhVeLAzZxL7fKXWCvTO01du16BcsD+41qB5x2jWZLMQ5B
         6ra7UmUZ72/VNci4EVwC70C68SjSJwauxK/jSzxqlIML1iqGWcylFeWz+XywveiBhV
         tG8dCI/SU0tq2hBtRpxvNueDkMvkCe4497fEDXEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5.14 792/849] x86/mce: Add errata workaround for Skylake SKX37
Date:   Mon, 15 Nov 2021 18:04:35 +0100
Message-Id: <20211115165447.037723800@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jones <davej@codemonkey.org.uk>

commit e629fc1407a63dbb748f828f9814463ffc2a0af0 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/intel.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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


