Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA30912282A
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 11:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfLQKB1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Dec 2019 05:01:27 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:54869 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726700AbfLQKB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Dec 2019 05:01:26 -0500
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1ih9fB-0003qg-C1; Tue, 17 Dec 2019 11:01:09 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 117C31C2A2F;
        Tue, 17 Dec 2019 11:01:09 +0100 (CET)
Date:   Tue, 17 Dec 2019 10:01:08 -0000
From:   "tip-bot2 for Yazen Ghannam" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: ras/urgent] x86/MCE/AMD: Allow Reserved types to be overwritten
 in smca_banks[]
Cc:     Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>,
        "linux-edac" <linux-edac@vger.kernel.org>,
        <stable@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, "x86-ml" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20191121141508.141273-1-Yazen.Ghannam@amd.com>
References: <20191121141508.141273-1-Yazen.Ghannam@amd.com>
MIME-Version: 1.0
Message-ID: <157657686895.30329.6754435599070659049.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the ras/urgent branch of tip:

Commit-ID:     966af20929ac24360ba3fac5533eb2ab003747da
Gitweb:        https://git.kernel.org/tip/966af20929ac24360ba3fac5533eb2ab003747da
Author:        Yazen Ghannam <yazen.ghannam@amd.com>
AuthorDate:    Thu, 21 Nov 2019 08:15:08 -06:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Tue, 17 Dec 2019 09:39:53 +01:00

x86/MCE/AMD: Allow Reserved types to be overwritten in smca_banks[]

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
---
 arch/x86/kernel/cpu/mce/amd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index e41e3b4..d6cf5c1 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -266,7 +266,7 @@ static void smca_configure(unsigned int bank, unsigned int cpu)
 	smca_set_misc_banks_map(bank, cpu);
 
 	/* Return early if this bank was already initialized. */
-	if (smca_banks[bank].hwid)
+	if (smca_banks[bank].hwid && smca_banks[bank].hwid->hwid_mcatype != 0)
 		return;
 
 	if (rdmsr_safe(MSR_AMD64_SMCA_MCx_IPID(bank), &low, &high)) {
