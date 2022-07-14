Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 960C357436C
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 06:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbiGNEem (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 00:34:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237494AbiGNEeB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 00:34:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BDB3AE5D;
        Wed, 13 Jul 2022 21:26:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA5A5B82382;
        Thu, 14 Jul 2022 04:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44BAC385A2;
        Thu, 14 Jul 2022 04:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657772763;
        bh=IY9obyUbaF68yfYZpMGSF3IiznXLM6j2my70GgvTAUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMe/b9J0KFWUc4DdFKcV0jrL4geiFkiah65aNQ+dq8n8rykwVI/hJZedhx71yaYTF
         BObSfV8oZvzyMO0qInDfnzsSrDcIX0JDfX3fB1fiSJA0Po2DiiRs8oNqmn40FHS5Rz
         lR1HExTElzi37Wc7twz6TF3cfiMt5u0a0BSGSlzm4/5SwsIxM7bGiIE+Mt3ywk+Em5
         ZyE4FAOkjjx/8tpM/88GmjxvfXKiVamY7YCvht/+ee/GTHkJN5gUOzOGOR3a8v0NGg
         wQGFFyFSQCSxBFFkFz0pfRzGw2XoPAU0LqXA4164Qij71YJoMZf1e+n0QJSLEccv/k
         7o+4eNGI50sog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, brijesh.singh@amd.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, ak@linux.intel.com,
        michael.roth@amd.com, jroedel@suse.de, thomas.lendacky@amd.com
Subject: [PATCH AUTOSEL 5.10 10/15] x86: Clear .brk area at early boot
Date:   Thu, 14 Jul 2022 00:25:35 -0400
Message-Id: <20220714042541.282175-10-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220714042541.282175-1-sashal@kernel.org>
References: <20220714042541.282175-1-sashal@kernel.org>
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
index 05e117137b45..efe13ab366f4 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -419,6 +419,8 @@ static void __init clear_bss(void)
 {
 	memset(__bss_start, 0,
 	       (unsigned long) __bss_stop - (unsigned long) __bss_start);
+	memset(__brk_base, 0,
+	       (unsigned long) __brk_limit - (unsigned long) __brk_base);
 }
 
 static unsigned long get_cmd_line_ptr(void)
-- 
2.35.1

