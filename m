Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D72C68D8C6
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbjBGNNE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbjBGNMr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:12:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EACC793ED
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:11:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8B086143D
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:11:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9547C433D2;
        Tue,  7 Feb 2023 13:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775472;
        bh=Tql21/U+HBWrQXbGKOoeuk87rFXHzfmJddhkYWlpJFY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKaiFoJ/FijHpaQqvjVJBiAVsOhpgnEJA9FrrSouYvaluuqUksiKc4WO4znGgsstR
         3sbhSAU4VFZGiR6WmTDKZHayy9Ty/DdJrYrR31rF/5t9ohSYHWKSUuApC/LjjyQB7D
         rJcHcoXDh4HtlkqkLop/UAMUQXeIzfLduMomYXJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stefan Wahren <stefan.wahren@i2se.com>,
        Fabio Estevam <festevam@gmail.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 052/120] i2c: mxs: suppress probe-deferral error message
Date:   Tue,  7 Feb 2023 13:57:03 +0100
Message-Id: <20230207125620.989702253@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit 78a4471fa1a76a8bef4919105de67660a89a1e9b ]

During boot of I2SE Duckbill the kernel log contains a
confusing error:

  Failed to request dma

This is caused by i2c-mxs tries to request a not yet available DMA
channel (-EPROBE_DEFER). So suppress this message by using
dev_err_probe().

Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mxs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index 68f67d084c63..b353732f593b 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -826,8 +826,8 @@ static int mxs_i2c_probe(struct platform_device *pdev)
 	/* Setup the DMA */
 	i2c->dmach = dma_request_chan(dev, "rx-tx");
 	if (IS_ERR(i2c->dmach)) {
-		dev_err(dev, "Failed to request dma\n");
-		return PTR_ERR(i2c->dmach);
+		return dev_err_probe(dev, PTR_ERR(i2c->dmach),
+				     "Failed to request dma\n");
 	}
 
 	platform_set_drvdata(pdev, i2c);
-- 
2.39.0



