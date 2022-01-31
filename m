Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330084A422F
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359191AbiAaLLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:11:02 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42096 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359432AbiAaLHu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:07:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29F2A60EFC;
        Mon, 31 Jan 2022 11:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381F2C340EF;
        Mon, 31 Jan 2022 11:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627265;
        bh=4lIxrYkIawaMpLCb2GYq6BEAPnE9g6jmxKVdI76WH0s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jI8EyLdYEbEEPAkaRrtIOKIU0NY92fKrICMU54kB2T7VxAMB00fCcuP8KhBCbPwF3
         lANZ+vRFUzas1aW8WKjyT73v4iUFyrcalPIUk1vX7YYWDEMjJBbZTjjJLWTmFwT997
         N84DblxfcNnbN9JEBnKUI5TXWNEuQaGJLQKjNZO4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.15 006/171] ARM: 9180/1: Thumb2: align ALT_UP() sections in modules sufficiently
Date:   Mon, 31 Jan 2022 11:54:31 +0100
Message-Id: <20220131105230.184169692@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 9f80ccda53b9417236945bc7ece4b519037df74d upstream.

When building for Thumb2, the .alt.smp.init sections that are emitted by
the ALT_UP() patching code may not be 32-bit aligned, even though the
fixup_smp_on_up() routine expects that. This results in alignment faults
at module load time, which need to be fixed up by the fault handler.

So let's align those sections explicitly, and prevent this from occurring.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/assembler.h |    2 ++
 arch/arm/include/asm/processor.h |    1 +
 2 files changed, 3 insertions(+)

--- a/arch/arm/include/asm/assembler.h
+++ b/arch/arm/include/asm/assembler.h
@@ -259,6 +259,7 @@
  */
 #define ALT_UP(instr...)					\
 	.pushsection ".alt.smp.init", "a"			;\
+	.align	2						;\
 	.long	9998b - .					;\
 9997:	instr							;\
 	.if . - 9997b == 2					;\
@@ -270,6 +271,7 @@
 	.popsection
 #define ALT_UP_B(label)					\
 	.pushsection ".alt.smp.init", "a"			;\
+	.align	2						;\
 	.long	9998b - .					;\
 	W(b)	. + (label - 9998b)					;\
 	.popsection
--- a/arch/arm/include/asm/processor.h
+++ b/arch/arm/include/asm/processor.h
@@ -96,6 +96,7 @@ unsigned long get_wchan(struct task_stru
 #define __ALT_SMP_ASM(smp, up)						\
 	"9998:	" smp "\n"						\
 	"	.pushsection \".alt.smp.init\", \"a\"\n"		\
+	"	.align	2\n"						\
 	"	.long	9998b - .\n"					\
 	"	" up "\n"						\
 	"	.popsection\n"


