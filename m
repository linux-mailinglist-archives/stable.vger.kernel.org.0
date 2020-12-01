Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6230F2C9C2D
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390448AbgLAJPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:15:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:54084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390443AbgLAJPQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:15:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F3B620656;
        Tue,  1 Dec 2020 09:14:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606814075;
        bh=1uaD0cjVTc0yfXt0xJqIVsB+2NUgvutpUbrpETVOIcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1PTznhSzNr2VC03go1GCjDQ5ZSV1VA6IeK1nxb6CZEjW8yZsFv3HxASGHHl9MAbn
         iNAMnB5MEhabroWMwnR1BV+1YROU4wI6XzXQ6AWHUSkoC2+ZnUugIJUS6K4lac2xkd
         lAWpMmyVJB0rTh7L+EK5elffAQbGixVmtz1sT6MM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Gabriele Paoloni <gabriele.paoloni@intel.com>,
        Borislav Petkov <bp@suse.de>, Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5.9 148/152] x86/mce: Do not overwrite no_way_out if mce_end() fails
Date:   Tue,  1 Dec 2020 09:54:23 +0100
Message-Id: <20201201084731.240832074@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
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
@@ -1363,8 +1363,10 @@ noinstr void do_machine_check(struct pt_
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


