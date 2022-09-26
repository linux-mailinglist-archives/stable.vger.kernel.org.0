Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6865EA466
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:46:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238462AbiIZLpx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238248AbiIZLml (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:42:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B62BD726B8;
        Mon, 26 Sep 2022 03:46:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EBE95B80924;
        Mon, 26 Sep 2022 10:33:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F901C433D7;
        Mon, 26 Sep 2022 10:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188388;
        bh=zm91d3VKnzAezy3Obx9BDlw9gyCWzfFCaOa9sB9Etog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U67hgP7TT2Rq5B3oaQ1TGMDl07Sl+NPe14WIK3+lesABQ+ZMz8ZweftD7dbtYX6vd
         brjvZuY6KJYlw5rRMvVULbsmzexd0UWluFi0sugLPtnKj6v6V0HUogu839uuZTs7J8
         H4o0NI20gX/K7nPPJj2KGDoLORKB9PgiTllVhMWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/141] i2c: imx: If pm_runtime_get_sync() returned 1 device access is possible
Date:   Mon, 26 Sep 2022 12:12:40 +0200
Message-Id: <20220926100759.306970082@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 085aacaa73163f4b8a89dec24ecb32cfacd34017 ]

pm_runtime_get_sync() returning 1 also means the device is powered. So
resetting the chip registers in .remove() is possible and should be
done.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: d98bdd3a5b50 ("i2c: imx: Make sure to unregister adapter on remove()")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index d3719df1c40d..be4ad516293b 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1289,7 +1289,7 @@ static int i2c_imx_remove(struct platform_device *pdev)
 	if (i2c_imx->dma)
 		i2c_imx_dma_free(i2c_imx);
 
-	if (ret == 0) {
+	if (ret >= 0) {
 		/* setup chip registers to defaults */
 		imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IADR);
 		imx_i2c_write_reg(0, i2c_imx, IMX_I2C_IFDR);
-- 
2.35.1



