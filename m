Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409F147FEEC
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237775AbhL0Pdw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:33:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237969AbhL0Pd2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:33:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB2F6C0617A1;
        Mon, 27 Dec 2021 07:33:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1C0EDCE10B3;
        Mon, 27 Dec 2021 15:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09FE6C36AE7;
        Mon, 27 Dec 2021 15:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619204;
        bh=ocTrA3DNeEupDZulOxoTVgYBqI6Rt7tHRHiENvzAnSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=og6RYB685EFflecz7tTiYRKPF353pXnoov19AyI1z1Age7t3HYsuX1V+fL9WFuFVA
         iq+pI/QpBS+lAkO5p/MsVjidIWLtCgVKSPC2q6tbqteVNkwUB3vLpnIqBryjWbFC5o
         48goOeBX0rawj35kd9BYq38CvBV2zVWCi8v5hmog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.19 29/38] ARM: 9169/1: entry: fix Thumb2 bug in iWMMXt exception handling
Date:   Mon, 27 Dec 2021 16:31:06 +0100
Message-Id: <20211227151320.354445569@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151319.379265346@linuxfoundation.org>
References: <20211227151319.379265346@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 8536a5ef886005bc443c2da9b842d69fd3d7647f upstream.

The Thumb2 version of the FP exception handling entry code treats the
register holding the CP number (R8) differently, resulting in the iWMMXT
CP number check to be incorrect.

Fix this by unifying the ARM and Thumb2 code paths, and switch the
order of the additions of the TI_USED_CP offset and the shifted CP
index.

Cc: <stable@vger.kernel.org>
Fixes: b86040a59feb ("Thumb-2: Implementation of the unified start-up and exceptions code")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/kernel/entry-armv.S |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -620,11 +620,9 @@ call_fpe:
 	tstne	r0, #0x04000000			@ bit 26 set on both ARM and Thumb-2
 	reteq	lr
 	and	r8, r0, #0x00000f00		@ mask out CP number
- THUMB(	lsr	r8, r8, #8		)
 	mov	r7, #1
-	add	r6, r10, #TI_USED_CP
- ARM(	strb	r7, [r6, r8, lsr #8]	)	@ set appropriate used_cp[]
- THUMB(	strb	r7, [r6, r8]		)	@ set appropriate used_cp[]
+	add	r6, r10, r8, lsr #8		@ add used_cp[] array offset first
+	strb	r7, [r6, #TI_USED_CP]		@ set appropriate used_cp[]
 #ifdef CONFIG_IWMMXT
 	@ Test if we need to give access to iWMMXt coprocessors
 	ldr	r5, [r10, #TI_FLAGS]
@@ -633,7 +631,7 @@ call_fpe:
 	bcs	iwmmxt_task_enable
 #endif
  ARM(	add	pc, pc, r8, lsr #6	)
- THUMB(	lsl	r8, r8, #2		)
+ THUMB(	lsr	r8, r8, #6		)
  THUMB(	add	pc, r8			)
 	nop
 


