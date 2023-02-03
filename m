Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD4D96895C9
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:24:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbjBCKWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:22:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233395AbjBCKW3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:22:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2E94A07D0
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:22:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B990B82A5F
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:22:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7E7C4339B;
        Fri,  3 Feb 2023 10:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419727;
        bh=xL6mj3in65YLENSDB9HU2mlwGRdqZQ1tv1ig7iJgYqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FBCGmRNNzm6lPVa1bxJr6zm8NCOaegzw9gW3JTN59d8eEasIwNkHjCLNRi56S5T71
         gBlKw97l7xfJZ+3jRXXPnBRGpyTeNHRhDLh88tqwxilVkDp4/O2lNlw725z9QwptMr
         yV217EEMBtlPZI1LzkuxiMb7TAoUhSqomV0ByW4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Geert Uytterhoeven <geert@linux-m68k.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 17/28] s390: workaround invalid gcc-11 out of bounds read warning
Date:   Fri,  3 Feb 2023 11:13:05 +0100
Message-Id: <20230203101010.708423717@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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



