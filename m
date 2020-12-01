Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECDCF2C9D76
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729540AbgLAJXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:23:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:42546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388615AbgLAJGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:06:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 10AAF20671;
        Tue,  1 Dec 2020 09:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813578;
        bh=Z0sBvT0EL6CU55gckHLrogO86kVHb6i9O8ryaExbsL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZ5RFX1qv1ow0kQ/SCZxPk/2tHZFyQKEXO6usgekd2R2/mrPfGoM3EabRTraKUHua
         KxwPHj1QGBNlgk+72pXfdiWQGLR8J3rdhpJ7Pk5PxFlO5ycrwrClkMeD9uPX3V2T03
         DWxlYiBDH9EtHehI3MWxgE5+z0VxB2iWO3slOX0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gabriele Paoloni <gabriele.paoloni@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5.4 86/98] x86/mce: Do not overwrite no_way_out if mce_end() fails
Date:   Tue,  1 Dec 2020 09:54:03 +0100
Message-Id: <20201201084659.257135691@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriele Paoloni <gabriele.paoloni@intel.com>

commit 25bc65d8ddfc17cc1d7a45bd48e9bdc0e729ced3 upstream.

Currently, if mce_end() fails, no_way_out - the variable denoting
whether the machine can recover from this MCE - is determined by whether
the worst severity that was found across the MCA banks associated with
the current CPU, is of panic severity.

However, at this point no_way_out could have been already set by
mca_start() after looking at all severities of all CPUs that entered the
MCE handler. If mce_end() fails, check first if no_way_out is already
set and, if so, stick to it, otherwise use the local worst value.

 [ bp: Massage. ]

Signed-off-by: Gabriele Paoloni <gabriele.paoloni@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201127161819.3106432-2-gabriele.paoloni@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/mce/core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -1361,8 +1361,10 @@ void do_machine_check(struct pt_regs *re
 	 * When there's any problem use only local no_way_out state.
 	 */
 	if (!lmce) {
-		if (mce_end(order) < 0)
-			no_way_out = worst >= MCE_PANIC_SEVERITY;
+		if (mce_end(order) < 0) {
+			if (!no_way_out)
+				no_way_out = worst >= MCE_PANIC_SEVERITY;
+		}
 	} else {
 		/*
 		 * If there was a fatal machine check we should have


