Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F085560A387
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbiJXL4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:56:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232186AbiJXLzr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:55:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A16A07AC09;
        Mon, 24 Oct 2022 04:46:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A768161297;
        Mon, 24 Oct 2022 11:44:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE68C433D6;
        Mon, 24 Oct 2022 11:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611886;
        bh=bY8DNX8UOorDhqSkPBTMfcJA4H/jHKBSD5u9N8pqcX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A68s4C+pHNVSTVf+hdfYonDyoea+og+D+PKuA15Mq89hm1l65KYurZvudGCrJE0Ez
         oUz5ITF+lA4cLHVXcj+4RFwvEvo9UWny/LStBdyq+X5vCOBVhewiHVdd666p5mjyLL
         ZcGa71DiLfdZIoV8bol5s39Pr/25nxto8BC6BRBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 118/159] powerpc/math_emu/efp: Include module.h
Date:   Mon, 24 Oct 2022 13:31:12 +0200
Message-Id: <20221024112953.804929755@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112949.358278806@linuxfoundation.org>
References: <20221024112949.358278806@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit cfe0d370e0788625ce0df3239aad07a2506c1796 ]

When building with a recent version of clang, there are a couple of
errors around the call to module_init():

  arch/powerpc/math-emu/math_efp.c:927:1: error: type specifier missing, defaults to 'int'; ISO C99 and later do not support implicit int [-Wimplicit-int]
  module_init(spe_mathemu_init);
  ^
  int
  arch/powerpc/math-emu/math_efp.c:927:13: error: a parameter list without types is only allowed in a function definition
  module_init(spe_mathemu_init);
              ^
  2 errors generated.

module_init() is a macro, which is not getting expanded because module.h
is not included in this file. Add the include so that the macro can
expand properly, clearing up the build failure.

Fixes: ac6f120369ff ("powerpc/85xx: Workaroudn e500 CPU erratum A005")
[chleroy: added fixes tag]
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Link: https://lore.kernel.org/r/8403854a4c187459b2f4da3537f51227b70b9223.1662134272.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/math-emu/math_efp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/math-emu/math_efp.c b/arch/powerpc/math-emu/math_efp.c
index 28337c9709ae..cc4bbc4f8169 100644
--- a/arch/powerpc/math-emu/math_efp.c
+++ b/arch/powerpc/math-emu/math_efp.c
@@ -21,6 +21,7 @@
 
 #include <linux/types.h>
 #include <linux/prctl.h>
+#include <linux/module.h>
 
 #include <asm/uaccess.h>
 #include <asm/reg.h>
-- 
2.35.1



