Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42C1676EDA
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbjAVPPG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:15:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230470AbjAVPPF (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:15:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 881652202D
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:15:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2702F60C61
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395BBC433D2;
        Sun, 22 Jan 2023 15:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400503;
        bh=BEG/IMQo3ViR1MKiqcXqv6YmJl0zKDvag+6myi/QtHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zj/ItRLualqYGcYRQi+MmoeBkmTvyHST9teWQJssvzhOnXqs0URnIx89pNZ86Ojzn
         tzE5QwaaF3HVg09jNFk1LgSEWyZXeoK+pzmzZlN8T9ZOgThbddvrQebrXHnT1MCdA5
         4Njn67j5v4HrTkjg5UpMZnUFlR4gmfUtM7kwEiZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
        Lee Jones <lee@kernel.org>
Subject: [PATCH 5.10 81/98] efi: rt-wrapper: Add missing include
Date:   Sun, 22 Jan 2023 16:04:37 +0100
Message-Id: <20230122150232.862319265@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 18bba1843fc7f264f58c9345d00827d082f9c558 upstream.

Add the missing #include of asm/assembler.h, which is where the ldr_l
macro is defined.

Fixes: ff7a167961d1b97e ("arm64: efi: Execute runtime services from a dedicated stack")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/efi-rt-wrapper.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kernel/efi-rt-wrapper.S
+++ b/arch/arm64/kernel/efi-rt-wrapper.S
@@ -4,6 +4,7 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/assembler.h>
 
 SYM_FUNC_START(__efi_rt_asm_wrapper)
 	stp	x29, x30, [sp, #-32]!


