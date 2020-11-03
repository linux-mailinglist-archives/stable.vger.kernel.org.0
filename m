Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7512A5442
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:10:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732698AbgKCVJb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:09:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:49526 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731133AbgKCVJ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:09:29 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6A16206B5;
        Tue,  3 Nov 2020 21:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437768;
        bh=RVWkpqy3sTuwBhVP6+LuINdp5SmKD7OFIxV0YedDOLY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YNP7YjPD+yMEnjti756dIiznO/J7w4hXsQasrhIvPfAQQscSwBUrjxwX0BwspQGc4
         kSJ+HLPWBj5+Qij3DJIa0QNDXeIFE+F2+g3nSMRpNpIzuAnPStcSlTXW9ixEzSCywS
         E2VpAOS+wTC83wEfDYMODGk8HNEQ74rBV8/KRzdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 4.14 008/125] x86/xen: disable Firmware First mode for correctable memory errors
Date:   Tue,  3 Nov 2020 21:36:25 +0100
Message-Id: <20201103203157.981525726@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit d759af38572f97321112a0852353613d18126038 upstream.

When running as Xen dom0 the kernel isn't responsible for selecting the
error handling mode, this should be handled by the hypervisor.

So disable setting FF mode when running as Xen pv guest. Not doing so
might result in boot splats like:

[    7.509696] HEST: Enabling Firmware First mode for corrected errors.
[    7.510382] mce: [Firmware Bug]: Ignoring request to disable invalid MCA bank 2.
[    7.510383] mce: [Firmware Bug]: Ignoring request to disable invalid MCA bank 3.
[    7.510384] mce: [Firmware Bug]: Ignoring request to disable invalid MCA bank 4.
[    7.510384] mce: [Firmware Bug]: Ignoring request to disable invalid MCA bank 5.
[    7.510385] mce: [Firmware Bug]: Ignoring request to disable invalid MCA bank 6.
[    7.510386] mce: [Firmware Bug]: Ignoring request to disable invalid MCA bank 7.
[    7.510386] mce: [Firmware Bug]: Ignoring request to disable invalid MCA bank 8.

Reason is that the HEST ACPI table contains the real number of MCA
banks, while the hypervisor is emulating only 2 banks for guests.

Cc: stable@vger.kernel.org
Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: https://lore.kernel.org/r/20200925140751.31381-1-jgross@suse.com
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/enlighten_pv.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1404,6 +1404,15 @@ asmlinkage __visible void __init xen_sta
 		x86_init.mpparse.get_smp_config = x86_init_uint_noop;
 
 		xen_boot_params_init_edd();
+
+#ifdef CONFIG_ACPI
+		/*
+		 * Disable selecting "Firmware First mode" for correctable
+		 * memory errors, as this is the duty of the hypervisor to
+		 * decide.
+		 */
+		acpi_disable_cmcff = 1;
+#endif
 	}
 #ifdef CONFIG_PCI
 	/* PCI BIOS service won't work from a PV guest. */


