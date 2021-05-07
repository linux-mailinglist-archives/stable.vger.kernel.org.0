Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 105D4376D84
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 01:56:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhEGX4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 19:56:46 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:52582 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbhEGX4q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 19:56:46 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1620431744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fbh3BTWRMNz4FxGbZchtRmIZeaH487zynmurLIhQf+k=;
        b=VFFs+UvTGGl50siRMTD2Gj/jdLFEjdeo7etDjX94VrLvrD8hvDVZbrlTNnpY0XMgPX9+V3
        0FOhX1+6SQREqvaB8S/WS/V5AgyLNv1/v25frifYNUdAQDcUASpICf8axySeZhCPtPAfIc
        IC2TRo32mnZOrRnz50vlqB8mRHBxn2GWX2rO4LKTojjh2MziwkiuwQOe1N5OmG9fjwPVVC
        TaAbEX9UuUKneBswtrf8ZCBvCHjrLMmOtMBUWVABvPt5EkPzDHAFhaJ6Wa8lPoR4aY9KNe
        +fy609V/oXj6LQnfrna4yM10E5GwNejpAQRJSCOtxVF+W9qCfPkmUH+Rcft5Mg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1620431744;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fbh3BTWRMNz4FxGbZchtRmIZeaH487zynmurLIhQf+k=;
        b=+4CaeA2OMZdPqVRKtGX9mMumhwhnWiDhd5YXbc/E2rSxQpcQ75i18KG0Y+YgyguH/lMqrR
        vsEMRlsaNz7g4aDw==
To:     gregkh@linuxfoundation.org, chenjun102@huawei.com,
        richardcochran@gmail.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] posix-timers: Preserve return value in COMPAT(clock_adjtime)
In-Reply-To: <162040265791232@kroah.com>
References: <162040265791232@kroah.com>
Date:   Sat, 08 May 2021 01:55:44 +0200
Message-ID: <878s4qm73z.ffs@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chen Jun <chenjun102@huawei.com>

commit 2d036dfa5f10df9782f5278fc591d79d283c1fad upstream.

The return value on success (>= 0) is overwritten by the return value of
compat_put_timex(). That works correct in the fault case, but is wrong for
the success case where compat_put_timex() returns 0.

Just check the return value of compat_put_timex() and return -EFAULT in case
it is not zero.

[ tglx: Massage changelog ]
[ tglx: Backport to 4.19, 4.14 ]

Fixes: 3a4d44b61625 ("ntp: Move adjtimex related compat syscalls to native counterparts")
Signed-off-by: Chen Jun <chenjun102@huawei.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Richard Cochran <richardcochran@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210414030449.90692-1-chenjun102@huawei.com
---
 kernel/time/posix-timers.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1166,8 +1166,8 @@ COMPAT_SYSCALL_DEFINE2(clock_adjtime, cl
 
 	err = kc->clock_adj(which_clock, &ktx);
 
-	if (err >= 0)
-		err = compat_put_timex(utp, &ktx);
+	if (err >= 0 && compat_put_timex(utp, &ktx))
+		return -EFAULT;
 
 	return err;
 }
