Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0895D431B14
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:28:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232223AbhJRNai (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:30:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232221AbhJRN3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:29:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4297361350;
        Mon, 18 Oct 2021 13:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563650;
        bh=QSXOblMFYWaPrHw9SU69z3qx5eRIYCK1adDIjf4a6c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l33Ditht/5+gGsxJyUYRgg666MhoyCVs6areds/m4miiXaZcwwXEm+RUw9QPeW3eo
         3PSv75vUhqXlcdK9+lE1SZ4Xt1GCbELj+rLIjvN5mcBDPsxrL5mq2nfxTZwvQXog/U
         anu+8sfSm4hf/SrMNuDp6HO1ImxIUb8obkDjkTVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Borislav Petkov <bp@suse.de>,
        Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4.19 10/50] x86/resctrl: Free the ctrlval arrays when domain_setup_mon_state() fails
Date:   Mon, 18 Oct 2021 15:24:17 +0200
Message-Id: <20211018132326.873204233@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132326.529486647@linuxfoundation.org>
References: <20211018132326.529486647@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: James Morse <james.morse@arm.com>

commit 64e87d4bd3201bf8a4685083ee4daf5c0d001452 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/x86/kernel/cpu/intel_rdt.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/kernel/cpu/intel_rdt.c
+++ b/arch/x86/kernel/cpu/intel_rdt.c
@@ -563,6 +563,8 @@ static void domain_add_cpu(int cpu, stru
 	}
 
 	if (r->mon_capable && domain_setup_mon_state(r, d)) {
+		kfree(d->ctrl_val);
+		kfree(d->mbps_val);
 		kfree(d);
 		return;
 	}


