Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D49BF5742C9
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbiGNE0o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbiGNE0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:26:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECFCDF5C;
        Wed, 13 Jul 2022 21:23:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1988961E9F;
        Thu, 14 Jul 2022 04:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A330C34114;
        Thu, 14 Jul 2022 04:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772617;
        bh=1rsOjCzTzZZGjsOkD4VV/Yi0b4wpzhVrNjevvk3ABTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a0eWmvhnKXT66j3KY3xkdg+1bP5R8N3VbbKbpw0w5ofrd4cBP0/4y994FTrGMM3go
         h4QaOq/2KdWvE/nBt+CfsjALwH2vOaPrcrIumkYywofl/496WvVpklZF3z1bNA7FlD
         d3t5C0OgfIz6hv7NA8X6ZIMerZeoZaZMBQeJZDSwcqcyXN/hKQ9WFURZhrm2nid+Y6
         biC/JAPYIuKYNzlNOUo36JcIEr1zG1bhg3JXEa48D2iJS4ZokZqYX3w1b8g8OtB7H2
         4skdvSOL2Cz7w4GCMz6uvw2zio0P2XPivAjbipXCRgCBwI2ELYI5TgHYRB92NmWMDQ
         NmGFaLc353bNg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, brijesh.singh@amd.com,
        kirill.shutemov@linux.intel.com, michael.roth@amd.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, thomas.lendacky@amd.com
Subject: [PATCH AUTOSEL 5.18 29/41] x86: Clear .brk area at early boot
Date:   Thu, 14 Jul 2022 00:22:09 -0400
Message-Id: <20220714042221.281187-29-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042221.281187-1-sashal@kernel.org>
References: <20220714042221.281187-1-sashal@kernel.org>
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
index 2e10a33778cf..92eae95f1a0b 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -425,6 +425,8 @@ void __init clear_bss(void)
 {
 	memset(__bss_start, 0,
 	       (unsigned long) __bss_stop - (unsigned long) __bss_start);
+	memset(__brk_base, 0,
+	       (unsigned long) __brk_limit - (unsigned long) __brk_base);
 }
 
 static unsigned long get_cmd_line_ptr(void)
-- 
2.35.1

