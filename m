Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95F136D2D46
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 03:48:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233927AbjDABrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 21:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233851AbjDABqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 21:46:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04B825564;
        Fri, 31 Mar 2023 18:44:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42814B83329;
        Sat,  1 Apr 2023 01:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECC4C433A7;
        Sat,  1 Apr 2023 01:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680313489;
        bh=JjqhrmssliB9UMb6aZhj/onWYIm2uhecqJn9FsHsqJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T3T9Nn+jSFgM115ZnAbXFNGTCztxFlA9Jp3rBDXoRAuaBuYQlQEfyd5My5GfgWzX8
         R5yCYvEE/EW+wUIAtgTaIwcHs/9xDCABnpOkGGnWHJRaWWHEJWp3YUmUhH1SNsvHUQ
         uHdUzA3BRNkeG057/cex6Lo61RnMSj+n5e6wm2LSaQMTT84eTECOv+eoMZAHup1Aet
         9mPY8eLgxTqfc+1X3hsbBRia6RRNfW28MWh6Kh01lPvIXQA/rI9JSZcBPm2tadIWKJ
         zv5LVT3oIMDh21bg7MZHeaBhsFiZ4VRbplB7LhFZQjTZAYtMt5gpKXiFXsrA8D8SEd
         lx7a3tCmJ/KeQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexander Stein <alexander.stein@ew.tq-group.com>,
        Emanuele Ghidoli <emanuele.ghidoli@toradex.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>,
        aisheng.dong@nxp.com, shawnguo@kernel.org,
        linux-i2c@vger.kernel.org, linux-imx@nxp.com,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.19 2/4] i2c: imx-lpi2c: clean rx/tx buffers upon new message
Date:   Fri, 31 Mar 2023 21:44:42 -0400
Message-Id: <20230401014444.3357427-2-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230401014444.3357427-1-sashal@kernel.org>
References: <20230401014444.3357427-1-sashal@kernel.org>
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
index 06c4c767af322..a4bd49625fad8 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -468,6 +468,8 @@ static int lpi2c_imx_xfer(struct i2c_adapter *adapter,
 		if (num == 1 && msgs[0].len == 0)
 			goto stop;
 
+		lpi2c_imx->rx_buf = NULL;
+		lpi2c_imx->tx_buf = NULL;
 		lpi2c_imx->delivered = 0;
 		lpi2c_imx->msglen = msgs[i].len;
 		init_completion(&lpi2c_imx->complete);
-- 
2.39.2

