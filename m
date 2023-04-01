Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 593C76D2D2A
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbjDABqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbjDABp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:45:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CF8921A81;
        Fri, 31 Mar 2023 18:44:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F309DB832F8;
        Sat,  1 Apr 2023 01:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0110C4331F;
        Sat,  1 Apr 2023 01:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313463;
        bh=FIpb+IZTNrNmVRIthAOtH7jjIfVoGtFEcLKUdkY52Nw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjsVOv9Fgd0VRk2ZuKv7GCPTTArMXr8NBusZ9Wzg7u+FdQp5MRHaGV0UGBEfDMGuJ
         wCvRqdiSwm11dVoDZlKSYVfGP553Ej2DNfvKKA6wBKzVpYa+39O0JEUhiLYqkpgDt0
         41AvdDtbqzAg10KYGljs4q/YMyDIK6wWCCZ7+DeIBPZxkJrfPwPbq4quiGliUl4pWz
         AjLXL2RlzD977zHtqephfU3XnmCovhOKgH9xOmn+RTkoa9xDeFsarZvDvCRX1pUU+j
         jPZvTl20LoLOkSjVKCZOC9/sqY9dksmMOl+oiWqdb4tGiPhnc/fKfdXmOQzEmnudL0
         xV89iYvB19AJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        aisheng.dong@nxp.com, shawnguo@kernel.org,
        linux-i2c@vger.kernel.org, linux-imx@nxp.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 3/7] i2c: imx-lpi2c: clean rx/tx buffers upon new message
Date:   Fri, 31 Mar 2023 21:44:13 -0400
Message-Id: <20230401014417.3357252-3-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014417.3357252-1-sashal@kernel.org>
References: <20230401014417.3357252-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 987dd36c0141f6ab9f0fbf14d6b2ec3342dedb2f ]

When start sending a new message clear the Rx & Tx buffer pointers in
order to avoid using stale pointers.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Tested-by: Emanuele Ghidoli <emanuele.ghidoli@toradex.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx-lpi2c.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/i2c/busses/i2c-imx-lpi2c.c b/drivers/i2c/busses/i2c-imx-lpi2c.c
index 8b9ba055c4186..aedd4150c25e5 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -462,6 +462,8 @@ static int lpi2c_imx_xfer(struct i2c_adapter *adapter,
 		if (num == 1 && msgs[0].len == 0)
 			goto stop;
 
+		lpi2c_imx->rx_buf = NULL;
+		lpi2c_imx->tx_buf = NULL;
 		lpi2c_imx->delivered = 0;
 		lpi2c_imx->msglen = msgs[i].len;
 		init_completion(&lpi2c_imx->complete);
-- 
2.39.2

