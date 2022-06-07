Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61E1D54109E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352027AbiFGT2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:28:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356398AbiFGT1m (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:27:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604E219FD7A;
        Tue,  7 Jun 2022 11:09:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D51986193C;
        Tue,  7 Jun 2022 18:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E59AAC385A2;
        Tue,  7 Jun 2022 18:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625386;
        bh=bcdIFeJXlB+GJWVD5AtTpUmtkilRANrSvoajawvCIEs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rIbzZg7YWrXZkXjxabIG9dYBcfmppAzt+CvLrYrwbu0YqV4OB6bmbV6zMDRg4AiFD
         2+gf4TbH940NKMl23mHdoML80xC6K/Jk4BHrK6noDWUG5RMRb87t9ZqHTv+2ZHft1v
         ySfbcihS94vaBogFKeQ2HbxK0UIivB+zL6heeMNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Stephen Zhang <starzhangzsd@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.15 657/667] MIPS: IP27: Remove incorrect `cpu_has_fpu override
Date:   Tue,  7 Jun 2022 19:05:22 +0200
Message-Id: <20220607164954.351623082@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 424c3781dd1cb401857585331eaaa425a13f2429 upstream.

Remove unsupported forcing of `cpu_has_fpu' to 1, which makes the `nofpu'
kernel parameter non-functional, and also causes a link error:

ld: arch/mips/kernel/traps.o: in function `trap_init':
./arch/mips/include/asm/msa.h:(.init.text+0x348): undefined reference to `handle_fpe'
ld: ./arch/mips/include/asm/msa.h:(.init.text+0x354): undefined reference to `handle_fpe'
ld: ./arch/mips/include/asm/msa.h:(.init.text+0x360): undefined reference to `handle_fpe'

where the CONFIG_MIPS_FP_SUPPORT configuration option has been disabled.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Reported-by: Stephen Zhang <starzhangzsd@gmail.com>
Fixes: 0ebb2f4159af ("MIPS: IP27: Update/restructure CPU overrides")
Cc: stable@vger.kernel.org # v4.2+
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/mach-ip27/cpu-feature-overrides.h |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/mips/include/asm/mach-ip27/cpu-feature-overrides.h
+++ b/arch/mips/include/asm/mach-ip27/cpu-feature-overrides.h
@@ -26,7 +26,6 @@
 #define cpu_has_3k_cache		0
 #define cpu_has_4k_cache		1
 #define cpu_has_tx39_cache		0
-#define cpu_has_fpu			1
 #define cpu_has_nofpuex			0
 #define cpu_has_32fpr			1
 #define cpu_has_counter			1


