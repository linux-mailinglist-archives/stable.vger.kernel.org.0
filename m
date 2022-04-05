Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC33E4F2B94
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239427AbiDEJxs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243398AbiDEJIz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:08:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F49AFAD2;
        Tue,  5 Apr 2022 01:58:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 80DEAB81A12;
        Tue,  5 Apr 2022 08:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8ABCC385A3;
        Tue,  5 Apr 2022 08:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149081;
        bh=coUnbwtMgy4IhV9sRORvYZJQFoFUkg3DcYgYPIf8ovE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h8xsuqdS9IfBvCSnEsKedcmzqfqXa80i2LQBXa0ov/JTwPkmD6/LkUH9y4oOO7dgi
         Vjzk+eHaFGxNTWE2pxW7R3ggBTfq2h/Sl95ee5KxN1uCtcwIX/LCoUjDWTyOeYIBLe
         zcqa1/fOJ5YlICZiUGczN6qRTGf/AWIi25exXovY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0586/1017] powerpc: 8xx: fix a return value error in mpc8xx_pic_init
Date:   Tue,  5 Apr 2022 09:24:59 +0200
Message-Id: <20220405070411.673964265@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 3fd46e551f67f4303c3276a0d6cd20baf2d192c4 ]

mpc8xx_pic_init() should return -ENOMEM instead of 0 when
irq_domain_add_linear() return NULL. This cause mpc8xx_pics_init to continue
executing even if mpc8xx_pic_host is NULL.

Fixes: cc76404feaed ("powerpc/8xx: Fix possible device node reference leak")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220223070223.26845-1-hbh25y@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/8xx/pic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/8xx/pic.c b/arch/powerpc/platforms/8xx/pic.c
index f2ba837249d6..04a6abf14c29 100644
--- a/arch/powerpc/platforms/8xx/pic.c
+++ b/arch/powerpc/platforms/8xx/pic.c
@@ -153,6 +153,7 @@ int __init mpc8xx_pic_init(void)
 	if (mpc8xx_pic_host == NULL) {
 		printk(KERN_ERR "MPC8xx PIC: failed to allocate irq host!\n");
 		ret = -ENOMEM;
+		goto out;
 	}
 
 	ret = 0;
-- 
2.34.1



