Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 536A3201138
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404860AbgFSPid (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:38:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:33054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404623AbgFSP31 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:29:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2E1D20734;
        Fri, 19 Jun 2020 15:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580566;
        bh=v0Zd5Rs0YH8uIevjCSBDYRBNv85ywamxvHaq+t/dqNU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B31QJQv92jsngK3uv11RsERssONZaVWEzK4v3Ki+MPLWzQtEgYjNANX7+0ZpGKV7d
         VGeWhq5a8Hf+TlRSGDX2OGU94WG9ztZTdHKTePUaKWbt44Rv+QY45+1YcflgkIAOag
         IgHXRt5GHFVfhtLKax3JvfYMCJxreY/pyU7B0gIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.7 298/376] clocksource: Remove obsolete ifdef
Date:   Fri, 19 Jun 2020 16:33:36 +0200
Message-Id: <20200619141724.446789613@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit c7f3d43b629b598a2bb9ec3524e844eae7492e7e upstream.

CONFIG_GENERIC_VDSO_CLOCK_MODE was a transitional config switch which got
removed after all architectures got converted to the new storage model.

But the removal forgot to remove the #ifdef which guards the
vdso_clock_mode sanity check, which effectively disables the sanity check.

Remove it now.

Fixes: f86fd32db706 ("lib/vdso: Cleanup clock mode storage leftovers")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20200606221531.845475036@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/time/clocksource.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -928,14 +928,12 @@ int __clocksource_register_scale(struct
 
 	clocksource_arch_init(cs);
 
-#ifdef CONFIG_GENERIC_VDSO_CLOCK_MODE
 	if (cs->vdso_clock_mode < 0 ||
 	    cs->vdso_clock_mode >= VDSO_CLOCKMODE_MAX) {
 		pr_warn("clocksource %s registered with invalid VDSO mode %d. Disabling VDSO support.\n",
 			cs->name, cs->vdso_clock_mode);
 		cs->vdso_clock_mode = VDSO_CLOCKMODE_NONE;
 	}
-#endif
 
 	/* Initialize mult/shift and max_idle_ns */
 	__clocksource_update_freq_scale(cs, scale, freq);


