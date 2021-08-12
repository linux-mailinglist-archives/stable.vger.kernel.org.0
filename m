Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577BC3EA2CE
	for <lists+stable@lfdr.de>; Thu, 12 Aug 2021 12:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236008AbhHLKKW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Aug 2021 06:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236173AbhHLKKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Aug 2021 06:10:16 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574DDC061799;
        Thu, 12 Aug 2021 03:09:45 -0700 (PDT)
Date:   Thu, 12 Aug 2021 10:09:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1628762983;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MIc2D9bxHOWfX49qYEC3q6JpMD8s1z/PNmyXUyrZx/k=;
        b=tuxjEWbiKVvygZpdPtxSGMZixBErPBb93btDGIPuqUwzJQTUMlKOsPi5jYUKxuiVH3SYOF
        1SGaI2aGRPFG++pjIZSfqaqZ8svbN41KGwR3QiiFd5uubINsY0NT9DY2ZDgZH7EMDGZkvV
        LHcEECzTAy3uYA97tP6q210NDhqHBnPTBh3sjOzN89MBCtgQlpinmJvztzopPLkjdHuzI5
        5Kl2xv9oZOzA1OL/xsJVUrIu+u9OzSefYvTBSZekP0RoBpiSTcDDC29yzJzN01qrdv8pAu
        FXC64Ir8PUE0kHMSk0n4Cn4jJWeIH5ZbHxNOhXNozJ814TTCcWU5Q+sEDXknvg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1628762983;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MIc2D9bxHOWfX49qYEC3q6JpMD8s1z/PNmyXUyrZx/k=;
        b=9PvtLAPEDYkzr1bZpfsrf5ak7qKJ/bB+RaFdDbqJCfHf1w9Dxb0g6gckkxC7XvuiVe5kz5
        ng4Ts5mi+K9mW/Dw==
From:   "tip-bot2 for Paul Gortmaker" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/misc] x86/reboot: Limit Dell Optiplex 990 quirk to early
 BIOS versions
Cc:     Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210530162447.996461-4-paul.gortmaker@windriver.com>
References: <20210530162447.996461-4-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Message-ID: <162876298213.395.8927635127005087509.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/misc branch of tip:

Commit-ID:     a729691b541f6e63043beae72e635635abe5dc09
Gitweb:        https://git.kernel.org/tip/a729691b541f6e63043beae72e635635abe5dc09
Author:        Paul Gortmaker <paul.gortmaker@windriver.com>
AuthorDate:    Sun, 30 May 2021 12:24:47 -04:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 12 Aug 2021 12:06:58 +02:00

x86/reboot: Limit Dell Optiplex 990 quirk to early BIOS versions

When this platform was relatively new in November 2011, with early BIOS
revisions, a reboot quirk was added in commit 6be30bb7d750 ("x86/reboot:
Blacklist Dell OptiPlex 990 known to require PCI reboot")

However, this quirk (and several others) are open-ended to all BIOS
versions and left no automatic expiry if/when the system BIOS fixed the
issue, meaning that nobody is likely to come along and re-test.

What is really problematic with using PCI reboot as this quirk does, is
that it causes this platform to do a full power down, wait one second,
and then power back on.  This is less than ideal if one is using it for
boot testing and/or bisecting kernels when legacy rotating hard disks
are installed.

It was only by chance that the quirk was noticed in dmesg - and when
disabled it turned out that it wasn't required anymore (BIOS A24), and a
default reboot would work fine without the "harshness" of power cycling the
machine (and disks) down and up like the PCI reboot does.

Doing a bit more research, it seems that the "newest" BIOS for which the
issue was reported[1] was version A06, however Dell[2] seemed to suggest
only up to and including version A05, with the A06 having a large number of
fixes[3] listed.

As is typical with a new platform, the initial BIOS updates come frequently
and then taper off (and in this case, with a revival for CPU CVEs); a
search for O990-A<ver>.exe reveals the following dates:

        A02     16 Mar 2011
        A03     11 May 2011
        A06     14 Sep 2011
        A07     24 Oct 2011
        A10     08 Dec 2011
        A14     06 Sep 2012
        A16     15 Oct 2012
        A18     30 Sep 2013
        A19     23 Sep 2015
        A20     02 Jun 2017
        A23     07 Mar 2018
        A24     21 Aug 2018

While it's overkill to flash and test each of the above, it would seem
likely that the issue was contained within A0x BIOS versions, given the
dates above and the dates of issue reports[4] from distros.  So rather than
just throw out the quirk entirely, limit the scope to just those early BIOS
versions, in case people are still running systems from 2011 with the
original as-shipped early A0x BIOS versions.

[1] https://lore.kernel.org/lkml/1320373471-3942-1-git-send-email-trenn@suse.de/
[2] https://www.dell.com/support/kbdoc/en-ca/000131908/linux-based-operating-systems-stall-upon-reboot-on-optiplex-390-790-990-systems
[3] https://www.dell.com/support/home/en-ca/drivers/driversdetails?driverid=85j10
[4] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/768039

Fixes: 6be30bb7d750 ("x86/reboot: Blacklist Dell OptiPlex 990 known to require PCI reboot")
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210530162447.996461-4-paul.gortmaker@windriver.com

---
 arch/x86/kernel/reboot.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index ebfb911..0a40df6 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -388,10 +388,11 @@ static const struct dmi_system_id reboot_dmi_table[] __initconst = {
 	},
 	{	/* Handle problems with rebooting on the OptiPlex 990. */
 		.callback = set_pci_reboot,
-		.ident = "Dell OptiPlex 990",
+		.ident = "Dell OptiPlex 990 BIOS A0x",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 990"),
+			DMI_MATCH(DMI_BIOS_VERSION, "A0"),
 		},
 	},
 	{	/* Handle problems with rebooting on Dell 300's */
