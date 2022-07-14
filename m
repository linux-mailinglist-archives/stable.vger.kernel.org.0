Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADF25743C4
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:39:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231415AbiGNEjm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237556AbiGNEiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:38:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4770F3ED77;
        Wed, 13 Jul 2022 21:27:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C47EBB8237C;
        Thu, 14 Jul 2022 04:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF15C34115;
        Thu, 14 Jul 2022 04:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772837;
        bh=JvbAeAtnbcUPKYYQMBpl0nkK9xZaQTNviOPQ5mXGdFI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L3jrtXPnvRsC4TsdatlT8NS1Rz80P2gbTLT+JPlDfRtqu2C98AQgAuFo+LQ58kKfy
         0h4/bFJ/1tf5zCSvOnKybgRHrzqEI1TubGMNmsBNFz/b2qchvwDyaKniAVKgcr/Zf/
         uO+gMYIWUMGb5hJBZoE18VuoKxPIKtGUJ34niYlOeTcsOcSI+CuYj+NSESbNnDSfTm
         HWLLUPYiULHLP019r6lMSKpcCyST8PPCjuPOOypqBmtiC/FXk4Xoph39oeR/+ToKIk
         4L391SVOKMOQ4mGRQtZ5BvUgtWUzqOpBPMTMWZIaOUPkxRk5gbuyF8et1ZjMT2lHK/
         TGhySXHEEOuLg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, brijesh.singh@amd.com, michael.roth@amd.com,
        ak@linux.intel.com, thomas.lendacky@amd.com
Subject: [PATCH AUTOSEL 4.9 3/4] x86: Clear .brk area at early boot
Date:   Thu, 14 Jul 2022 00:27:06 -0400
Message-Id: <20220714042707.282675-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042707.282675-1-sashal@kernel.org>
References: <20220714042707.282675-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Juergen Gross <jgross@suse.com>

[ Upstream commit 38fa5479b41376dc9d7f57e71c83514285a25ca0 ]

The .brk section has the same properties as .bss: it is an alloc-only
section and should be cleared before being used.

Not doing so is especially a problem for Xen PV guests, as the
hypervisor will validate page tables (check for writable page tables
and hypervisor private bits) before accepting them to be used.

Make sure .brk is initially zero by letting clear_bss() clear the brk
area, too.

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lore.kernel.org/r/20220630071441.28576-3-jgross@suse.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/head64.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index b5785c197e53..2b2060d842d1 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -106,6 +106,8 @@ static void __init clear_bss(void)
 {
 	memset(__bss_start, 0,
 	       (unsigned long) __bss_stop - (unsigned long) __bss_start);
+	memset(__brk_base, 0,
+	       (unsigned long) __brk_limit - (unsigned long) __brk_base);
 }
 
 static unsigned long get_cmd_line_ptr(void)
-- 
2.35.1

