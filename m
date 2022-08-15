Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2505950DE
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbiHPErS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233145AbiHPEq2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:46:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F451B1B85;
        Mon, 15 Aug 2022 13:43:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0938460F60;
        Mon, 15 Aug 2022 20:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE22C433D6;
        Mon, 15 Aug 2022 20:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596204;
        bh=Tdf9diKd0OE9ak2v8QKqoD6yOoCtqCB/V/b54A8Szlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IclC098BHhSOVZOoXxltUIIalETS9eMYiKu4WiWPdYjn3XAvCt8f2sTH4MxeqkF/B
         6tMeIjwmmu/thvviyTUGBa59Z2oW2eAlijq+PAdz15ht1Ik5ElvuNxSbP7YxRBCJ3T
         dfwueZ0IoEsRNcXLO8kD+AlseA9N2SQD4hE8Y2Ro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 1004/1157] s390/smp: enforce lowcore protection on CPU restart
Date:   Mon, 15 Aug 2022 20:06:00 +0200
Message-Id: <20220815180519.959548741@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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
index 0a37f5de2863..1ead1293ba17 100644
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



