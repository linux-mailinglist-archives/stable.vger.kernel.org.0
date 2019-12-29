Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD1D12C900
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387627AbfL2R6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:58:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:50152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387621AbfL2R6v (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:58:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24EB32253D;
        Sun, 29 Dec 2019 17:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642330;
        bh=SXZtoj1N8So8wM9gNNkosrmKnhPrW8PSoe/zswMBiOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fUS2LcbauC8lHEfOOkRKXTV0zBih+U3dhbX3vDklueQBixsooLpfyC9ppwmpV8TIf
         VeMpx/E+Tl76ENu8X7wD+4E+boJ/NUMJkzA8GxWTGHntWbzG2cE9wSd0PLv0XiPIk4
         6CmSTFtE/o+XWgHpWk4n8ruMjjLm0AYVxr+hs0QY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        linux-edac <linux-edac@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, x86-ml <x86@kernel.org>
Subject: [PATCH 5.4 422/434] x86/MCE/AMD: Allow Reserved types to be overwritten in smca_banks[]
Date:   Sun, 29 Dec 2019 18:27:55 +0100
Message-Id: <20191229172731.152674776@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit 966af20929ac24360ba3fac5533eb2ab003747da upstream.

Each logical CPU in Scalable MCA systems controls a unique set of MCA
banks in the system. These banks are not shared between CPUs. The bank
types and ordering will be the same across CPUs on currently available
systems.

However, some CPUs may see a bank as Reserved/Read-as-Zero (RAZ) while
other CPUs do not. In this case, the bank seen as Reserved on one CPU is
assumed to be the same type as the bank seen as a known type on another
CPU.

In general, this occurs when the hardware represented by the MCA bank
is disabled, e.g. disabled memory controllers on certain models, etc.
The MCA bank is disabled in the hardware, so there is no possibility of
getting an MCA/MCE from it even if it is assumed to have a known type.

For example:

Full system:
	Bank  |  Type seen on CPU0  |  Type seen on CPU1
	------------------------------------------------
	 0    |         LS          |          LS
	 1    |         UMC         |          UMC
	 2    |         CS          |          CS

System with hardware disabled:
	Bank  |  Type seen on CPU0  |  Type seen on CPU1
	------------------------------------------------
	 0    |         LS          |          LS
	 1    |         UMC         |          RAZ
	 2    |         CS          |          CS

For this reason, there is a single, global struct smca_banks[] that is
initialized at boot time. This array is initialized on each CPU as it
comes online. However, the array will not be updated if an entry already
exists.

This works as expected when the first CPU (usually CPU0) has all
possible MCA banks enabled. But if the first CPU has a subset, then it
will save a "Reserved" type in smca_banks[]. Successive CPUs will then
not be able to update smca_banks[] even if they encounter a known bank
type.

This may result in unexpected behavior. Depending on the system
configuration, a user may observe issues enumerating the MCA
thresholding sysfs interface. The issues may be as trivial as sysfs
entries not being available, or as severe as system hangs.

For example:

	Bank  |  Type seen on CPU0  |  Type seen on CPU1
	------------------------------------------------
	 0    |         LS          |          LS
	 1    |         RAZ         |          UMC
	 2    |         CS          |          CS

Extend the smca_banks[] entry check to return if the entry is a
non-reserved type. Otherwise, continue so that CPUs that encounter a
known bank type can update smca_banks[].

Fixes: 68627a697c19 ("x86/mce/AMD, EDAC/mce_amd: Enumerate Reserved SMCA bank type")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-edac <linux-edac@vger.kernel.org>
Cc: <stable@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20191121141508.141273-1-Yazen.Ghannam@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mce/amd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -266,7 +266,7 @@ static void smca_configure(unsigned int
 	smca_set_misc_banks_map(bank, cpu);
 
 	/* Return early if this bank was already initialized. */
-	if (smca_banks[bank].hwid)
+	if (smca_banks[bank].hwid && smca_banks[bank].hwid->hwid_mcatype != 0)
 		return;
 
 	if (rdmsr_safe(MSR_AMD64_SMCA_MCx_IPID(bank), &low, &high)) {


