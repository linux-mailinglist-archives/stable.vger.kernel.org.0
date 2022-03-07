Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 393234CF70D
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:43:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbiCGJoU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:44:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238443AbiCGJi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:38:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D336465433;
        Mon,  7 Mar 2022 01:32:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CFEE9B80F9F;
        Mon,  7 Mar 2022 09:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F69DC340F3;
        Mon,  7 Mar 2022 09:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645557;
        bh=fUk54RCdU5Q2bjljqigjse/3y6qzXzXSMrLJGAcJO1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J2JsRGGKL84nVOrgSeAHK/ZWpxBJiK9ml37ovBwweDses6TeZFHqU9IfQhqvWeGbZ
         2ajLVtlwIDxUgIi3XidDFWOxT/vr7IjlKbwv/Xjz/AtCUOCCFWE+OP3x2xZcr+bZ9J
         QdV7pnRgb3OGWTxkGZmVuDKQL2q08K2vd5b99W2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.10 028/105] riscv: Fix config KASAN && DEBUG_VIRTUAL
Date:   Mon,  7 Mar 2022 10:18:31 +0100
Message-Id: <20220307091644.972444145@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
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


