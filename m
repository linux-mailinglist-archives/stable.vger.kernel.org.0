Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA03D411EDE
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348094AbhITRfr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:35:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347948AbhITRdy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:33:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4C8CC6152B;
        Mon, 20 Sep 2021 17:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157526;
        bh=ScMyRx5hzzycEeIp806gQ990mz42kGL2xozFShREGxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mRG8QgWA9Wn8JYbMf/7snK/PO2B9SXB/X5knp1ZE0izRT7IkFz8EJPImNuEpSKUFn
         SxFSl70byJTze5riAyxzVThVepU4/7wVxwGnmEt0amaWrHiIrxJdZTLS33rLZuQMQt
         QB2srDjnZyPGjmcWJOyptImkN5MvERKp03mKLgW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.19 030/293] x86/reboot: Limit Dell Optiplex 990 quirk to early BIOS versions
Date:   Mon, 20 Sep 2021 18:39:52 +0200
Message-Id: <20210920163934.298999354@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Gortmaker <paul.gortmaker@windriver.com>

commit a729691b541f6e63043beae72e635635abe5dc09 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/reboot.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -388,10 +388,11 @@ static const struct dmi_system_id reboot
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


