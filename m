Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC4F15A4920
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiH2LUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231286AbiH2LTg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:19:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DE856C12C;
        Mon, 29 Aug 2022 04:12:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0EB9B61212;
        Mon, 29 Aug 2022 11:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3023C433D6;
        Mon, 29 Aug 2022 11:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771570;
        bh=YJt4NxBD+NcoXprsbu4ayUDQDeGzuAoSY2VYAF4I89c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rPsdv9VGLyffxJfebAtS0hvGgF+DANJvHLng7oftdcIMpfzlotP3jumTqcdO9nrdw
         DOVFRD3bqkOJPIsLfZt4ufRA5Oxl9Mj3Tkc4rRabHD++UCw7LcOivxP9Bnp8M7Dfon
         tLRHStm4jxHp6pEkNhtceXg+yUgORhdGnq4Aez/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Conor Dooley <conor.dooley@microchip.com>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 5.15 117/136] riscv: traps: add missing prototype
Date:   Mon, 29 Aug 2022 12:59:44 +0200
Message-Id: <20220829105809.490319703@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Conor Dooley <conor.dooley@microchip.com>

commit d951b20b9def73dcc39a5379831525d0d2a537e9 upstream.

Sparse complains:
arch/riscv/kernel/traps.c:213:6: warning: symbol 'shadow_stack' was not declared. Should it be static?

The variable is used in entry.S, so declare shadow_stack there
alongside SHADOW_OVERFLOW_STACK_SIZE.

Fixes: 31da94c25aea ("riscv: add VMAP_STACK overflow detection")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220814141237.493457-5-mail@conchuod.ie
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/include/asm/thread_info.h |    2 ++
 arch/riscv/kernel/traps.c            |    3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -42,6 +42,8 @@
 
 #ifndef __ASSEMBLY__
 
+extern long shadow_stack[SHADOW_OVERFLOW_STACK_SIZE / sizeof(long)];
+
 #include <asm/processor.h>
 #include <asm/csr.h>
 
--- a/arch/riscv/kernel/traps.c
+++ b/arch/riscv/kernel/traps.c
@@ -20,9 +20,10 @@
 
 #include <asm/asm-prototypes.h>
 #include <asm/bug.h>
+#include <asm/csr.h>
 #include <asm/processor.h>
 #include <asm/ptrace.h>
-#include <asm/csr.h>
+#include <asm/thread_info.h>
 
 int show_unhandled_signals = 1;
 


