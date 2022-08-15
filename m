Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 758C35946B5
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352578AbiHOXAV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352512AbiHOW6f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:58:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E401474E0;
        Mon, 15 Aug 2022 12:56:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F800B80EAB;
        Mon, 15 Aug 2022 19:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B02C433D6;
        Mon, 15 Aug 2022 19:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593409;
        bh=Jl6YcRGxZmnFIQ7S0vKwAI423njHCiOFiSTN7qLkT9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eO5dRmm3PrY26leKDntummwSKQsNDY2F47jqEkZIYf7Pz6D+dmmtfhfb0Eqy49a6J
         1uTnHf/WsoiGOdTtYfMsFXCNf5zl4Hfv8dxPwfsTNztnVpKxU3J/inljMjFD2a+odo
         f/83e0NxQwLXyU44zQeL4MfASJnhkNmhJa+aOVSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0924/1095] s390/smp: enforce lowcore protection on CPU restart
Date:   Mon, 15 Aug 2022 20:05:23 +0200
Message-Id: <20220815180507.484901030@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Gordeev <agordeev@linux.ibm.com>

[ Upstream commit 6f5c672d17f583b081e283927f5040f726c54598 ]

As result of commit 915fea04f932 ("s390/smp: enable DAT before
CPU restart callback is called") the low-address protection bit
gets mistakenly unset in control register 0 save area of the
absolute zero memory. That area is used when manual PSW restart
happened to hit an offline CPU. In this case the low-address
protection for that CPU will be dropped.

Reviewed-by: Heiko Carstens <hca@linux.ibm.com>
Fixes: 915fea04f932 ("s390/smp: enable DAT before CPU restart callback is called")
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/setup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index 2cef49983e9e..3327412f82a6 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -508,8 +508,8 @@ static void __init setup_lowcore_dat_on(void)
 	S390_lowcore.svc_new_psw.mask |= PSW_MASK_DAT;
 	S390_lowcore.program_new_psw.mask |= PSW_MASK_DAT;
 	S390_lowcore.io_new_psw.mask |= PSW_MASK_DAT;
-	__ctl_store(S390_lowcore.cregs_save_area, 0, 15);
 	__ctl_set_bit(0, 28);
+	__ctl_store(S390_lowcore.cregs_save_area, 0, 15);
 	put_abs_lowcore(restart_flags, RESTART_FLAG_CTLREGS);
 	put_abs_lowcore(program_new_psw, lc->program_new_psw);
 	for (cr = 0; cr < ARRAY_SIZE(lc->cregs_save_area); cr++)
-- 
2.35.1



