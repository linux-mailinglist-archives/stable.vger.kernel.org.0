Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2099540DE4
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:52:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354656AbiFGSvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:51:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354559AbiFGSrI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:47:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22BC5DD1F;
        Tue,  7 Jun 2022 11:02:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BC5761804;
        Tue,  7 Jun 2022 18:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9068DC341C0;
        Tue,  7 Jun 2022 18:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624930;
        bh=XAGJ6U13VmkrVh5Zc7zRwbkmBQUzO0nmuegqfoYHRKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PsI29JOCn7k/UB5WmLepI8rlcHxzyF1oDsXM1TcQMqABSRCxWOXxgFqIGjJhV/I6a
         tMzFd8TGTOz3ClzaMIdkEbExxCMzLk5VxpttHuuRBmsbF8HW7XH6B/gH/b1I1bgaQz
         kD6oClvX0bNfvdyNICzJJOQ04m9IlXXYcbYLdPRs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tyrone Ting <kfting@nuvoton.com>,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 505/667] i2c: npcm: Correct register access width
Date:   Tue,  7 Jun 2022 19:02:50 +0200
Message-Id: <20220607164949.847757337@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tyrone Ting <kfting@nuvoton.com>

[ Upstream commit ea9f8426d17620214ee345ffb77ee6cc196ff14f ]

The SMBnCTL3 register is 8-bit wide and the 32-bit access was always
incorrect, but simply didn't cause a visible error on the 32-bit machine.

On the 64-bit machine, the kernel message reports that ESR value is
0x96000021. Checking Arm Architecture Reference Manual Armv8 suggests that
it's the alignment fault.

SMBnCTL3's address is 0xE.

Fixes: 56a1485b102e ("i2c: npcm7xx: Add Nuvoton NPCM I2C controller driver")
Signed-off-by: Tyrone Ting <kfting@nuvoton.com>
Reviewed-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-npcm7xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-npcm7xx.c b/drivers/i2c/busses/i2c-npcm7xx.c
index 92fd88a3f415..cdea7f440a9e 100644
--- a/drivers/i2c/busses/i2c-npcm7xx.c
+++ b/drivers/i2c/busses/i2c-npcm7xx.c
@@ -359,14 +359,14 @@ static int npcm_i2c_get_SCL(struct i2c_adapter *_adap)
 {
 	struct npcm_i2c *bus = container_of(_adap, struct npcm_i2c, adap);
 
-	return !!(I2CCTL3_SCL_LVL & ioread32(bus->reg + NPCM_I2CCTL3));
+	return !!(I2CCTL3_SCL_LVL & ioread8(bus->reg + NPCM_I2CCTL3));
 }
 
 static int npcm_i2c_get_SDA(struct i2c_adapter *_adap)
 {
 	struct npcm_i2c *bus = container_of(_adap, struct npcm_i2c, adap);
 
-	return !!(I2CCTL3_SDA_LVL & ioread32(bus->reg + NPCM_I2CCTL3));
+	return !!(I2CCTL3_SDA_LVL & ioread8(bus->reg + NPCM_I2CCTL3));
 }
 
 static inline u16 npcm_i2c_get_index(struct npcm_i2c *bus)
-- 
2.35.1



