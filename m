Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 443276DEE89
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:42:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjDLImW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:42:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbjDLImI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:42:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B54C6EB3
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:41:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CE5362FE3
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2094DC433D2;
        Wed, 12 Apr 2023 08:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681288883;
        bh=C3LSIZRJHufdaX7iBUhVu2WMe8ZJJeCpKaH9KVH70WI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nJ7SMDizWzJ5/HYB3DjQFcgBfP6uo8hOa2LB7TPb2GIX1ADo0zAlIpRilnQnzzGZx
         TnvSlyihhoy9BDpHb7niQxmncSy0B+vCE0Ix2z5bRUBIwvqUXW0Sd7CgK1Qxfk0yMm
         Mq19XLxATAfWiuK1WHyxZOpGru5zPBUWW2oR7afA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/164] arm64: compat: Work around uninitialized variable warning
Date:   Wed, 12 Apr 2023 10:32:56 +0200
Message-Id: <20230412082839.127864879@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 32d85999680601d01b2a36713c9ffd7397c8688b ]

Dan reports that smatch complains about a potential uninitialized
variable being used in the compat alignment fixup code.

The logic is not wrong per se, but we do end up using an uninitialized
variable if reading the instruction that triggered the alignment fault
from user space faults, even if the fault ensures that the uninitialized
value doesn't propagate any further.

Given that we just give up and return 1 if any fault occurs when reading
the instruction, let's get rid of the 'success handling' pattern that
captures the fault in a variable and aborts later, and instead, just
return 1 immediately if any of the get_user() calls result in an
exception.

Fixes: 3fc24ef32d3b ("arm64: compat: Implement misalignment fixups for multiword loads")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Link: https://lore.kernel.org/r/202304021214.gekJ8yRc-lkp@intel.com/
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20230404103625.2386382-1-ardb@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/compat_alignment.c | 32 ++++++++++++----------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kernel/compat_alignment.c b/arch/arm64/kernel/compat_alignment.c
index 5edec2f49ec98..deff21bfa6800 100644
--- a/arch/arm64/kernel/compat_alignment.c
+++ b/arch/arm64/kernel/compat_alignment.c
@@ -314,36 +314,32 @@ int do_compat_alignment_fixup(unsigned long addr, struct pt_regs *regs)
 	int (*handler)(unsigned long addr, u32 instr, struct pt_regs *regs);
 	unsigned int type;
 	u32 instr = 0;
-	u16 tinstr = 0;
 	int isize = 4;
 	int thumb2_32b = 0;
-	int fault;
 
 	instrptr = instruction_pointer(regs);
 
 	if (compat_thumb_mode(regs)) {
 		__le16 __user *ptr = (__le16 __user *)(instrptr & ~1);
+		u16 tinstr, tinst2;
 
-		fault = alignment_get_thumb(regs, ptr, &tinstr);
-		if (!fault) {
-			if (IS_T32(tinstr)) {
-				/* Thumb-2 32-bit */
-				u16 tinst2;
-				fault = alignment_get_thumb(regs, ptr + 1, &tinst2);
-				instr = ((u32)tinstr << 16) | tinst2;
-				thumb2_32b = 1;
-			} else {
-				isize = 2;
-				instr = thumb2arm(tinstr);
-			}
+		if (alignment_get_thumb(regs, ptr, &tinstr))
+			return 1;
+
+		if (IS_T32(tinstr)) { /* Thumb-2 32-bit */
+			if (alignment_get_thumb(regs, ptr + 1, &tinst2))
+				return 1;
+			instr = ((u32)tinstr << 16) | tinst2;
+			thumb2_32b = 1;
+		} else {
+			isize = 2;
+			instr = thumb2arm(tinstr);
 		}
 	} else {
-		fault = alignment_get_arm(regs, (__le32 __user *)instrptr, &instr);
+		if (alignment_get_arm(regs, (__le32 __user *)instrptr, &instr))
+			return 1;
 	}
 
-	if (fault)
-		return 1;
-
 	switch (CODING_BITS(instr)) {
 	case 0x00000000:	/* 3.13.4 load/store instruction extensions */
 		if (LDSTHD_I_BIT(instr))
-- 
2.39.2



