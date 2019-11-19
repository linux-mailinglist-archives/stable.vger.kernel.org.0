Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11673101314
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727667AbfKSFWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:22:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:37380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727665AbfKSFWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:22:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AA6922323;
        Tue, 19 Nov 2019 05:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140928;
        bh=ybzGN3rDEjv3/bHDGfOK1Y7Dccigcg6BtggoYDuLj0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E0k6gA+atmSWEX6/NHn/5co23WZ3og0bJhAuUBWNyqZ1zpSgK9OAh/00cOWHsTg63
         mTbqIQNQ60UQ04gzKoQrIouPYIJKpBNmJkA1h6wRC/k0koApJOJmUIXblkMizdeeq4
         hOOULMyBI4WEwHxeToJULpHWCTVdON7mE1K8Qlmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.3 33/48] x86/quirks: Disable HPET on Intel Coffe Lake platforms
Date:   Tue, 19 Nov 2019 06:19:53 +0100
Message-Id: <20191119051012.981039261@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit fc5db58539b49351e76f19817ed1102bf7c712d0 upstream.

Some Coffee Lake platforms have a skewed HPET timer once the SoCs entered
PC10, which in consequence marks TSC as unstable because HPET is used as
watchdog clocksource for TSC.

Harry Pan tried to work around it in the clocksource watchdog code [1]
thereby creating a circular dependency between HPET and TSC. This also
ignores the fact, that HPET is not only unsuitable as watchdog clocksource
on these systems, it becomes unusable in general.

Disable HPET on affected platforms.

Suggested-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203183
Link: https://lore.kernel.org/lkml/20190516090651.1396-1-harry.pan@intel.com/ [1]
Link: https://lkml.kernel.org/r/20191016103816.30650-1-kai.heng.feng@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/early-quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -709,6 +709,8 @@ static struct chipset early_qrk[] __init
 	 */
 	{ PCI_VENDOR_ID_INTEL, 0x0f00,
 		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
+	{ PCI_VENDOR_ID_INTEL, 0x3ec4,
+		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
 	{ PCI_VENDOR_ID_BROADCOM, 0x4331,
 	  PCI_CLASS_NETWORK_OTHER, PCI_ANY_ID, 0, apple_airport_reset},
 	{}


