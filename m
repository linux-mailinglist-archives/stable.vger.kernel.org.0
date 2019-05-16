Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61BBA20C63
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfEPP6k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 11:58:40 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42324 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726314AbfEPP6k (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:40 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0006yg-U0; Thu, 16 May 2019 16:58:37 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImC-0001Mc-DK; Thu, 16 May 2019 16:58:36 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Ralf Baechle" <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        "Maciej W. Rozycki" <macro@codesourcery.com>
Date:   Thu, 16 May 2019 16:55:32 +0100
Message-ID: <lsq.1558022132.744609106@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 04/86] MIPS: jump_label.c: Correct the span of the J
 instruction
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Maciej W. Rozycki" <macro@codesourcery.com>

commit 99436f7d69045800ffd1d66912f85d37150c7e2b upstream.

Correct the check for the span of the 256MB segment addressable by the J
instruction according to this instruction's semantics.  The calculation
of the jump target is applied to the address of the delay-slot
instruction that immediately follows.  Adjust the check accordingly by
adding 4 to `e->code' that holds the address of the J instruction
itself.

Signed-off-by: Maciej W. Rozycki <macro@codesourcery.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/8515/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/mips/kernel/jump_label.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/mips/kernel/jump_label.c
+++ b/arch/mips/kernel/jump_label.c
@@ -27,8 +27,8 @@ void arch_jump_label_transform(struct ju
 	union mips_instruction *insn_p =
 		(union mips_instruction *)(unsigned long)e->code;
 
-	/* Jump only works within a 256MB aligned region. */
-	BUG_ON((e->target & ~J_RANGE_MASK) != (e->code & ~J_RANGE_MASK));
+	/* Jump only works within a 256MB aligned region of its delay slot. */
+	BUG_ON((e->target & ~J_RANGE_MASK) != ((e->code + 4) & ~J_RANGE_MASK));
 
 	/* Target must have 4 byte alignment. */
 	BUG_ON((e->target & 3) != 0);

