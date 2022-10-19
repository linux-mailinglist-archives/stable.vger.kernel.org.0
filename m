Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B4D603D25
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231913AbiJSI6D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:58:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbiJSI5D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:57:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76E0E9E0D1;
        Wed, 19 Oct 2022 01:53:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B0D061877;
        Wed, 19 Oct 2022 08:52:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91766C433D6;
        Wed, 19 Oct 2022 08:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169533;
        bh=L++NyLPF29P94YsyQAgGB6D++lyuxhHufzqYhYkdOmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tYbPcJE/qdglMsQRKRRz3cLnodVDnkXApr20n0pn4y3U90WV0yHldxJsUsRaQ+LaN
         TBgFyewimMSbGhM/l+hxYaRJPx7cdGY2J7E+Sy9iG8dXapENtIZ5PGn29yeKzPOI3P
         YsrN71BRbNmbAZjoXv2viIFGs00xHrYAx91P0eZ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Luciano=20Le=C3=A3o?= <lucianorsleao@gmail.com>,
        Borislav Petkov <bp@suse.de>,
        "=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" 
        <n@nfraprado.net>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 313/862] x86/cpu: Include the header of init_ia32_feat_ctl()s prototype
Date:   Wed, 19 Oct 2022 10:26:40 +0200
Message-Id: <20221019083303.846947248@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAD_ENC_HEADER,BAYES_00,
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
index 993697e71854..03851240c3e3 100644
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



