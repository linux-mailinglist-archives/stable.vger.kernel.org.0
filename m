Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4308B601F86
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230262AbiJRAZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:25:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232249AbiJRAYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:24:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1475390801;
        Mon, 17 Oct 2022 17:20:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2BBBA6134F;
        Tue, 18 Oct 2022 00:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE807C433D7;
        Tue, 18 Oct 2022 00:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051877;
        bh=0WRq8MXZM3ZDilDA1bAGWB/EzA7Q30P8KMT3E0nCaJQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=leMzeEXlvYFquY/hi0TVlS8smkb9g0AkBeONVPpg4qvbgDCDEqfJz/+i05hOCAYa/
         2XWNhmndCTDj93cB9mc3gHeVD2hGhNrwiTj2qGAKCFgvhaGPGRS6tjSlUN5UPMn2D1
         TIGgCJuhQtrcCPHvj3bp+rIyA5tb8bDQJI3gzGFau7nH9rcddIIHLM3ePhh7CJdPAe
         G3j20FM2Qp/zYn2Idt45qeGYfJc09GItPCgd4yLv0egaLyxZyrpIlup5drsE52NHwW
         SHPXnur1/CcVYufPILez3qggmWMJEOHFDD0LVQpKrs/ZlZeA/+2R7+MmGCTEx2aapE
         JrjBsFdtXXhIQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Ungerer <gerg@linux-m68k.org>,
        kernel test robot <lkp@intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 5.4 08/13] m68knommu: fix non-specific 68328 choice interrupt build failure
Date:   Mon, 17 Oct 2022 20:10:57 -0400
Message-Id: <20221018001102.2731930-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018001102.2731930-1-sashal@kernel.org>
References: <20221018001102.2731930-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Ungerer <gerg@linux-m68k.org>

[ Upstream commit 750321ace9107e103f254bf46900629ff347eb7b ]

Compiling for a classic m68k non-MMU target with no specific CPU
selected fails with the following error:

   arch/m68k/68000/ints.c: In function 'process_int':
>> arch/m68k/68000/ints.c:82:30: error: 'ISR' undeclared (first use in this function)
      82 |         unsigned long pend = ISR;
         |                              ^~~

This interrupt handling code is specific to the 68328 family of 68000
parts. There is a couple of variants (68EZ328, 68VZ328) and the common
ancestor of them the strait 68328.

The code here includes a specific header for each variant type. But if
none is selected then nothing is included to supply the appropriate
register and bit flags defines.

Rearrange the includes so that at least one type is always included.
At the very least the 68328 base type should be the fallback, so make
that true.

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/68000/ints.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/68000/ints.c b/arch/m68k/68000/ints.c
index cda49b12d7be..f9a5ec781408 100644
--- a/arch/m68k/68000/ints.c
+++ b/arch/m68k/68000/ints.c
@@ -18,12 +18,12 @@
 #include <asm/io.h>
 #include <asm/machdep.h>
 
-#if defined(CONFIG_M68328)
-#include <asm/MC68328.h>
-#elif defined(CONFIG_M68EZ328)
+#if defined(CONFIG_M68EZ328)
 #include <asm/MC68EZ328.h>
 #elif defined(CONFIG_M68VZ328)
 #include <asm/MC68VZ328.h>
+#else
+#include <asm/MC68328.h>
 #endif
 
 /* assembler routines */
-- 
2.35.1

