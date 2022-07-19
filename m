Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86A96579A8B
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238226AbiGSMPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239444AbiGSMOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:14:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6D9348E94;
        Tue, 19 Jul 2022 05:05:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3247961632;
        Tue, 19 Jul 2022 12:04:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D3FC341CA;
        Tue, 19 Jul 2022 12:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232279;
        bh=aCxKvGgvHIIyXlj7KbS97sr9G2YeS9r+HloRo3tKYo4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bLMIUgZkTSkNz0sU4ocm6gjmQ5o5/ZlHU3nPPg/hXxmm2V/z3GiKbcE+kZWw52spv
         DirzHAoEoWKx3VrgiIbdBkpAy+CH+8x/If01iwaQfZ54n3Sx+Y5m+0yad1idkMo1hB
         97zfq29fTFYAUat8ZKQI8dPwgLmJwH77jtns1ToE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 60/71] x86: Clear .brk area at early boot
Date:   Tue, 19 Jul 2022 13:54:23 +0200
Message-Id: <20220719114558.170826862@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
References: <20220719114552.477018590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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



