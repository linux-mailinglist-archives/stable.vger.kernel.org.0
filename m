Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7098A2A16EE
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727535AbgJaLm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:42:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbgJaLm1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:42:27 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AA8C3206D5;
        Sat, 31 Oct 2020 11:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144546;
        bh=eJDktrvKI8qT0vagGSIcpAQdmUXyl6LAT0/9MD0Egvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKb1pyNstIqpZzx/N81hhM7r1TYNcbThTrZIBNOU0qbsoqTwoFDjgHkZR1g1U39q8
         IqzXQwiX0Go8R+pW3J3gQFHsKJdW9B12STuozSKjT3qESkGHY/mOlkN2qTksEm2r43
         qlKe6f6flSgsC7a3sa/GId2YhfyE5lvsndw/Umtc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 5.8 52/70] x86/xen: disable Firmware First mode for correctable memory errors
Date:   Sat, 31 Oct 2020 12:36:24 +0100
Message-Id: <20201031113501.992244598@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
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
@@ -1438,6 +1438,15 @@ asmlinkage __visible void __init xen_sta
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


