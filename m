Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4F2B428805
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 09:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbhJKHr6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 03:47:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234494AbhJKHr5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 03:47:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 392B960184;
        Mon, 11 Oct 2021 07:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633938357;
        bh=3SOme+N9yN9yTzPG4kWTGaP4Nb+yWZIthhsDtA95K1g=;
        h=Subject:To:Cc:From:Date:From;
        b=r4q2Fj2VBzn2TYu0xDia0LLA2I9Jj5vTCIsjZI2Pwl7Mj23VLwCEybOBqMLaJGUDg
         wu3E7hxpckz4swzOaYsW3YC25nA8Q6u9cu/z+Br0BdykRNSrFaQTPw7LkJwWyYE+qq
         IJEF5h7vQVCVEUvS7OI4xQRgq/ND+qr6D/iFiB/U=
Subject: FAILED: patch "[PATCH] x86/resctrl: Free the ctrlval arrays when" failed to apply to 5.14-stable tree
To:     james.morse@arm.com, bp@suse.de, reinette.chatre@intel.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Oct 2021 09:45:54 +0200
Message-ID: <163393835419833@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 64e87d4bd3201bf8a4685083ee4daf5c0d001452 Mon Sep 17 00:00:00 2001
From: James Morse <james.morse@arm.com>
Date: Fri, 17 Sep 2021 16:59:58 +0000
Subject: [PATCH] x86/resctrl: Free the ctrlval arrays when
 domain_setup_mon_state() fails

domain_add_cpu() is called whenever a CPU is brought online. The
earlier call to domain_setup_ctrlval() allocates the control value
arrays.

If domain_setup_mon_state() fails, the control value arrays are not
freed.

Add the missing kfree() calls.

Fixes: 1bd2a63b4f0de ("x86/intel_rdt/mba_sc: Add initialization support")
Fixes: edf6fa1c4a951 ("x86/intel_rdt/cqm: Add RMID (Resource monitoring ID) management")
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Reinette Chatre <reinette.chatre@intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20210917165958.28313-1-james.morse@arm.com

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 4b8813bafffd..b5de5a6c115c 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -532,6 +532,8 @@ static void domain_add_cpu(int cpu, struct rdt_resource *r)
 	}
 
 	if (r->mon_capable && domain_setup_mon_state(r, d)) {
+		kfree(hw_dom->ctrl_val);
+		kfree(hw_dom->mbps_val);
 		kfree(d);
 		return;
 	}

