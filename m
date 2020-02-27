Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1FE171E0C
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388574AbgB0OMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:12:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:50830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388118AbgB0OMJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:12:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFA4820578;
        Thu, 27 Feb 2020 14:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812729;
        bh=dByLz4wxVQiW4fPXs9eq0rPvhSQmGiayskHLEij1fk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KmBAzgG75Cno9AzNBQns2vJuCq54Ft3HvGvM62d5g2g88VXnMAW5Antn46RTkLcFN
         aImaqz8B9yf7SdaRS6gu2VSGFYyadCG4HGmDOUR1DAeSlgp/htwvzpRvrGo/q6vSpL
         uLCk9BRkr0qVIh5CmsjzJ+sCgqxm2s2jVG/aAYF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Juergen Gross <jgross@suse.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: [PATCH 5.4 129/135] xen: Enable interrupts when calling _cond_resched()
Date:   Thu, 27 Feb 2020 14:37:49 +0100
Message-Id: <20200227132248.454437126@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132228.710492098@linuxfoundation.org>
References: <20200227132228.710492098@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 8645e56a4ad6dcbf504872db7f14a2f67db88ef2 upstream.

xen_maybe_preempt_hcall() is called from the exception entry point
xen_do_hypervisor_callback with interrupts disabled.

_cond_resched() evades the might_sleep() check in cond_resched() which
would have caught that and schedule_debug() unfortunately lacks a check
for irqs_disabled().

Enable interrupts around the call and use cond_resched() to catch future
issues.

Fixes: fdfd811ddde3 ("x86/xen: allow privcmd hypercalls to be preempted")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/878skypjrh.fsf@nanos.tec.linutronix.de
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/preempt.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/xen/preempt.c
+++ b/drivers/xen/preempt.c
@@ -33,7 +33,9 @@ asmlinkage __visible void xen_maybe_pree
 		 * cpu.
 		 */
 		__this_cpu_write(xen_in_preemptible_hcall, false);
-		_cond_resched();
+		local_irq_enable();
+		cond_resched();
+		local_irq_disable();
 		__this_cpu_write(xen_in_preemptible_hcall, true);
 	}
 }


