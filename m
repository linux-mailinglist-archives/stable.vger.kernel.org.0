Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6562E1B3D08
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgDVKLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:11:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:41842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729128AbgDVKLB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:11:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6080D2076E;
        Wed, 22 Apr 2020 10:11:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550260;
        bh=QWITxttuyJgnv8eHJIR5mfNp46l+sx7de2YyG1DNOb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybxtd6BHHAUxaLi8yfKGOs233SUqdNmU978aqckHyq0qY+6jOjZYHYt6DEy6Sd4Qh
         gE6z6mT8oCdbPEYljRB7mjiC2/TbW772CeNvm+ewS4Q1Wt7tURnhEvd29FIHH2+B5P
         xtGOh6Wt+HeOcswbtBz1dkR3isUTQxtWss4hRQwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>,
        Fredrik Strupe <fredrik@strupe.net>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 4.14 074/199] arm64: armv8_deprecated: Fix undef_hook mask for thumb setend
Date:   Wed, 22 Apr 2020 11:56:40 +0200
Message-Id: <20200422095105.551989545@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095057.806111593@linuxfoundation.org>
References: <20200422095057.806111593@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fredrik Strupe <fredrik@strupe.net>

commit fc2266011accd5aeb8ebc335c381991f20e26e33 upstream.

For thumb instructions, call_undef_hook() in traps.c first reads a u16,
and if the u16 indicates a T32 instruction (u16 >= 0xe800), a second
u16 is read, which then makes up the the lower half-word of a T32
instruction. For T16 instructions, the second u16 is not read,
which makes the resulting u32 opcode always have the upper half set to
0.

However, having the upper half of instr_mask in the undef_hook set to 0
masks out the upper half of all thumb instructions - both T16 and T32.
This results in trapped T32 instructions with the lower half-word equal
to the T16 encoding of setend (b650) being matched, even though the upper
half-word is not 0000 and thus indicates a T32 opcode.

An example of such a T32 instruction is eaa0b650, which should raise a
SIGILL since T32 instructions with an eaa prefix are unallocated as per
Arm ARM, but instead works as a SETEND because the second half-word is set
to b650.

This patch fixes the issue by extending instr_mask to include the
upper u32 half, which will still match T16 instructions where the upper
half is 0, but not T32 instructions.

Fixes: 2d888f48e056 ("arm64: Emulate SETEND for AArch32 tasks")
Cc: <stable@vger.kernel.org> # 4.0.x-
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Fredrik Strupe <fredrik@strupe.net>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/kernel/armv8_deprecated.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -607,7 +607,7 @@ static struct undef_hook setend_hooks[]
 	},
 	{
 		/* Thumb mode */
-		.instr_mask	= 0x0000fff7,
+		.instr_mask	= 0xfffffff7,
 		.instr_val	= 0x0000b650,
 		.pstate_mask	= (COMPAT_PSR_T_BIT | COMPAT_PSR_MODE_MASK),
 		.pstate_val	= (COMPAT_PSR_T_BIT | COMPAT_PSR_MODE_USR),


