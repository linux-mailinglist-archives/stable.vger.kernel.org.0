Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B8B501157
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245647AbiDNNnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244990AbiDNN2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:28:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF62CA88BA;
        Thu, 14 Apr 2022 06:21:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CC4DB82910;
        Thu, 14 Apr 2022 13:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3EC2C385A5;
        Thu, 14 Apr 2022 13:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942485;
        bh=KBgLSDBc//2y/L9zqSx0+5aitd2ZUJZnb7pq1fsgObs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dXaaetlXBYWVwypwjMNOFWuDlxMF0IE+tb0gzTcF3CSHh+3+0RuFpNwTUs1wm5YUq
         wFv4T+sVB6Fc+d5hrooWjcVFRTG5KH3eATWwkHE538xjZqM5qjNk3OsYouZrL8b5/r
         2luNcY/JZXsWrlIsfWDNAyRyKiikfsS1kMgupA3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wang Wensheng <wangwensheng4@huawei.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 112/338] ASoC: imx-es8328: Fix error return code in imx_es8328_probe()
Date:   Thu, 14 Apr 2022 15:10:15 +0200
Message-Id: <20220414110842.096790841@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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

From: Wang Wensheng <wangwensheng4@huawei.com>

[ Upstream commit 3b891513f95cba3944e72c1139ea706d04f3781b ]

Fix to return a negative error code from the error handling case instead
of 0, as done elsewhere in this function.

Fixes: 7e7292dba215 ("ASoC: fsl: add imx-es8328 machine driver")
Signed-off-by: Wang Wensheng <wangwensheng4@huawei.com>
Link: https://lore.kernel.org/r/20220310091902.129299-1-wangwensheng4@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/imx-es8328.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/fsl/imx-es8328.c b/sound/soc/fsl/imx-es8328.c
index 9953438086e4..735693274f49 100644
--- a/sound/soc/fsl/imx-es8328.c
+++ b/sound/soc/fsl/imx-es8328.c
@@ -93,6 +93,7 @@ static int imx_es8328_probe(struct platform_device *pdev)
 	if (int_port > MUX_PORT_MAX || int_port == 0) {
 		dev_err(dev, "mux-int-port: hardware only has %d mux ports\n",
 			MUX_PORT_MAX);
+		ret = -EINVAL;
 		goto fail;
 	}
 
-- 
2.34.1



