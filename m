Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF4D95FEF28
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 15:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbiJNNyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 09:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiJNNxV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 09:53:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9EB41C5E29;
        Fri, 14 Oct 2022 06:53:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B2AA61B4D;
        Fri, 14 Oct 2022 13:52:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C632DC433D7;
        Fri, 14 Oct 2022 13:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755563;
        bh=+krbDFwQ/pnuQQX7ebNQRJkJQbc51seZuzRYSbMW96I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gtBBfmyTj/K8iLgdQodZk1PuuOZarxPx5f9w1Md89CILiPoARkCn4mXcyIJ9K7aYe
         f+xdpJdIP1lyeMvEF1n4ziPBQFi5l8re1BSiCGuUc5bvACxpm3YKPvTmZmhatXTIBN
         jdTWUAFp/0Lsjw4N/9LYHjZWpLvz5vgA5tnPGB2/CQC3n2ZDTBjd8rmtVw8HXAj2wT
         8DCf8IxuAjrsN9csXAZp6Lg5a1inERxgUe5Xns4O9y4BJkeY4BacPPN/G/FYZyvWr0
         9ubvJDFXfZoz4brcnHu3Wl3Whk16HcDMoswTjMaHP99p5aXAbJQ+HkSV4z63qVdxRO
         H2b2rLCJRBR2w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Rohan McLure <rmclure@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, christophe.leroy@csgroup.eu,
        maqianga@uniontech.com, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.19 06/10] powerpc: Remove direct call to personality syscall handler
Date:   Fri, 14 Oct 2022 09:52:17 -0400
Message-Id: <20221014135222.2109334-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221014135222.2109334-1-sashal@kernel.org>
References: <20221014135222.2109334-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohan McLure <rmclure@linux.ibm.com>

[ Upstream commit 4df0221f9ded8c39aecfb1a80cef346026671cb7 ]

Syscall handlers should not be invoked internally by their symbol names,
as these symbols defined by the architecture-defined SYSCALL_DEFINE
macro. Fortunately, in the case of ppc64_personality, its call to
sys_personality can be replaced with an invocation to the
equivalent ksys_personality inline helper in <linux/syscalls.h>.

Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220921065605.1051927-13-rmclure@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/syscalls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/syscalls.c b/arch/powerpc/kernel/syscalls.c
index fc999140bc27..690afd77e7fe 100644
--- a/arch/powerpc/kernel/syscalls.c
+++ b/arch/powerpc/kernel/syscalls.c
@@ -88,7 +88,7 @@ long ppc64_personality(unsigned long personality)
 	if (personality(current->personality) == PER_LINUX32
 	    && personality(personality) == PER_LINUX)
 		personality = (personality & ~PER_MASK) | PER_LINUX32;
-	ret = sys_personality(personality);
+	ret = ksys_personality(personality);
 	if (personality(ret) == PER_LINUX32)
 		ret = (ret & ~PER_MASK) | PER_LINUX;
 	return ret;
-- 
2.35.1

