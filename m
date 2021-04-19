Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BF7F364341
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240500AbhDSNQU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:16:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240484AbhDSNOQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:14:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65DCB613C9;
        Mon, 19 Apr 2021 13:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618837967;
        bh=Byr+fhg5Lf5vgurkOuCBRAGK4/82Kv6/CDnJUn53+ek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ejth4XGbNE8dw0/l6YeKBoQewJAbJPjRm16zyY1THDq/MnMdgO94qKnwb0KTZbcwo
         LKkJM5O8Y89AaQzwhQsHZHPlLXRe6WssFIb0jjwbkPHs7ltT7BHapaSxGCqQyrKfJs
         mOs0Wx+xsjO8ZrTFWgkiVuKPZr01NRb95RrzFH0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fredrik Strupe <fredrik@strupe.net>,
        Russell King <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 5.11 119/122] ARM: 9071/1: uprobes: Dont hook on thumb instructions
Date:   Mon, 19 Apr 2021 15:06:39 +0200
Message-Id: <20210419130534.209813854@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130530.166331793@linuxfoundation.org>
References: <20210419130530.166331793@linuxfoundation.org>
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
@@ -204,7 +204,7 @@ unsigned long uprobe_get_swbp_addr(struc
 static struct undef_hook uprobes_arm_break_hook = {
 	.instr_mask	= 0x0fffffff,
 	.instr_val	= (UPROBE_SWBP_ARM_INSN & 0x0fffffff),
-	.cpsr_mask	= MODE_MASK,
+	.cpsr_mask	= (PSR_T_BIT | MODE_MASK),
 	.cpsr_val	= USR_MODE,
 	.fn		= uprobe_trap_handler,
 };
@@ -212,7 +212,7 @@ static struct undef_hook uprobes_arm_bre
 static struct undef_hook uprobes_arm_ss_hook = {
 	.instr_mask	= 0x0fffffff,
 	.instr_val	= (UPROBE_SS_ARM_INSN & 0x0fffffff),
-	.cpsr_mask	= MODE_MASK,
+	.cpsr_mask	= (PSR_T_BIT | MODE_MASK),
 	.cpsr_val	= USR_MODE,
 	.fn		= uprobe_trap_handler,
 };


