Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43861681096
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237031AbjA3OFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237104AbjA3OE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:04:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED374AD30
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:04:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95029B80E60
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:04:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADBEC433D2;
        Mon, 30 Jan 2023 14:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087494;
        bh=putQd0gXnR4TvDcQELnGportIinjgo/0yDj4neAvYUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTBR4+/WsnHOyQsFqQMjQEQeKvbTHJGXcqNlA5PFM2pwry3sGnmgka5KzkXB0qp+P
         ssh0hWFSEhLCq7lalfh1uOReKQIKuEOxZcolkn+7Lb7JOgme6csD/b7aTNGDE2FMja
         AO6+EfOzXvl3Lvl+YwGQU7YrY3krG6m2VOUwbk8k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masahiro Yamada <masahiroy@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>
Subject: [PATCH 6.1 226/313] riscv: fix -Wundef warning for CONFIG_RISCV_BOOT_SPINWAIT
Date:   Mon, 30 Jan 2023 14:51:01 +0100
Message-Id: <20230130134347.246062573@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masahiro Yamada <masahiroy@kernel.org>

commit 5b89c6f9b2df2b7cf6da8e0b2b87c8995b378cad upstream.

Since commit 80b6093b55e3 ("kbuild: add -Wundef to KBUILD_CPPFLAGS
for W=1 builds"), building with W=1 detects misuse of #if.

  $ make W=1 ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- arch/riscv/kernel/
    [snip]
    AS      arch/riscv/kernel/head.o
  arch/riscv/kernel/head.S:329:5: warning: "CONFIG_RISCV_BOOT_SPINWAIT" is not defined, evaluates to 0 [-Wundef]
    329 | #if CONFIG_RISCV_BOOT_SPINWAIT
        |     ^~~~~~~~~~~~~~~~~~~~~~~~~~

CONFIG_RISCV_BOOT_SPINWAIT is a bool option. #ifdef should be used.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Fixes: 2ffc48fc7071 ("RISC-V: Move spinwait booting method to its own config")
Link: https://lore.kernel.org/r/20230106161213.2374093-1-masahiroy@kernel.org
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/head.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/riscv/kernel/head.S
+++ b/arch/riscv/kernel/head.S
@@ -326,7 +326,7 @@ clear_bss_done:
 	call soc_early_init
 	tail start_kernel
 
-#if CONFIG_RISCV_BOOT_SPINWAIT
+#ifdef CONFIG_RISCV_BOOT_SPINWAIT
 .Lsecondary_start:
 	/* Set trap vector to spin forever to help debug */
 	la a3, .Lsecondary_park


