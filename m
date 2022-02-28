Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1F854C731B
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237274AbiB1RcS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:32:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237487AbiB1Rbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:31:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8522688B07;
        Mon, 28 Feb 2022 09:28:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F0DBB815AB;
        Mon, 28 Feb 2022 17:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DD30C340E7;
        Mon, 28 Feb 2022 17:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069331;
        bh=KirpRg22KZ+Soc2sz4q1mhsMNuJshGblruw4JAdbqj8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=prvZPKa2XI/mzRpc0a8w/cuV9u0FxOSlnDP3XlfCZ5FkQLmveK4868FDR6/x+kgVw
         LSXDiHtmjuUKMZKdhNzxa/9qqiJeS3Y02IAZpvksiJIQbKmwfysfMbQnguzwbTa5gd
         hFtuZRxGeuOj775LfOqFRdtRF2GDSvo5/y9sjGMg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 4.19 04/34] parisc/unaligned: Fix ldw() and stw() unalignment handlers
Date:   Mon, 28 Feb 2022 18:24:10 +0100
Message-Id: <20220228172208.851331406@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172207.090703467@linuxfoundation.org>
References: <20220228172207.090703467@linuxfoundation.org>
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
@@ -354,7 +354,7 @@ static int emulate_stw(struct pt_regs *r
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


