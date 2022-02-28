Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3505E4C7374
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238034AbiB1Rfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:35:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238080AbiB1Rey (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:34:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561187E084;
        Mon, 28 Feb 2022 09:31:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 497EDB815AB;
        Mon, 28 Feb 2022 17:31:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0B2BC340E7;
        Mon, 28 Feb 2022 17:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069462;
        bh=InIoslegLjVX1Yt8uC/7lVQLPHklSm5DBQNu2ZKpfd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ln7aUeRHpzN031nnkYcn+TXdzMBQ4wotRMExwqWdIdztYOq2vQP9t1c5R6tfln/55
         fAHLgzLehDXEFHCQMoPfgIapIWC0+qX3sNDiFD5J6DaWTWGQp5c0hqCuRGfbV8xnBp
         XdZ/jAzxIDq41CAkATuh7dudWhMx0NTeAwSlwMx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 05/53] parisc/unaligned: Fix ldw() and stw() unalignment handlers
Date:   Mon, 28 Feb 2022 18:24:03 +0100
Message-Id: <20220228172248.682710207@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172248.232273337@linuxfoundation.org>
References: <20220228172248.232273337@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit a97279836867b1cb50a3d4f0b1bf60e0abe6d46c upstream.

Fix 3 bugs:

a) emulate_stw() doesn't return the error code value, so faulting
instructions are not reported and aborted.

b) Tell emulate_ldw() to handle fldw_l as floating point instruction

c) Tell emulate_ldw() to handle ldw_m as integer instruction

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/unaligned.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/parisc/kernel/unaligned.c
+++ b/arch/parisc/kernel/unaligned.c
@@ -340,7 +340,7 @@ static int emulate_stw(struct pt_regs *r
 	: "r" (val), "r" (regs->ior), "r" (regs->isr)
 	: "r19", "r20", "r21", "r22", "r1", FIXUP_BRANCH_CLOBBER );
 
-	return 0;
+	return ret;
 }
 static int emulate_std(struct pt_regs *regs, int frreg, int flop)
 {
@@ -619,10 +619,10 @@ void handle_unaligned(struct pt_regs *re
 	{
 	case OPCODE_FLDW_L:
 		flop=1;
-		ret = emulate_ldw(regs, R2(regs->iir),0);
+		ret = emulate_ldw(regs, R2(regs->iir), 1);
 		break;
 	case OPCODE_LDW_M:
-		ret = emulate_ldw(regs, R2(regs->iir),1);
+		ret = emulate_ldw(regs, R2(regs->iir), 0);
 		break;
 
 	case OPCODE_FSTW_L:


