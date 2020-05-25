Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345911E137E
	for <lists+stable@lfdr.de>; Mon, 25 May 2020 19:41:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388182AbgEYRlv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 May 2020 13:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389348AbgEYRlu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 May 2020 13:41:50 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FCBC061A0E;
        Mon, 25 May 2020 10:41:50 -0700 (PDT)
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jdH6h-0005rA-Gy; Mon, 25 May 2020 19:41:47 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 02E8B1C0087;
        Mon, 25 May 2020 19:41:47 +0200 (CEST)
Date:   Mon, 25 May 2020 17:41:46 -0000
From:   "tip-bot2 for Hill Ma" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/misc] x86/reboot/quirks: Add MacBook6,1 reboot quirk
Cc:     Hill Ma <maahiuzeon@gmail.com>, Borislav Petkov <bp@suse.de>,
        stable@vger.kernel.org, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20200425200641.GA1554@cslab.localdomain>
References: <20200425200641.GA1554@cslab.localdomain>
MIME-Version: 1.0
Message-ID: <159042850682.17951.11521556361108377524.tip-bot2@tip-bot2>
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

The following commit has been merged into the x86/misc branch of tip:

Commit-ID:     140fd4ac78d385e6c8e6a5757585f6c707085f87
Gitweb:        https://git.kernel.org/tip/140fd4ac78d385e6c8e6a5757585f6c707085f87
Author:        Hill Ma <maahiuzeon@gmail.com>
AuthorDate:    Sat, 25 Apr 2020 13:06:41 -07:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Mon, 25 May 2020 18:11:23 +02:00

x86/reboot/quirks: Add MacBook6,1 reboot quirk

On MacBook6,1 reboot would hang unless parameter reboot=pci is added.
Make it automatic.

Signed-off-by: Hill Ma <maahiuzeon@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200425200641.GA1554@cslab.localdomain
---
 arch/x86/kernel/reboot.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 3ca43be..8b8cebf 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -197,6 +197,14 @@ static const struct dmi_system_id reboot_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook5"),
 		},
 	},
+	{	/* Handle problems with rebooting on Apple MacBook6,1 */
+		.callback = set_pci_reboot,
+		.ident = "Apple MacBook6,1",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MacBook6,1"),
+		},
+	},
 	{	/* Handle problems with rebooting on Apple MacBookPro5 */
 		.callback = set_pci_reboot,
 		.ident = "Apple MacBookPro5",
