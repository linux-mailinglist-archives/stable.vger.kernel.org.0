Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E487E42C7C7
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 19:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbhJMRks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 13:40:48 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52766 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhJMRks (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 13:40:48 -0400
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E112F20150;
        Wed, 13 Oct 2021 17:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1634146723; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NGdwwLRjz2O7ZfOokv2kBT0waGq1N7XovIIqCf2KGbQ=;
        b=xzAcThPGo3vrosryQQE/ok2WrkQDNhTKpYolLlWGfwDhWB6WbPC2IZ4haO4TeiDCJfMOGK
        YOydXHE1wthfNDQWELvFi7JWCFPgwNqjqPaMJVZVdqwb48OxOARDJGIPUOaItLfOa/EyHi
        Um9QQzUPC8zVqRZowg7E3wQud6b+16A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1634146723;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NGdwwLRjz2O7ZfOokv2kBT0waGq1N7XovIIqCf2KGbQ=;
        b=yQPi76L/vJ4+O72tmgASOwxwDNTxZrO5mVuEV137+A9UZLtECTtRTYPaBn9Az9OHoYqQMQ
        ZCQ1R07izLXtnuCg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A8A2B13D10;
        Wed, 13 Oct 2021 17:38:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id mSx1KKMZZ2GGNAAAMHmgww
        (envelope-from <bp@suse.de>); Wed, 13 Oct 2021 17:38:43 +0000
Date:   Wed, 13 Oct 2021 19:38:41 +0200
From:   Borislav Petkov <bp@suse.de>
To:     gregkh@linuxfoundation.org
Cc:     james.morse@arm.com, reinette.chatre@intel.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/resctrl: Free the ctrlval arrays
 when" failed to apply to 5.14-stable tree
Message-ID: <YWcZoRc37rhOm3iA@zn.tnic>
References: <163393835419833@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <163393835419833@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Oct 11, 2021 at 09:45:54AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From 64e87d4bd3201bf8a4685083ee4daf5c0d001452 Mon Sep 17 00:00:00 2001
> From: James Morse <james.morse@arm.com>
> Date: Fri, 17 Sep 2021 16:59:58 +0000
> Subject: [PATCH] x86/resctrl: Free the ctrlval arrays when
>  domain_setup_mon_state() fails

here's a backport against 5.14. It applies on all except 4.19. That one
needs only a file rename, see second patch below.

---
From: James Morse <james.morse@arm.com>
Date: Fri, 17 Sep 2021 16:59:58 +0000
Subject: [PATCH] x86/resctrl: Free the ctrlval arrays when
 domain_setup_mon_state() fails

Commit 64e87d4bd3201bf8a4685083ee4daf5c0d001452 upstream.

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
---
 arch/x86/kernel/cpu/resctrl/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/resctrl/core.c b/arch/x86/kernel/cpu/resctrl/core.c
index 23001ae03e82..7afc2d72d863 100644
--- a/arch/x86/kernel/cpu/resctrl/core.c
+++ b/arch/x86/kernel/cpu/resctrl/core.c
@@ -590,6 +590,8 @@ static void domain_add_cpu(int cpu, struct rdt_resource *r)
 	}
 
 	if (r->mon_capable && domain_setup_mon_state(r, d)) {
+		kfree(d->ctrl_val);
+		kfree(d->mbps_val);
 		kfree(d);
 		return;
 	}
-- 
2.29.2

---

From: James Morse <james.morse@arm.com>
Date: Fri, 17 Sep 2021 16:59:58 +0000
Subject: [PATCH] x86/resctrl: Free the ctrlval arrays when
 domain_setup_mon_state() fails

Commit 64e87d4bd3201bf8a4685083ee4daf5c0d001452 upstream.

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
---
 arch/x86/kernel/cpu/intel_rdt.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/cpu/intel_rdt.c b/arch/x86/kernel/cpu/intel_rdt.c
index b32fa6bcf811..d4993d42b741 100644
--- a/arch/x86/kernel/cpu/intel_rdt.c
+++ b/arch/x86/kernel/cpu/intel_rdt.c
@@ -563,6 +563,8 @@ static void domain_add_cpu(int cpu, struct rdt_resource *r)
 	}
 
 	if (r->mon_capable && domain_setup_mon_state(r, d)) {
+		kfree(d->ctrl_val);
+		kfree(d->mbps_val);
 		kfree(d);
 		return;
 	}
-- 
2.29.2

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
