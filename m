Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE15D39864F
	for <lists+stable@lfdr.de>; Wed,  2 Jun 2021 12:19:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233011AbhFBKVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Jun 2021 06:21:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232708AbhFBKUJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Jun 2021 06:20:09 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28093C06138F;
        Wed,  2 Jun 2021 03:17:58 -0700 (PDT)
Message-Id: <20210602101618.736036127@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1622629076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=DGkVxXkLnQqzemQn1GsMwh95ap9O1ytCLq2NJcMCb3I=;
        b=eAeLX8vHolaZ0+wsT8BjXrLGP+R96GYKhxd2xQ0Sp4gjnhA5B4bA+laDKs2z8vQXw9mvhU
        Cwm4sn3M7pqiA7vQ1LAfC5WjnVVuZNYlLZ9zCfjKK7Mz1UJdydcwOdKRaMiPaVH4+YJo4l
        TuTPmGFZFSbdmetstRT+4UOUyumhlKUw7es6SLiI9ByvbXVzFEpcCaeP+iA5/l9lyNeX3o
        V60MaWJmtOKgNyBxR6UvFF/HJyJurvAVvnWvoIrpbI3TRdJ7Wlwuk3zRK59McOh59m26TX
        e+MwWhxhL7zTZ0Uhsj4q27poA1JlM6YFu/xbsO6JHoe77zLldMsuSHXEr75wAw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1622629076;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:  references:references;
        bh=DGkVxXkLnQqzemQn1GsMwh95ap9O1ytCLq2NJcMCb3I=;
        b=4U4CsKexRwRa951J5YWB1+/oIyvk2Q1npmKhFlFHOSHHXnEMU7vPg8ZBla53uTxkObeer5
        kzWykBpKH1WXlaCw==
Date:   Wed, 02 Jun 2021 11:55:47 +0200
From:   Thomas Gleixner <tglx@linutronix.de>
To:     LKML <linux-kernel@vger.kernel.org>
Cc:     x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Tony Luck <tony.luck@intel.com>,
        Yu-cheng Yu <yu-cheng.yu@intel.com>, stable@vger.kernel.org
Subject: [patch 4/8] x86/fpu: Limit xstate copy size in xstateregs_set()
References: <20210602095543.149814064@linutronix.de>
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

