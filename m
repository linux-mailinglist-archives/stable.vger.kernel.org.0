Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43B07541758
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377649AbiFGVCs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378493AbiFGVBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:01:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D1BF20E16F;
        Tue,  7 Jun 2022 11:45:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3BB4B82018;
        Tue,  7 Jun 2022 18:45:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E40FC385A2;
        Tue,  7 Jun 2022 18:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627507;
        bh=P93cyAbJAwdWUFf2HFYq9K7w37mCzMvtd/q/MFN3/kw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sI9fJvluDVnV0psyhM9qut5vQ0JFTY6CxHr0geCJHqbkf9YuolyFFVKeeesasIgnV
         /vKxihzmNFB5UFMKI3byTi40bwbc6lKmkeysQnwtr/+T8dmtOt1vM2/tgywOhSCPSM
         oMX/++Zxcf4R9rtKN25DRp1KD2SCDctfgPt+184Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Stephen Zhang <starzhangzsd@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.17 764/772] MIPS: IP30: Remove incorrect `cpu_has_fpu override
Date:   Tue,  7 Jun 2022 19:05:56 +0200
Message-Id: <20220607165011.536143485@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

commit f44b3e74c33fe04defeff24ebcae98c3bcc5b285 upstream.

Remove unsupported forcing of `cpu_has_fpu' to 1, which makes the `nofpu'
kernel parameter non-functional, and also causes a link error:

ld: arch/mips/kernel/traps.o: in function `trap_init':
./arch/mips/include/asm/msa.h:(.init.text+0x348): undefined reference to `handle_fpe'
ld: ./arch/mips/include/asm/msa.h:(.init.text+0x354): undefined reference to `handle_fpe'
ld: ./arch/mips/include/asm/msa.h:(.init.text+0x360): undefined reference to `handle_fpe'

where the CONFIG_MIPS_FP_SUPPORT configuration option has been disabled.

Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Reported-by: Stephen Zhang <starzhangzsd@gmail.com>
Fixes: 7505576d1c1a ("MIPS: add support for SGI Octane (IP30)")
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/mach-ip30/cpu-feature-overrides.h |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/mips/include/asm/mach-ip30/cpu-feature-overrides.h
+++ b/arch/mips/include/asm/mach-ip30/cpu-feature-overrides.h
@@ -29,7 +29,6 @@
 #define cpu_has_3k_cache		0
 #define cpu_has_4k_cache		1
 #define cpu_has_tx39_cache		0
-#define cpu_has_fpu			1
 #define cpu_has_nofpuex			0
 #define cpu_has_32fpr			1
 #define cpu_has_counter			1


