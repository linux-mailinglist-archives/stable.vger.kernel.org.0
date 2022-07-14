Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E70D35743B8
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237638AbiGNEib (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234296AbiGNEhj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:37:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E771A81E;
        Wed, 13 Jul 2022 21:27:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8867EB82376;
        Thu, 14 Jul 2022 04:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A16C34114;
        Thu, 14 Jul 2022 04:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772824;
        bh=4fuDo9GyeOb4vTdduQvEyIq7rIyMwxLnhvLNqWOmU98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V2ljjy1oD+zxOGckcDl7YTVuuuetpHX7soZ//vBJ7l+/fYkclzTHu7Tf1P3A0CVnu
         ZFVmAA64s9KDw0ev+ePF4EJz1wOsy9/utflWhK0u7YhnBFaoGxOLxVLQU/WfkidBzv
         ReL3tJHB1bg3fm7caNb/9Oi6f4spUibLlkgUtlk13XF7QHeQaVeRbtm4sFL2ntzHS8
         sCsY0E264fr5kUXsojj8caF2F7vtWlszDpNkhlMq+WCfBYkvUZtUvuCmXq0+FrymrN
         rMktEzyZjl6eQifXMOwOVARU/0Rm4yNMwdyEwB7fO+gYmky/0p9JTeX8hjD3iVlbfh
         VS5hCBcjOATwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, brijesh.singh@amd.com,
        kirill.shutemov@linux.intel.com, michael.roth@amd.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, thomas.lendacky@amd.com
Subject: [PATCH AUTOSEL 4.14 4/5] x86: Clear .brk area at early boot
Date:   Thu, 14 Jul 2022 00:26:51 -0400
Message-Id: <20220714042653.282599-4-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042653.282599-1-sashal@kernel.org>
References: <20220714042653.282599-1-sashal@kernel.org>
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
index e00ccbcc2913..59aa1d0646e4 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -292,6 +292,8 @@ static void __init clear_bss(void)
 {
 	memset(__bss_start, 0,
 	       (unsigned long) __bss_stop - (unsigned long) __bss_start);
+	memset(__brk_base, 0,
+	       (unsigned long) __brk_limit - (unsigned long) __brk_base);
 }
 
 static unsigned long get_cmd_line_ptr(void)
-- 
2.35.1

