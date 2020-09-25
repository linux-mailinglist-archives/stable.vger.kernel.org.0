Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B59C42784C7
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 12:11:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgIYKLx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 06:11:53 -0400
Received: from mx2.suse.de ([195.135.220.15]:54670 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727132AbgIYKLx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 06:11:53 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601028711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NG0OrJgM5uOXfafgj6N9/hIxz/Mxn1NzqyKKMmujJRs=;
        b=k6k9NIWYGUGqjHrkfCWCI0YCOS3zb/9xVYikaeqvqaNL9IdDiu4yiys1lKPv0F8vsItlaG
        RjsujkDUKUOtYVHkr0ofyuZ2UBrbHPj5JnE8M1eCpKBEll0msGPImE0l251H2GLzahDTgl
        QcPuY+dskEla5387e8iQgzprAvBnOa8=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id C0B23ACBA;
        Fri, 25 Sep 2020 10:11:51 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: [PATCH] x86/xen: disable Firmware First mode for correctable memory errors
Date:   Fri, 25 Sep 2020 12:11:48 +0200
Message-Id: <20200925101148.21012-1-jgross@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 arch/x86/xen/enlighten_pv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 22e741e0b10c..065c049d0f3c 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1296,6 +1296,14 @@ asmlinkage __visible void __init xen_start_kernel(void)
 
 	xen_smp_init();
 
+#ifdef CONFIG_ACPI
+	/*
+	 * Disable selecting "Firmware First mode" for correctable memory
+	 * errors, as this is the duty of the hypervisor to decide.
+	 */
+	acpi_disable_cmcff = 1;
+#endif
+
 #ifdef CONFIG_ACPI_NUMA
 	/*
 	 * The pages we from Xen are not related to machine pages, so
-- 
2.26.2

