Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C200960ABCF
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:57:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236569AbiJXN5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236638AbiJXNzJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:55:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E1D6BC626;
        Mon, 24 Oct 2022 05:44:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5550961015;
        Mon, 24 Oct 2022 12:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66629C433B5;
        Mon, 24 Oct 2022 12:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615266;
        bh=u5uu7zoc5mzz1n4mGIg5JGx6nhue3av2roUzPtmk3q8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YuNwYH5kmcqxHI9vOQmagJsavxTuWYCxMadMTHvvE8rKGy4yoWDR29Za7/+4Qi4+7
         VAFbdYLgkEddNDL+ZiQIJiO0kK3GZWNrIprDj+R/OlkygIpav/pqFS/DvYigSUs0jC
         bzckcvn6q7KbIQ8CmDjYVLtFOgDU9jl4JAV3W9xg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Luciano=20Le=C3=A3o?= <lucianorsleao@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <n@nfraprado.net>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 185/530] x86/cpu: Include the header of init_ia32_feat_ctl()s prototype
Date:   Mon, 24 Oct 2022 13:28:49 +0200
Message-Id: <20221024113053.407947480@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luciano Leão <lucianorsleao@gmail.com>

[ Upstream commit 30ea703a38ef76ca119673cd8bdd05c6e068e2ac ]

Include the header containing the prototype of init_ia32_feat_ctl(),
solving the following warning:

  $ make W=1 arch/x86/kernel/cpu/feat_ctl.o
  arch/x86/kernel/cpu/feat_ctl.c:112:6: warning: no previous prototype for ‘init_ia32_feat_ctl’ [-Wmissing-prototypes]
    112 | void init_ia32_feat_ctl(struct cpuinfo_x86 *c)

This warning appeared after commit

  5d5103595e9e5 ("x86/cpu: Reinitialize IA32_FEAT_CTL MSR on BSP during wakeup")

had moved the function init_ia32_feat_ctl()'s prototype from
arch/x86/kernel/cpu/cpu.h to arch/x86/include/asm/cpu.h.

Note that, before the commit mentioned above, the header include "cpu.h"
(arch/x86/kernel/cpu/cpu.h) was added by commit

  0e79ad863df43 ("x86/cpu: Fix a -Wmissing-prototypes warning for init_ia32_feat_ctl()")

solely to fix init_ia32_feat_ctl()'s missing prototype. So, the header
include "cpu.h" is no longer necessary.

  [ bp: Massage commit message. ]

Fixes: 5d5103595e9e5 ("x86/cpu: Reinitialize IA32_FEAT_CTL MSR on BSP during wakeup")
Signed-off-by: Luciano Leão <lucianorsleao@gmail.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Nícolas F. R. A. Prado <n@nfraprado.net>
Link: https://lore.kernel.org/r/20220922200053.1357470-1-lucianorsleao@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/feat_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/feat_ctl.c b/arch/x86/kernel/cpu/feat_ctl.c
index da696eb4821a..e77032c5f85c 100644
--- a/arch/x86/kernel/cpu/feat_ctl.c
+++ b/arch/x86/kernel/cpu/feat_ctl.c
@@ -1,11 +1,11 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/tboot.h>
 
+#include <asm/cpu.h>
 #include <asm/cpufeature.h>
 #include <asm/msr-index.h>
 #include <asm/processor.h>
 #include <asm/vmx.h>
-#include "cpu.h"
 
 #undef pr_fmt
 #define pr_fmt(fmt)	"x86/cpu: " fmt
-- 
2.35.1



