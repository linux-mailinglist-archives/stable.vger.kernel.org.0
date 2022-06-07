Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33C5F540A3C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350941AbiFGSSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351557AbiFGSQ1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:16:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D491660A8;
        Tue,  7 Jun 2022 10:49:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2020061732;
        Tue,  7 Jun 2022 17:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED78C385A5;
        Tue,  7 Jun 2022 17:49:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624181;
        bh=6dAOYreJ7WHqoN0E30JPou5RoconiYs6xnWg+lEaCmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VEk1g0akvPPGO858kRsEHBMfxjKfxa1bNUJmAqDlBfjWKlnNfI4u5n3RTPgr1xwCZ
         T/c9bLxg+05/o6vDa6mPqyc6G725jB7+lq3MstNoNA46AGGU7pI5cKTWR79eBYtlg2
         NlmARSU0oJLzWCPzUuK/bTN0SGCYETaZ5NbyuWqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        "Niklas S \ xF6derlund" <niklas.soderlund+renesas@ragnatech.se>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 235/667] media: i2c: max9286: Use dev_err_probe() helper
Date:   Tue,  7 Jun 2022 18:58:20 +0200
Message-Id: <20220607164941.833728558@linuxfoundation.org>
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

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit df78b858e773967112b4444400fb7bb5bd7a9d8a ]

Use the dev_err_probe() helper, instead of open-coding the same
operation. While at it retrieve the error once and use it from
'ret' instead of retrieving it twice.

Link: https://lore.kernel.org/linux-media/20211208121756.3051565-1-niklas.soderlund+renesas@ragnatech.se
Suggested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Niklas S\xF6derlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/max9286.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/media/i2c/max9286.c b/drivers/media/i2c/max9286.c
index 1aa2c58fd38c..1bbcc46fffd5 100644
--- a/drivers/media/i2c/max9286.c
+++ b/drivers/media/i2c/max9286.c
@@ -1296,11 +1296,9 @@ static int max9286_probe(struct i2c_client *client)
 
 	priv->regulator = devm_regulator_get(&client->dev, "poc");
 	if (IS_ERR(priv->regulator)) {
-		if (PTR_ERR(priv->regulator) != -EPROBE_DEFER)
-			dev_err(&client->dev,
-				"Unable to get PoC regulator (%ld)\n",
-				PTR_ERR(priv->regulator));
 		ret = PTR_ERR(priv->regulator);
+		dev_err_probe(&client->dev, ret,
+			      "Unable to get PoC regulator\n");
 		goto err_powerdown;
 	}
 
-- 
2.35.1



