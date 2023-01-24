Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46816799F8
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234402AbjAXNng (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:43:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234378AbjAXNnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:43:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF7C4671C;
        Tue, 24 Jan 2023 05:42:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF9E0B811D3;
        Tue, 24 Jan 2023 13:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528CDC433D2;
        Tue, 24 Jan 2023 13:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567748;
        bh=xL6mj3in65YLENSDB9HU2mlwGRdqZQ1tv1ig7iJgYqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QJmxkkK4Ozx4gilhNrZqOoBvPPBglcnCwBfbVNUou9M8wTAS6MMTuoZkxcQ0EGVeK
         Ewcf7wlvkIUSLU3BIapBFqq2lyiyfsvQ0YLI8RDjl2kXZfwJ2mb1GJXLiyl30N/a33
         twjfbb2UOHN9qFVkw1pnHNIndQWoGV1LuDVF0/OnyyWHKQpDGkTYWMb3a6CXQvd9ah
         evsoO7mUPPBHBHC+BHERmHbtTUgIl3E6RoyHYjjx0z2yWUTh4qAyBhVA2VXGMZTFpp
         iBFobFpdEKtPDhRngizwSvyX/wsnq/d/Dph9NNarGZ94aN07m1Van2GnUAiQ0sunnt
         dwYqjcdrYqdFA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Heiko Carstens <hca@linux.ibm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>, gor@linux.ibm.com,
        agordeev@linux.ibm.com, Jason@zx2c4.com, iii@linux.ibm.com,
        egorenar@linux.ibm.com, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 20/35] s390: workaround invalid gcc-11 out of bounds read warning
Date:   Tue, 24 Jan 2023 08:41:16 -0500
Message-Id: <20230124134131.637036-20-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 41e1992665a2701fa025a8b76970c43b4148446f ]

GCC 11.1.0 and 11.2.0 generate a wrong warning when compiling the
kernel e.g. with allmodconfig:

arch/s390/kernel/setup.c: In function ‘setup_lowcore_dat_on’:
./include/linux/fortify-string.h:57:33: error: ‘__builtin_memcpy’ reading 128 bytes from a region of size 0 [-Werror=stringop-overread]
...
arch/s390/kernel/setup.c:526:9: note: in expansion of macro ‘memcpy’
  526 |         memcpy(abs_lc->cregs_save_area, S390_lowcore.cregs_save_area,
      |         ^~~~~~

This could be addressed by using absolute_pointer() with the
S390_lowcore macro, but this is not a good idea since this generates
worse code for performance critical paths.

Therefore simply use a for loop to copy the array in question and get
rid of the warning.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/setup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index ab19ddb09d65..2ec5f1e0312f 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -507,6 +507,7 @@ static void __init setup_lowcore_dat_on(void)
 {
 	struct lowcore *abs_lc;
 	unsigned long flags;
+	int i;
 
 	__ctl_clear_bit(0, 28);
 	S390_lowcore.external_new_psw.mask |= PSW_MASK_DAT;
@@ -521,8 +522,8 @@ static void __init setup_lowcore_dat_on(void)
 	abs_lc = get_abs_lowcore(&flags);
 	abs_lc->restart_flags = RESTART_FLAG_CTLREGS;
 	abs_lc->program_new_psw = S390_lowcore.program_new_psw;
-	memcpy(abs_lc->cregs_save_area, S390_lowcore.cregs_save_area,
-	       sizeof(abs_lc->cregs_save_area));
+	for (i = 0; i < 16; i++)
+		abs_lc->cregs_save_area[i] = S390_lowcore.cregs_save_area[i];
 	put_abs_lowcore(abs_lc, flags);
 }
 
-- 
2.39.0

