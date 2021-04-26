Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C2A36AD6F
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232922AbhDZHgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:36:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232882AbhDZHgF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Apr 2021 03:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1AEDB6135F;
        Mon, 26 Apr 2021 07:33:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619422421;
        bh=mVyWi9XG90EchzaJQHS0kyf10Ks7lxWF4bcLEboImsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=esxUFgktd+RxU6FQCWWWpK9Snvj7dcaWysWr6EoYhXJsXelPxiEjlxg6qMCiOC7fl
         CI5qwwuGfPt2t6fsGQ2gpgaO75Ig+JkCsELBB9cMrbnfseOC6UXz6sLKRl/nJoLr6v
         O+uxaBfSRltQy0riEYZkET2FBpJMODT+6N50YzTg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fredrik Strupe <fredrik@strupe.net>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.9 22/37] ARM: 9071/1: uprobes: Dont hook on thumb instructions
Date:   Mon, 26 Apr 2021 09:29:23 +0200
Message-Id: <20210426072818.005764582@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210426072817.245304364@linuxfoundation.org>
References: <20210426072817.245304364@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fredrik Strupe <fredrik@strupe.net>

commit d2f7eca60b29006285d57c7035539e33300e89e5 upstream.

Since uprobes is not supported for thumb, check that the thumb bit is
not set when matching the uprobes instruction hooks.

The Arm UDF instructions used for uprobes triggering
(UPROBE_SWBP_ARM_INSN and UPROBE_SS_ARM_INSN) coincidentally share the
same encoding as a pair of unallocated 32-bit thumb instructions (not
UDF) when the condition code is 0b1111 (0xf). This in effect makes it
possible to trigger the uprobes functionality from thumb, and at that
using two unallocated instructions which are not permanently undefined.

Signed-off-by: Fredrik Strupe <fredrik@strupe.net>
Cc: stable@vger.kernel.org
Fixes: c7edc9e326d5 ("ARM: add uprobes support")
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/probes/uprobes/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/probes/uprobes/core.c
+++ b/arch/arm/probes/uprobes/core.c
@@ -207,7 +207,7 @@ unsigned long uprobe_get_swbp_addr(struc
 static struct undef_hook uprobes_arm_break_hook = {
 	.instr_mask	= 0x0fffffff,
 	.instr_val	= (UPROBE_SWBP_ARM_INSN & 0x0fffffff),
-	.cpsr_mask	= MODE_MASK,
+	.cpsr_mask	= (PSR_T_BIT | MODE_MASK),
 	.cpsr_val	= USR_MODE,
 	.fn		= uprobe_trap_handler,
 };
@@ -215,7 +215,7 @@ static struct undef_hook uprobes_arm_bre
 static struct undef_hook uprobes_arm_ss_hook = {
 	.instr_mask	= 0x0fffffff,
 	.instr_val	= (UPROBE_SS_ARM_INSN & 0x0fffffff),
-	.cpsr_mask	= MODE_MASK,
+	.cpsr_mask	= (PSR_T_BIT | MODE_MASK),
 	.cpsr_val	= USR_MODE,
 	.fn		= uprobe_trap_handler,
 };


