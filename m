Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1FB430291
	for <lists+stable@lfdr.de>; Sat, 16 Oct 2021 14:22:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240408AbhJPMYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Oct 2021 08:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235147AbhJPMYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Oct 2021 08:24:43 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02782C061570;
        Sat, 16 Oct 2021 05:22:34 -0700 (PDT)
Date:   Sat, 16 Oct 2021 12:22:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634386952;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PAajLHzkK+bz/d1vGmfCT4vXEyfeEfkH7hLzQJ3hlBk=;
        b=LFEYoZzg8rMl1VAiqNczs4I0l5tJm3esM8io65zJX40/OWp5CyCQBKWSPh/sRtOHaidVEP
        9KwDJIXq4bKGCnrc7EUvA5jEVRWyrbYPOcfKULnwLRJY2EkqoNAdmQXsCfWhPsnpKrPXPB
        xJfMRqNMLTs56W3hvJooo9udF/k4OT4YzWQ/XPvEqlFbE+w0awI/Z7bMKwOk1p64vlBWqo
        RZv1nVSJ4XcVXRDuCAJdd4JTUS6Dh8hq4ZcW+66svmDRRxA2+yBu+g6XK0b1jE2qKmkxoI
        n7Tuwq/bjKbVmE4R2IIz3kQRDeH0voT60niL3NENq6dlNeXV68A2qG8ZwSKMNQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634386952;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PAajLHzkK+bz/d1vGmfCT4vXEyfeEfkH7hLzQJ3hlBk=;
        b=KnqC0+7gnsp+r+o310imQ+wY/sOt0J4cVQMmLWefoki0BfCxh4zEk010IB4OipDZF2SVlA
        V+OXpQedI9R0SXDQ==
From:   "tip-bot2 for Borislav Petkov" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/fpu: Mask out the invalid MXCSR bits properly
Cc:     Borislav Petkov <bp@suse.de>, ville.syrjala@linux.intel.com,
        Ser Olmy <ser.olmy@protonmail.com>, <stable@vger.kernel.org>,
        x86@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <YWgYIYXLriayyezv@intel.com>
References: <YWgYIYXLriayyezv@intel.com>
MIME-Version: 1.0
Message-ID: <163438695111.25758.6599528756955601567.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     b2381acd3fd9bacd2c63f53b2c610c89959b31cc
Gitweb:        https://git.kernel.org/tip/b2381acd3fd9bacd2c63f53b2c610c89959=
b31cc
Author:        Borislav Petkov <bp@suse.de>
AuthorDate:    Fri, 15 Oct 2021 12:46:25 +02:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Sat, 16 Oct 2021 12:37:50 +02:00

x86/fpu: Mask out the invalid MXCSR bits properly

This is a fix for the fix (yeah, /facepalm).

The correct mask to use is not the negation of the MXCSR_MASK but the
actual mask which contains the supported bits in the MXCSR register.

Reported and debugged by Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.c=
om>

Fixes: d298b03506d3 ("x86/fpu: Restore the masking out of reserved MXCSR bits=
")
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Ville Syrj=C3=A4l=C3=A4 <ville.syrjala@linux.intel.com>
Tested-by: Ser Olmy <ser.olmy@protonmail.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/YWgYIYXLriayyezv@intel.com
---
 arch/x86/kernel/fpu/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index fa17a27..831b25c 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -385,7 +385,7 @@ static int __fpu_restore_sig(void __user *buf, void __use=
r *buf_fx,
 				return -EINVAL;
 		} else {
 			/* Mask invalid bits out for historical reasons (broken hardware). */
-			fpu->state.fxsave.mxcsr &=3D ~mxcsr_feature_mask;
+			fpu->state.fxsave.mxcsr &=3D mxcsr_feature_mask;
 		}
=20
 		/* Enforce XFEATURE_MASK_FPSSE when XSAVE is enabled */
