Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B360603E22
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232647AbiJSJK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbiJSJIx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:08:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31232124C;
        Wed, 19 Oct 2022 02:00:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 196336186A;
        Wed, 19 Oct 2022 08:59:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4EDC433D6;
        Wed, 19 Oct 2022 08:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169940;
        bh=JzLGeM6MnEL8NtCa+37sOxVlXwkKAQTWwUnH0CUDFaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PN11t2IrZSkKqsGSImnrX3SNXe4m0HJhZDQohGpj37xA2C2g45BSIaDWlYSkoC1Au
         hK8oqcpajz5UHKyHJltWU7BzAcoGpnHihaf3TiB2/kbaH6kd0bznhyIlDmiGuYcWb6
         r+7eyUkHe9Mt/HYxwBsphqXAoPEn3dcFScC64E3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 466/862] usb: common: usb-conn-gpio: Simplify some error message
Date:   Wed, 19 Oct 2022 10:29:13 +0200
Message-Id: <20221019083310.563809290@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d80f4ecb95270d0ecd6646aca44f4c180d3140b0 ]

dev_err_probe() already prints the error code in a human readable way, so
there is no need to duplicate it as a numerical value at the end of the
message.

Reviewed-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/7505a9dfa1e097070c492d6f6f84afa2a490b040.1659763173.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b6155eaf6b05 ("usb: common: debug: Check non-standard control requests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/common/usb-conn-gpio.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/common/usb-conn-gpio.c b/drivers/usb/common/usb-conn-gpio.c
index b39c9f1c375d..e20874caba36 100644
--- a/drivers/usb/common/usb-conn-gpio.c
+++ b/drivers/usb/common/usb-conn-gpio.c
@@ -208,10 +208,8 @@ static int usb_conn_probe(struct platform_device *pdev)
 	if (PTR_ERR(info->vbus) == -ENODEV)
 		info->vbus = NULL;
 
-	if (IS_ERR(info->vbus)) {
-		ret = PTR_ERR(info->vbus);
-		return dev_err_probe(dev, ret, "failed to get vbus :%d\n", ret);
-	}
+	if (IS_ERR(info->vbus))
+		return dev_err_probe(dev, PTR_ERR(info->vbus), "failed to get vbus\n");
 
 	info->role_sw = usb_role_switch_get(dev);
 	if (IS_ERR(info->role_sw))
-- 
2.35.1



