Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6383D5498B9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358457AbiFMMG1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359202AbiFMMF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:05:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F399B25E91;
        Mon, 13 Jun 2022 03:59:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7F3C7B80E5E;
        Mon, 13 Jun 2022 10:59:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E002BC34114;
        Mon, 13 Jun 2022 10:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117981;
        bh=96ceQgJASxyzZfSQvr0juwSMRmN1lL3Esf2pvX28VOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWIAKEkUjdfER+NXpuTi7iudQzwMp6rRtAuWURzqtbXIvGMC3TEpc8qwmeH0I7PKi
         oDtq/tfX0C2+3/vliOpoLRs54BMe/lrPAjJ7phN+kBeT2WgsftvwlGE/+Sf1LfmOP5
         PHWaRUyZ2Vhfy2Gw8OPLnALR3WW4ab0cKv95e6JA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Stephen Zhang <starzhangzsd@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 4.19 187/287] MIPS: IP27: Remove incorrect `cpu_has_fpu override
Date:   Mon, 13 Jun 2022 12:10:11 +0200
Message-Id: <20220613094929.537369693@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
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
@@ -28,7 +28,6 @@
 #define cpu_has_6k_cache		0
 #define cpu_has_8k_cache		0
 #define cpu_has_tx39_cache		0
-#define cpu_has_fpu			1
 #define cpu_has_nofpuex			0
 #define cpu_has_32fpr			1
 #define cpu_has_counter			1


