Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD9B492E1F
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 20:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348598AbiARTGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 14:06:36 -0500
Received: from mga12.intel.com ([192.55.52.136]:45353 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245012AbiARTGg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Jan 2022 14:06:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642532796; x=1674068796;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=lylUA7KrDBU6TXS+EOq/kn26y7wWjzEb7smYRb/zZb0=;
  b=UVW/SL0PqDk2hgVWRnqKqCtAh3yLctV8ekLrxW8eJlfFyGfQZTGFTPG/
   tyyhTKG0ZT7DERNIrKOTYDWPZmTLSLQ4VjpwzG1TZuSzh5315rJk/xPyN
   zv9f1VsazxJ385etXlO/yM+KxBnSLvqjrOAWOA5uKhF7VOUvHsxrrrw8a
   Ki5B92EnHnBT+7EhF2+0Wdj+Gu6COZRk05+c8FNptlP1lbBr7cy8E26IB
   tSv3ctvlvxmGfuVD3zDzvM9kSXlDhud3itCknlZSCe4VSx4ceyBpPW2og
   lC+ucmZ4aMHrl2eywvvYRiG4v2VH5K3E1KFUID4TgW9K1ZJZpC8ekgVsz
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10230"; a="224869521"
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="224869521"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 11:05:59 -0800
X-IronPort-AV: E=Sophos;i="5.88,297,1635231600"; 
   d="scan'208";a="477092391"
Received: from ftaylor1-mobl.amr.corp.intel.com (HELO ldmartin-desk2) ([10.212.190.69])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2022 11:05:58 -0800
Date:   Tue, 18 Jan 2022 11:05:58 -0800
From:   Lucas De Marchi <lucas.demarchi@intel.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     x86@kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        intel-gfx@lists.freedesktop.org,
        Ville =?utf-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH v5 1/5] x86/quirks: Fix stolen detection with integrated
 + discrete GPU
Message-ID: <20220118190558.2ququ4vdfjuahicm@ldmartin-desk2>
References: <20220114002843.2083382-1-lucas.demarchi@intel.com>
 <YeaLIs9t0jhovC28@zn.tnic>
 <20220118163656.fzzkwubgoe5gz36k@ldmartin-desk2>
 <Yeb4WKOFNDNbx6tH@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Yeb4WKOFNDNbx6tH@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 06:26:48PM +0100, Borislav Petkov wrote:
>On Tue, Jan 18, 2022 at 08:36:56AM -0800, Lucas De Marchi wrote:
>> I had the impression the subject/title should be imperative, with it
>> more relaxed in the body. It seems we have one more difference among
>> subsystems and I will adapt on next submissions to x86.
>
>We have written it down properly, in case it explains it better:
>
>"The tip tree maintainers set value on following these rules, especially
>on the request to write changelogs in imperative mood and not
>impersonating code or the execution of it. This is not just a whim of
>the maintainers. Changelogs written in abstract words are more precise
>and tend to be less confusing than those written in the form of novels."
>
>from Documentation/process/maintainer-tip.rst

nice, thanks. I had missed this. It certainly makes it easier to adapt
the style when crossing subystems

>> > So I wonder: why can't you simply pass in a static struct chipset *
>> > pointer into the early_qrk[i].f function and in there you can set
>> > QFLAG_APPLIED or so, so that you can mark that the quirk is applied by
>> > using the nice, per-quirk flags someone has already added instead of
>> > this ugly static variable?
>>
>> It seems you prefer v1. See 20211218061313.100571-1-lucas.demarchi@intel.com
>
>I do?
>
>I don't see there:
>
>	early_qrk[i].f(&early_qrk[i], num, slot, func)
>
>so that the ->f callback can set the flags. Or at least the flags passed
>in.

Indeed not exactly the same. In v1 we have

	applied = early_qrk[i].f(num, slot, func);

because I was trying to keep the logic that uses and the one that checks
the value in the same place. With your suggestion the logic to set the
flag would need to move to the called functions, while checking for the
flag would continue to be in the caller.

>If it is not clear what I mean, pls say so and I'll try to produce an
>example diff ontop.
>
>> Although in the review Bjorn suggested just splitting the commit, it was
>> also mentioned that the PCI subsystem has no such logic in its
>> equivalent pci_do_fixups(): a quirk/fixup needing that should instead
>> use a static local.
>
>Why?

I think to make it similar how the PCI fixups work. Anyway, do you
prefer that I change the QFLAG_APPLY_ONCE as above (including
nvidia_bugs() and ati_bugs()) or a very minimal fix like below and
nothing else?

------8<------
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 391a4e2b8604..7b2a3230c42a 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -591,6 +591,13 @@ static void __init intel_graphics_quirks(int num, int slot, int func)
  	u16 device;
  	int i;
  
+	/*
+	 * Already reserved for integrated graphics, nothing to do for other
+	 * (discrete) cards.
+	 */
+	if (resource_size(&intel_graphics_stolen_res))
+		return;
+
  	device = read_pci_config_16(num, slot, func, PCI_DEVICE_ID);
  
  	for (i = 0; i < ARRAY_SIZE(intel_early_ids); i++) {
@@ -703,7 +710,7 @@ static struct chipset early_qrk[] __initdata = {
  	{ PCI_VENDOR_ID_INTEL, 0x3406, PCI_CLASS_BRIDGE_HOST,
  	  PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
  	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA, PCI_ANY_ID,
-	  QFLAG_APPLY_ONCE, intel_graphics_quirks },
+	  0, intel_graphics_quirks },
  	/*
  	 * HPET on the current version of the Baytrail platform has accuracy
  	 * problems: it will halt in deep idle state - so we disable it.
------8<------


thanks
Lucas De Marchi
