Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5598A574394
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237605AbiGNEgr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:36:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237661AbiGNEf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:35:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1845C3CBDC;
        Wed, 13 Jul 2022 21:26:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D3B2E61E51;
        Thu, 14 Jul 2022 04:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D126C34114;
        Thu, 14 Jul 2022 04:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772790;
        bh=aCxKvGgvHIIyXlj7KbS97sr9G2YeS9r+HloRo3tKYo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQSe6ajwBtw+5pe0FOMGkLDiy0JVhbbbCpr7AVaC5umztEkQDAvAsZ7n56RHWm12f
         7Yc+on5as0ansPQK2/cAhKKZYGqxbgJvrsCwbqwoWu3KqBCWgdVWgCb3u+8nsaPENl
         3X/wRjDBk5URiz7+k4UQyW/FanMsv8wr/zqSCrHMEUn30mSXwfAAN7SgQ6Sf98P+Bx
         VRcAkjAGfWcrzEYBtZRWcCLncS5sDT2P5wFKohem4iv6rNs7HLSZP7PYB6bFInYxOG
         wDFVbTRmsxukxpEuwCB9aESUoljdBw5QQP019pIkphs/KevftdCEPhidEEXX1LIrFw
         4YRp/YXY2JeTA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, brijesh.singh@amd.com, ak@linux.intel.com,
        kirill.shutemov@linux.intel.com, michael.roth@amd.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, thomas.lendacky@amd.com
Subject: [PATCH AUTOSEL 5.4 07/10] x86: Clear .brk area at early boot
Date:   Thu, 14 Jul 2022 00:26:09 -0400
Message-Id: <20220714042612.282378-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042612.282378-1-sashal@kernel.org>
References: <20220714042612.282378-1-sashal@kernel.org>
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
index 206a4b6144c2..950286016f63 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -383,6 +383,8 @@ static void __init clear_bss(void)
 {
 	memset(__bss_start, 0,
 	       (unsigned long) __bss_stop - (unsigned long) __bss_start);
+	memset(__brk_base, 0,
+	       (unsigned long) __brk_limit - (unsigned long) __brk_base);
 }
 
 static unsigned long get_cmd_line_ptr(void)
-- 
2.35.1

