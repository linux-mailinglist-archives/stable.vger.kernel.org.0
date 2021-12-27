Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9484C47FE8D
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:30:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237811AbhL0PaE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:30:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60194 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237818AbhL0P3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:29:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 73DB8610A2;
        Mon, 27 Dec 2021 15:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316B3C36AE7;
        Mon, 27 Dec 2021 15:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640618979;
        bh=L8XArUgMEoOqZEVCBQjAgJuetUeXfQl4QKUPKJfn+tY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D9z14E3cUg1om+t128Pr9UhPUIOOfXeXUEDV2PcsW7rppGEYqh6ZeEOgCDNoGCGDO
         N+SMfAaFwzvCFmEUJNY4sCnkH8s01ZWAlqW68VUg/kzMrPIeSyUQt4XsFaULdfSN1X
         UpYkav/+ZUsxiF3JxB501Sw05jAaUQlu3vrbBCiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.14 20/29] ARM: 9169/1: entry: fix Thumb2 bug in iWMMXt exception handling
Date:   Mon, 27 Dec 2021 16:27:30 +0100
Message-Id: <20211227151319.137346208@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151318.475251079@linuxfoundation.org>
References: <20211227151318.475251079@linuxfoundation.org>
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
@@ -624,11 +624,9 @@ call_fpe:
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
@@ -637,7 +635,7 @@ call_fpe:
 	bcs	iwmmxt_task_enable
 #endif
  ARM(	add	pc, pc, r8, lsr #6	)
- THUMB(	lsl	r8, r8, #2		)
+ THUMB(	lsr	r8, r8, #6		)
  THUMB(	add	pc, r8			)
 	nop
 


