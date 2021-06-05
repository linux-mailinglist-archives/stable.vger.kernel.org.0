Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8563139CBE1
	for <lists+stable@lfdr.de>; Sun,  6 Jun 2021 02:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhFFAeP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Jun 2021 20:34:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230150AbhFFAeP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Jun 2021 20:34:15 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB48C061766;
        Sat,  5 Jun 2021 17:32:26 -0700 (PDT)
Message-Id: <20210606001323.429482447@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622939545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=DGkVxXkLnQqzemQn1GsMwh95ap9O1ytCLq2NJcMCb3I=;
        b=TwgOPkvlwEr2+9pco18ou68Nsdr0J21L+C1j7qoV5iywjlMDh0lZEtAvsATfT1Js0NBSFU
        LyX4yh/OfAelTxqLnZrj/tTMk+ts//KsoHaEw1MtCFm5jyrHQ1eKtJ3Kzwd7PnuGlOgNVe
        pkMTD4FrZkbnFaAdR4FZJCZeSkD8lfWQ/CeCPRglNqi5zCb4VO67sJq7VFSUE5LMldDH9I
        BDsrVF0m2do2wi9G2DfAoRbejpI5mhGxJuFkQ8bEOUEw31LLNWiuImPZsmeVRarO4utLgs
        OVFlXjrzb45bv67a6mzF8gCQzif6wBAorYFkUXRXQ3tACHbLMUjaeIgxm1u6yQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622939545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=DGkVxXkLnQqzemQn1GsMwh95ap9O1ytCLq2NJcMCb3I=;
        b=1PbhAnuPBzy6VVitiPdpa/DS6Dyam0MhPQtGE3LEEXUUiJhgY2MDJJL2SUiyBTKGUNZltD
        XmOLDa1/dA3j4JDA==
Date:   Sun, 06 Jun 2021 01:47:47 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        stable@vger.kernel.org
Subject: [patch V2 05/14] x86/fpu: Limit xstate copy size in xstateregs_set()
References: <20210605234742.712464974@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-transfer-encoding: 8-bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the count argument is larger than the xstate size, this will happily
copy beyond the end of xstate.

Fixes: 91c3dba7dbc1 ("x86/fpu/xstate: Fix PTRACE frames for XSAVES")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
---
 arch/x86/kernel/fpu/regset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/fpu/regset.c
+++ b/arch/x86/kernel/fpu/regset.c
@@ -117,7 +117,7 @@ int xstateregs_set(struct task_struct *t
 	/*
 	 * A whole standard-format XSAVE buffer is needed:
 	 */
-	if ((pos != 0) || (count < fpu_user_xstate_size))
+	if (pos != 0 || count != fpu_user_xstate_size)
 		return -EFAULT;
 
 	xsave = &fpu->state.xsave;

