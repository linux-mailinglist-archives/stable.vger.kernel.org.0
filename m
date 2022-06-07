Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6CE5540B9E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350854AbiFGS3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352553AbiFGS0R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:26:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 891CD16F91D;
        Tue,  7 Jun 2022 10:54:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3D276CE2422;
        Tue,  7 Jun 2022 17:54:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57053C3411C;
        Tue,  7 Jun 2022 17:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624473;
        bh=PGpBVVFXYWAfjYtRkA7TYJ3yh3f7UZ35lMQ9PxdCqxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWPETTRJmu7Ot8nnJsMH8nXwvy50aoxWBtxCaX9htEO7LGSfN/exiP5sa8KoKYtTd
         G6seW6XdpmN1mdcslO2gMWdOlLRR/xp8qEWESEU55ipvzpkqckz/e7I/8K9mRgt+Db
         ETddn7/TKKa/AA0P25xeTI4AZFNU1926EjrxbAYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 339/667] media: i2c: ov5648: fix wrong pointer passed to IS_ERR() and PTR_ERR()
Date:   Tue,  7 Jun 2022 19:00:04 +0200
Message-Id: <20220607164944.931757902@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit a6dd5265c21c28d0a782befe41a97c347e78f22f ]

IS_ERR() and PTR_ERR() use wrong pointer, it should be
sensor->dovdd, fix it.

Fixes: e43ccb0a045f ("media: i2c: Add support for the OV5648 image sensor")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov5648.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/i2c/ov5648.c b/drivers/media/i2c/ov5648.c
index ef8b52dc9401..bb3666fc5618 100644
--- a/drivers/media/i2c/ov5648.c
+++ b/drivers/media/i2c/ov5648.c
@@ -2498,9 +2498,9 @@ static int ov5648_probe(struct i2c_client *client)
 
 	/* DOVDD: digital I/O */
 	sensor->dovdd = devm_regulator_get(dev, "dovdd");
-	if (IS_ERR(sensor->dvdd)) {
+	if (IS_ERR(sensor->dovdd)) {
 		dev_err(dev, "cannot get DOVDD (digital I/O) regulator\n");
-		ret = PTR_ERR(sensor->dvdd);
+		ret = PTR_ERR(sensor->dovdd);
 		goto error_endpoint;
 	}
 
-- 
2.35.1



