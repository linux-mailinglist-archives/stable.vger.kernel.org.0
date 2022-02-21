Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7795D4BE1E4
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352293AbiBUKAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 05:00:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353022AbiBUJ5C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:57:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659EF45790;
        Mon, 21 Feb 2022 01:24:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26C5BB80ECB;
        Mon, 21 Feb 2022 09:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CA3C340E9;
        Mon, 21 Feb 2022 09:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435491;
        bh=n1f98Y30u1MRoTvXq5oADRdUKbZtJKh6KWD/vuLlgzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZVACbFM/ca8sUwtvgst5CeDNdlR9xGCMD9mZ+c8xYZDUNiPe98G6ogAQeMiCM9LB
         1M3Z8Ne/ywmKTAMU2PqCgsd+VXGnmJc/SItKGiEXdWY/jmfwzAcCGRWpCdgV9/Tgct
         U/ulLGUO21PeoQQiJfM29fNulIcVS+2EXmdf5HKA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxime Bizon <mbizon@freebox.fr>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.16 150/227] powerpc/603: Fix boot failure with DEBUG_PAGEALLOC and KFENCE
Date:   Mon, 21 Feb 2022 09:49:29 +0100
Message-Id: <20220221084939.819973632@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 9bb162fa26ed76031ed0e7dbc77ccea0bf977758 upstream.

Allthough kernel text is always mapped with BATs, we still have
inittext mapped with pages, so TLB miss handling is required
when CONFIG_DEBUG_PAGEALLOC or CONFIG_KFENCE is set.

The final solution should be to set a BAT that also maps inittext
but that BAT then needs to be cleared at end of init, and it will
require more changes to be able to do it properly.

As DEBUG_PAGEALLOC or KFENCE are debugging, performance is not a big
deal so let's fix it simply for now to enable easy stable application.

Fixes: 035b19a15a98 ("powerpc/32s: Always map kernel text and rodata with BATs")
Cc: stable@vger.kernel.org # v5.11+
Reported-by: Maxime Bizon <mbizon@freebox.fr>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/aea33b4813a26bdb9378b5f273f00bd5d4abe240.1638857364.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/head_book3s_32.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/head_book3s_32.S
+++ b/arch/powerpc/kernel/head_book3s_32.S
@@ -421,14 +421,14 @@ InstructionTLBMiss:
  */
 	/* Get PTE (linux-style) and check access */
 	mfspr	r3,SPRN_IMISS
-#ifdef CONFIG_MODULES
+#if defined(CONFIG_MODULES) || defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KFENCE)
 	lis	r1, TASK_SIZE@h		/* check if kernel address */
 	cmplw	0,r1,r3
 #endif
 	mfspr	r2, SPRN_SDR1
 	li	r1,_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_EXEC | _PAGE_USER
 	rlwinm	r2, r2, 28, 0xfffff000
-#ifdef CONFIG_MODULES
+#if defined(CONFIG_MODULES) || defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KFENCE)
 	bgt-	112f
 	lis	r2, (swapper_pg_dir - PAGE_OFFSET)@ha	/* if kernel address, use */
 	li	r1,_PAGE_PRESENT | _PAGE_ACCESSED | _PAGE_EXEC


