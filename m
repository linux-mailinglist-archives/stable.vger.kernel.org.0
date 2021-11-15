Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 579264514BC
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349466AbhKOUMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:12:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344928AbhKOTZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C9B7636F4;
        Mon, 15 Nov 2021 19:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003215;
        bh=Dhp3BJ2GwnWDqF5Y9kUk8zMGnF7gZgqJ0rp8i4g7Vo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0M/wellzBubMxjUaU9KI0/Tug19Tw/ld21Ge2uUI0vtmnViPJ/YjpXzlpwow0NB8x
         04JXprV0UzdY3/sDMNEhfmci93PucPd46KL0z8sh0a+iNx5K1Bi7ovH/KQZ/Posy7Y
         eIUWr2a39Qwy8YyHsJJQ2wSDG+HZLSM7OfYbKMQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dave Jones <davej@codemonkey.org.uk>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5.15 854/917] x86/mce: Add errata workaround for Skylake SKX37
Date:   Mon, 15 Nov 2021 18:05:49 +0100
Message-Id: <20211115165457.988036808@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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


