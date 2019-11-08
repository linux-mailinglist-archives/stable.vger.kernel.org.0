Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26DA6F54D1
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733062AbfKHSyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 13:54:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:51834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733061AbfKHSyo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 13:54:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A628E20865;
        Fri,  8 Nov 2019 18:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239284;
        bh=0tRlxh1q0Gt/y03vJ6IG2f7o1/4C/6UXXWZi5nlA6a8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2A449Y3E8cTohTuDmh4xNkU/auX0YeX4P+BC/IS/IOmLmzbN4sr5TQJTZ0L9WtdWb
         nPqaM1Yblzoj9T3jGrbpMuwztsw5zEf81ZUDQw98ePERIheuMLm5EBQ/Tdp/hkKuCc
         zUapr0wE6la88GxbLUjTHo+bTShtjlLHEAaiaLIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Julien Thierry <julien.thierry@arm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        "David A. Long" <dave.long@linaro.org>,
        Sasha Levin <sashal@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.4 62/75] ARM: 8793/1: signal: replace __put_user_error with __put_user
Date:   Fri,  8 Nov 2019 19:50:19 +0100
Message-Id: <20191108174803.303185859@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174708.135680837@linuxfoundation.org>
References: <20191108174708.135680837@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

Commit 18ea66bd6e7a95bdc598223d72757190916af28b upstream.

With Spectre-v1.1 mitigations, __put_user_error is pointless. In an attempt
to remove it, replace its references in frame setups with __put_user.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: David A. Long <dave.long@linaro.org>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/signal.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm/kernel/signal.c
+++ b/arch/arm/kernel/signal.c
@@ -302,7 +302,7 @@ setup_sigframe(struct sigframe __user *s
 	if (err == 0)
 		err |= preserve_vfp_context(&aux->vfp);
 #endif
-	__put_user_error(0, &aux->end_magic, err);
+	err |= __put_user(0, &aux->end_magic);
 
 	return err;
 }
@@ -434,7 +434,7 @@ setup_frame(struct ksignal *ksig, sigset
 	/*
 	 * Set uc.uc_flags to a value which sc.trap_no would never have.
 	 */
-	__put_user_error(0x5ac3c35a, &frame->uc.uc_flags, err);
+	err = __put_user(0x5ac3c35a, &frame->uc.uc_flags);
 
 	err |= setup_sigframe(frame, regs, set);
 	if (err == 0)
@@ -454,8 +454,8 @@ setup_rt_frame(struct ksignal *ksig, sig
 
 	err |= copy_siginfo_to_user(&frame->info, &ksig->info);
 
-	__put_user_error(0, &frame->sig.uc.uc_flags, err);
-	__put_user_error(NULL, &frame->sig.uc.uc_link, err);
+	err |= __put_user(0, &frame->sig.uc.uc_flags);
+	err |= __put_user(NULL, &frame->sig.uc.uc_link);
 
 	err |= __save_altstack(&frame->sig.uc.uc_stack, regs->ARM_sp);
 	err |= setup_sigframe(&frame->sig, regs, set);


