Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AA4E3A17BA
	for <lists+stable@lfdr.de>; Wed,  9 Jun 2021 16:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238162AbhFIOsq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Jun 2021 10:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238122AbhFIOsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Jun 2021 10:48:45 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102F8C061574;
        Wed,  9 Jun 2021 07:46:49 -0700 (PDT)
Date:   Wed, 09 Jun 2021 14:46:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1623250008;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nswt7SFOeTd1iTSFLSagR0Vwg3s8VW3bWmaxFkE410A=;
        b=vMAik4xkcfcV4jnGJ70i1AK7Cdym2GFu31vQOhLp1JL+zuXyOJ1clFfZz5e4KDHrUyJJfU
        zEJARMxs3CEHN/TswXCxijsT4eSCjMoktDQHSGk3RFSMIY02lujKzSwG16WqYQ883At2OP
        /1+WIYc8drmF6KlDH4z46xNlY5F+k2698agnKEmFIMS2a2KdfwVjJYHsbCjAHErwiRO5Py
        WTnBw97KyJtCre5QJnFHuOok3Y8Z7ugu15vjowgAZIEelGueowZSOztCRbElpB5PcoE5cv
        clw3ORt1BZmh1Pp4IB2EvHANIPbt0orfYzB2cOx2iBAx/fit2USrAwDykQkuYQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1623250008;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Nswt7SFOeTd1iTSFLSagR0Vwg3s8VW3bWmaxFkE410A=;
        b=IzOhMWLhI1he2I2de3cwtOnZ2GGviQlZwI/e6di/j8Cma0aIcbJHj6pfYsgCErIY1ohdIn
        jiRW5GonwPEy9yBg==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/process: Check PF_KTHREAD and not current->mm
 for kernel threads
Cc:     Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Rik van Riel <riel@surriel.com>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210608144345.912645927@linutronix.de>
References: <20210608144345.912645927@linutronix.de>
MIME-Version: 1.0
Message-ID: <162325000736.29796.12036319105894610527.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     12f7764ac61200e32c916f038bdc08f884b0b604
Gitweb:        https://git.kernel.org/tip/12f7764ac61200e32c916f038bdc08f884b0b604
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Tue, 08 Jun 2021 16:36:20 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Wed, 09 Jun 2021 10:39:04 +02:00

x86/process: Check PF_KTHREAD and not current->mm for kernel threads

switch_fpu_finish() checks current->mm as indicator for kernel threads.
That's wrong because kernel threads can temporarily use a mm of a user
process via kthread_use_mm().

Check the task flags for PF_KTHREAD instead.

Fixes: 0cecca9d03c9 ("x86/fpu: Eager switch PKRU state")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Rik van Riel <riel@surriel.com>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20210608144345.912645927@linutronix.de
---
 arch/x86/include/asm/fpu/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index ceeba9f..18382ac 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -578,7 +578,7 @@ static inline void switch_fpu_finish(struct fpu *new_fpu)
 	 * PKRU state is switched eagerly because it needs to be valid before we
 	 * return to userland e.g. for a copy_to_user() operation.
 	 */
-	if (current->mm) {
+	if (!(current->flags & PF_KTHREAD)) {
 		pk = get_xsave_addr(&new_fpu->state.xsave, XFEATURE_PKRU);
 		if (pk)
 			pkru_val = pk->pkru;
