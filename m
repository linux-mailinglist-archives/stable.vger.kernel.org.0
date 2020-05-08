Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319801CB013
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728296AbgEHMiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:38:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:52694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728288AbgEHMh7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:37:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3DF524954;
        Fri,  8 May 2020 12:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941479;
        bh=cj8sNiytAk4Xcgh7oqsY154ngoPtIOBbziWzdGzKXok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=juswfW/301Fq67aQ28qeivz+ISluUYUzOPR3jEhbQd2dS7SjCsXYeLc/mYd6b03nT
         ErtgfIpNccW8mMM0tWoASO+/eFCI+GA6CJneLMU4mY62QB2NQ1j5C1S4KRfHXlckKy
         6AenyxYdZFvuAKhf4ZVCWmhasgf2Xzq8FIbKceXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 4.4 021/312] MIPS: Fix BC1{EQ,NE}Z return offset calculation
Date:   Fri,  8 May 2020 14:30:12 +0200
Message-Id: <20200508123125.978679613@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paul.burton@imgtec.com>

commit ac1496980f1d2752f26769f5db63afbc9ac2b603 upstream.

The conditions for branching when emulating the BC1EQZ & BC1NEZ
instructions were backwards, leading to each of those instructions being
treated as the other. Fix this by reversing the conditions, and clear up
the code a little for readability & checkpatch.

Fixes: c8a34581ec09 ("MIPS: Emulate the BC1{EQ,NE}Z FPU instructions")
Signed-off-by: Paul Burton <paul.burton@imgtec.com>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Patchwork: https://patchwork.linux-mips.org/patch/13151/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/kernel/branch.c |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

--- a/arch/mips/kernel/branch.c
+++ b/arch/mips/kernel/branch.c
@@ -685,21 +685,9 @@ int __compute_return_epc_for_insn(struct
 			}
 			lose_fpu(1);    /* Save FPU state for the emulator. */
 			reg = insn.i_format.rt;
-			bit = 0;
-			switch (insn.i_format.rs) {
-			case bc1eqz_op:
-				/* Test bit 0 */
-				if (get_fpr32(&current->thread.fpu.fpr[reg], 0)
-				    & 0x1)
-					bit = 1;
-				break;
-			case bc1nez_op:
-				/* Test bit 0 */
-				if (!(get_fpr32(&current->thread.fpu.fpr[reg], 0)
-				      & 0x1))
-					bit = 1;
-				break;
-			}
+			bit = get_fpr32(&current->thread.fpu.fpr[reg], 0) & 0x1;
+			if (insn.i_format.rs == bc1eqz_op)
+				bit = !bit;
 			own_fpu(1);
 			if (bit)
 				epc = epc + 4 +


