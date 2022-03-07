Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDB14CF7A4
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238358AbiCGJrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:47:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238370AbiCGJpq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:45:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B726D66FBA;
        Mon,  7 Mar 2022 01:42:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4376F612C9;
        Mon,  7 Mar 2022 09:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC8EC340F3;
        Mon,  7 Mar 2022 09:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646118;
        bh=fUk54RCdU5Q2bjljqigjse/3y6qzXzXSMrLJGAcJO1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RqId45BMS+fW/2MhRi3HYxNbZfVe41lTUZ3aDDYHyEoyx7WRx6kAVDFARrS6BpDcy
         I8o9h+1qOF/2Sf70yP65uUqZkH6p+7lWwVctkhZLftaxWwO8bklTLCbBWVtATURHIN
         jJVOBVnA3rlcnt6qhhgFraDSf8r7A62UltZAlQLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 140/262] riscv: Fix config KASAN && DEBUG_VIRTUAL
Date:   Mon,  7 Mar 2022 10:18:04 +0100
Message-Id: <20220307091706.401417271@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Ghiti <alexandre.ghiti@canonical.com>

commit c648c4bb7d02ceb53ee40172fdc4433b37cee9c6 upstream.

__virt_to_phys function is called very early in the boot process (ie
kasan_early_init) so it should not be instrumented by KASAN otherwise it
bugs.

Fix this by declaring phys_addr.c as non-kasan instrumentable.

Signed-off-by: Alexandre Ghiti <alexandre.ghiti@canonical.com>
Fixes: 8ad8b72721d0 (riscv: Add KASAN support)
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/mm/Makefile |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/riscv/mm/Makefile
+++ b/arch/riscv/mm/Makefile
@@ -24,6 +24,9 @@ obj-$(CONFIG_KASAN)   += kasan_init.o
 ifdef CONFIG_KASAN
 KASAN_SANITIZE_kasan_init.o := n
 KASAN_SANITIZE_init.o := n
+ifdef CONFIG_DEBUG_VIRTUAL
+KASAN_SANITIZE_physaddr.o := n
+endif
 endif
 
 obj-$(CONFIG_DEBUG_VIRTUAL) += physaddr.o


