Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA71D101766
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730604AbfKSFoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:44:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728629AbfKSFoW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:44:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 488E12075E;
        Tue, 19 Nov 2019 05:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142261;
        bh=XOZGKUDKELZbuYuJ99nsyJpYiikG2/sMmY+svnf4Fpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/DCgbc4MR3OlDLL//+I04HWUz+qG49tP1j6Bl8wlMQkFuGocIkcLHJ9635n135Uu
         j6i0x+zzn+4EyNOlKOGuI5emvHskfnkBBRG5uG6K8msTpkkKrgsaQAWS3g50EY2X3d
         g4Xm4FXNiRjbDAlgMMlEPY1FfA7LyAfn4s6Knm58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 4.14 021/239] x86/quirks: Disable HPET on Intel Coffe Lake platforms
Date:   Tue, 19 Nov 2019 06:17:01 +0100
Message-Id: <20191119051301.677858088@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
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
@@ -681,6 +681,8 @@ static struct chipset early_qrk[] __init
 	 */
 	{ PCI_VENDOR_ID_INTEL, 0x0f00,
 		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
+	{ PCI_VENDOR_ID_INTEL, 0x3ec4,
+		PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, force_disable_hpet},
 	{ PCI_VENDOR_ID_BROADCOM, 0x4331,
 	  PCI_CLASS_NETWORK_OTHER, PCI_ANY_ID, 0, apple_airport_reset},
 	{}


