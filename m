Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6268E582FDC
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242224AbiG0Ra3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:30:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242313AbiG0R3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:29:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A45A52470;
        Wed, 27 Jul 2022 09:47:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E3833B821C5;
        Wed, 27 Jul 2022 16:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4403FC43470;
        Wed, 27 Jul 2022 16:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940454;
        bh=EEAxF3Db0LOQhyP5PX4UY1J0DpmdkZYOZ7FetD1luY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uoW3JrIcaJUGlVIDKRXVdWG6TYrY3fhUIhsZSyH2kN9Fh6T2VSalNj8/EGA+3FVmR
         HLqSn13+GsCSDT01J9ngoXMbeLoyKUhih3UJoc0z79/57hrOxTcSaDV6uC9J6k7PU9
         hotDGvttvvF4eiv3bD1py7y0+xYCR4yYFgKOI0Wo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hacash Robot <hacashRobot@santino.com>,
        William Dean <williamsukatube@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 028/158] pinctrl: sunplus: Add check for kcalloc
Date:   Wed, 27 Jul 2022 18:11:32 +0200
Message-Id: <20220727161022.598871762@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Dean <williamsukatube@gmail.com>

[ Upstream commit acf50233fc979b566e3b87d329191dcd01e2a72c ]

As the potential failure of the kcalloc(),
it should be better to check it in order to
avoid the dereference of the NULL pointer.

Fixes: aa74c44be19c8 ("pinctrl: Add driver for Sunplus SP7021")
Reported-by: Hacash Robot <hacashRobot@santino.com>
Signed-off-by: William Dean <williamsukatube@gmail.com>
Link: https://lore.kernel.org/r/20220710154822.2610801-1-williamsukatube@163.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sunplus/sppctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/sunplus/sppctl.c b/drivers/pinctrl/sunplus/sppctl.c
index 3ba47040ac42..2b3335ab56c6 100644
--- a/drivers/pinctrl/sunplus/sppctl.c
+++ b/drivers/pinctrl/sunplus/sppctl.c
@@ -871,6 +871,9 @@ static int sppctl_dt_node_to_map(struct pinctrl_dev *pctldev, struct device_node
 	}
 
 	*map = kcalloc(*num_maps + nmG, sizeof(**map), GFP_KERNEL);
+	if (*map == NULL)
+		return -ENOMEM;
+
 	for (i = 0; i < (*num_maps); i++) {
 		dt_pin = be32_to_cpu(list[i]);
 		pin_num = FIELD_GET(GENMASK(31, 24), dt_pin);
-- 
2.35.1



