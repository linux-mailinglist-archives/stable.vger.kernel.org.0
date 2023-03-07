Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E713D6AEB4F
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:43:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbjCGRnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjCGRmr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:42:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C7395615B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:38:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 949DEB819B4
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C20FFC433EF;
        Tue,  7 Mar 2023 17:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210681;
        bh=2cd3LTHah5jdbR0rtPbY0tbZtnUjQXv83YwUDRxZjtI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FcVYH3bbKNRrrWQINyx3jMum/78R3W2DbDIOhCIIKh5Oo4ri8dSVMvuzN19uuH6zg
         pAk9fyrIx9AmU1kA2HiaNdd0eR0zrzPBBhwUVsnXtmQvnecVqlNEEhxRM6DHT0o4Hg
         wYzJabWnmjAWc+As/MhMLkWm95B8MKZS/B9Km56A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        coverity-bot <keescook+coverity-bot@chromium.org>,
        Marco Felsch <m.felsch@pengutronix.de>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0592/1001] media: i2c: tc358746: fix missing return assignment
Date:   Tue,  7 Mar 2023 17:56:04 +0100
Message-Id: <20230307170047.194446319@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marco Felsch <m.felsch@pengutronix.de>

[ Upstream commit 0605081142070a41de8f1deb8fdaeb8677e97741 ]

It was intended to return an error if tc358746_update_bits() call fail.
Fix this by storing the return code.

Addresses-Coverity-ID: 1527252 ("Control flow issues")

Reported-by: coverity-bot <keescook+coverity-bot@chromium.org>
Fixes: 80a21da36051 ("media: tc358746: add Toshiba TC358746 Parallel to CSI-2 bridge driver")
Signed-off-by: Marco Felsch <m.felsch@pengutronix.de>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/tc358746.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/tc358746.c b/drivers/media/i2c/tc358746.c
index d1f552bd81d42..e7f27cbb57907 100644
--- a/drivers/media/i2c/tc358746.c
+++ b/drivers/media/i2c/tc358746.c
@@ -406,7 +406,7 @@ tc358746_apply_pll_config(struct tc358746 *tc358746)
 
 	val = PLL_FRS(ilog2(post)) | RESETB | PLL_EN;
 	mask = PLL_FRS_MASK | RESETB | PLL_EN;
-	tc358746_update_bits(tc358746, PLLCTL1_REG, mask, val);
+	err = tc358746_update_bits(tc358746, PLLCTL1_REG, mask, val);
 	if (err)
 		return err;
 
-- 
2.39.2



