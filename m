Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBA824C729E
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbiB1R1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbiB1R1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:27:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1C6887A9;
        Mon, 28 Feb 2022 09:26:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AFF09B815AB;
        Mon, 28 Feb 2022 17:26:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6C1C340E7;
        Mon, 28 Feb 2022 17:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069182;
        bh=pq8SgMVNtDsMfvtpp3fqPyWT0wvb7EsmmnLCVo4H+2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ojgrOGPOaFloVciYFrUOgdSUCSvsNkg2IfQlHzQ0SkXDwr9XVqs+EDTjCX/vURybc
         m7bAymKcwJot8d87E/wBJ+hw1vJffXS0a9UGq2ZvKdoXNGYKLGy9GoyqvAZ32A3G6C
         GmJ+PHOmELx5fN4hlanrejZWfhSncJ9lVv38Pp40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 4.9 04/29] parisc/unaligned: Fix ldw() and stw() unalignment handlers
Date:   Mon, 28 Feb 2022 18:23:31 +0100
Message-Id: <20220228172142.101564583@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172141.744228435@linuxfoundation.org>
References: <20220228172141.744228435@linuxfoundation.org>
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
@@ -353,7 +353,7 @@ static int emulate_stw(struct pt_regs *r
 	: "r" (val), "r" (regs->ior), "r" (regs->isr)
 	: "r19", "r20", "r21", "r22", "r1", FIXUP_BRANCH_CLOBBER );
 
-	return 0;
+	return ret;
 }
 static int emulate_std(struct pt_regs *regs, int frreg, int flop)
 {
@@ -633,10 +633,10 @@ void handle_unaligned(struct pt_regs *re
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


