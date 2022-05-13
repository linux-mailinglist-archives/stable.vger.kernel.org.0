Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 252315263D6
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356215AbiEMOY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355654AbiEMOYZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:24:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D200050B1C;
        Fri, 13 May 2022 07:24:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6110761F99;
        Fri, 13 May 2022 14:24:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05119C34100;
        Fri, 13 May 2022 14:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652451863;
        bh=pgmlDEK3VnwrJoM5kMd8UWT5gPluDNUCz7SRYnTdRcU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qd2Kh6VOAWqO+zYcvoXVvN9kZWS83xjYFNAAdLRfNZkbco799CEukeTukycr87qSU
         uXwU2y4ziqS9c0hc9wuJslU5LTGE8XjAJlfySGNptFSvPc5CQhJ0sHANnn7ZYEK3RO
         RL/RWGGANOqVgJUFuGKOL23PosakMsPrZ/g/5ivY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 1/7] MIPS: Use address-of operator on section symbols
Date:   Fri, 13 May 2022 16:23:16 +0200
Message-Id: <20220513142225.953417330@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142225.909697091@linuxfoundation.org>
References: <20220513142225.909697091@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

commit d422c6c0644bccbb1ebeefffa51f35cec3019517 upstream.

When building xway_defconfig with clang:

arch/mips/lantiq/prom.c:82:23: error: array comparison always evaluates
to true [-Werror,-Wtautological-compare]
        else if (__dtb_start != __dtb_end)
                             ^
1 error generated.

These are not true arrays, they are linker defined symbols, which are
just addresses. Using the address of operator silences the warning
and does not change the resulting assembly with either clang/ld.lld
or gcc/ld (tested with diff + objdump -Dr). Do the same thing across
the entire MIPS subsystem to ensure there are no more warnings around
this type of comparison.

Link: https://github.com/ClangBuiltLinux/linux/issues/1232
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/bmips/setup.c          |    2 +-
 arch/mips/lantiq/prom.c          |    2 +-
 arch/mips/pic32/pic32mzda/init.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/arch/mips/bmips/setup.c
+++ b/arch/mips/bmips/setup.c
@@ -174,7 +174,7 @@ void __init plat_mem_setup(void)
 		dtb = phys_to_virt(fw_arg2);
 	else if (fw_passed_dtb) /* UHI interface */
 		dtb = (void *)fw_passed_dtb;
-	else if (__dtb_start != __dtb_end)
+	else if (&__dtb_start != &__dtb_end)
 		dtb = (void *)__dtb_start;
 	else
 		panic("no dtb found");
--- a/arch/mips/lantiq/prom.c
+++ b/arch/mips/lantiq/prom.c
@@ -76,7 +76,7 @@ void __init plat_mem_setup(void)
 
 	if (fw_passed_dtb) /* UHI interface */
 		dtb = (void *)fw_passed_dtb;
-	else if (__dtb_start != __dtb_end)
+	else if (&__dtb_start != &__dtb_end)
 		dtb = (void *)__dtb_start;
 	else
 		panic("no dtb found");
--- a/arch/mips/pic32/pic32mzda/init.c
+++ b/arch/mips/pic32/pic32mzda/init.c
@@ -36,7 +36,7 @@ static ulong get_fdtaddr(void)
 	if (fw_passed_dtb && !fw_arg2 && !fw_arg3)
 		return (ulong)fw_passed_dtb;
 
-	if (__dtb_start < __dtb_end)
+	if (&__dtb_start < &__dtb_end)
 		ftaddr = (ulong)__dtb_start;
 
 	return ftaddr;


