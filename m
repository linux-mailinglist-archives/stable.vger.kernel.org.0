Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1150551BC1
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245525AbiFTNL0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344374AbiFTNKK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:10:10 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66F731CB2D;
        Mon, 20 Jun 2022 06:05:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9151CCE138F;
        Mon, 20 Jun 2022 13:03:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9964C3411B;
        Mon, 20 Jun 2022 13:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730200;
        bh=/5STY4As5xDCMvpwXO6rE/4s0dKYkRo+K5FsrP4My5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXm/FMvr+x7D+ktnXf2pCfuUaoBiJ7/0gn+zqeiKbf6DISSIf7WfqJ/dgTCwL0V9k
         9Ok59LpQ+50uTBp193Vc5XCyyu/QEFN3Y9ad2bt4yeYPyly5Rf+jlEB80KmDvz6XME
         kUuelDBGc1d1cnIyYd1Ccj2tSBKeII+vkuAI/iRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Tali Perry <tali.perry1@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 55/84] i2c: npcm7xx: Add check for platform_driver_register
Date:   Mon, 20 Jun 2022 14:51:18 +0200
Message-Id: <20220620124722.520291207@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124720.882450983@linuxfoundation.org>
References: <20220620124720.882450983@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 6ba12b56b9b844b83ed54fb7ed59fb0eb41e4045 ]

As platform_driver_register() could fail, it should be better
to deal with the return value in order to maintain the code
consisitency.

Fixes: 56a1485b102e ("i2c: npcm7xx: Add Nuvoton NPCM I2C controller driver")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Acked-by: Tali Perry <tali.perry1@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-npcm7xx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-npcm7xx.c b/drivers/i2c/busses/i2c-npcm7xx.c
index 20a2f903b7f6..d9ac62c1ac25 100644
--- a/drivers/i2c/busses/i2c-npcm7xx.c
+++ b/drivers/i2c/busses/i2c-npcm7xx.c
@@ -2369,8 +2369,7 @@ static struct platform_driver npcm_i2c_bus_driver = {
 static int __init npcm_i2c_init(void)
 {
 	npcm_i2c_debugfs_dir = debugfs_create_dir("npcm_i2c", NULL);
-	platform_driver_register(&npcm_i2c_bus_driver);
-	return 0;
+	return platform_driver_register(&npcm_i2c_bus_driver);
 }
 module_init(npcm_i2c_init);
 
-- 
2.35.1



