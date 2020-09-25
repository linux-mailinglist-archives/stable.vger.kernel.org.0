Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768AB278A58
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 16:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgIYOHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 10:07:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:57436 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbgIYOHz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 10:07:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601042873;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0bb+VXJKXkSVXRXN2wKoX5N5IGTNG4/vY2hQ3WdHPGU=;
        b=H77nb9nX7Qdrnb3iOVjCM9C8IVwWrAAIuFH1DoigveWlnZ4h7SeOrwfJZFjEEJhbrxwber
        y5jPfft4BcbP02YB9F+c/pMRaqdzOF/1JG8x/+DgH64b5tauF2YN22y/kS8iXdRj0gt0V7
        O3r4xW2P0fzvI+ftL48ZVrU3d5shVgY=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6D7CEAB9F;
        Fri, 25 Sep 2020 14:07:53 +0000 (UTC)
From:   Juergen Gross <jgross@suse.com>
To:     xen-devel@lists.xenproject.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, stable@vger.kernel.org
Subject: [PATCH v2] x86/xen: disable Firmware First mode for correctable memory errors
Date:   Fri, 25 Sep 2020 16:07:51 +0200
Message-Id: <20200925140751.31381-1-jgross@suse.com>
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
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
---
 arch/x86/xen/enlighten_pv.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 22e741e0b10c..351ac1a9a119 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -1376,6 +1376,15 @@ asmlinkage __visible void __init xen_start_kernel(void)
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
 
 	if (!boot_params.screen_info.orig_video_isVGA)
-- 
2.26.2

