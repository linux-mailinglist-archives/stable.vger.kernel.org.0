Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8688676F58
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbjAVPUZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231236AbjAVPUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:20:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A270222E3
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:20:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAD3260C58
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC159C433D2;
        Sun, 22 Jan 2023 15:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400823;
        bh=BEG/IMQo3ViR1MKiqcXqv6YmJl0zKDvag+6myi/QtHA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xvX58p1YiTi4Oq2J2MqP60bXylGaIlwgI8FVz0v8cu22dC8LlLBAxykk+WFfTH1s/
         cqJY9VBkREIUzqH4lFnUAVY/6UapjsjRBbqe5hqrubYYMlYbcjTDvT8SyVbWrPE+NJ
         h9Du5HmLQ7A4rtWIrXA4sfeseBAcwhfEZJekO7BY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ard Biesheuvel <ardb@kernel.org>,
        Lee Jones <lee@kernel.org>
Subject: [PATCH 5.15 102/117] efi: rt-wrapper: Add missing include
Date:   Sun, 22 Jan 2023 16:04:52 +0100
Message-Id: <20230122150237.086166020@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
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


