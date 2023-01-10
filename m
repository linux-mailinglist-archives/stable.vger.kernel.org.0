Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97276664966
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239269AbjAJSVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:21:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239108AbjAJSUY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:20:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE9413CD2
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:18:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBD2461871
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1E9C433F0;
        Tue, 10 Jan 2023 18:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374704;
        bh=WLIX9uZPuhQcg4fUGQpIkXpTrhlOfSrICHNVNQ/hrws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wttAczijABcgxvSPKn8U98IFm+yXFIJRldO/xLAnh9snuY4n5HXLQ8ftXKR49RnvQ
         Zndrve5kOitbEU10mSl9f0ArvjRtgYb8Xyk989kKowgEYQixA28hCabmKkNH8JZ1m7
         7Msh2q3d6jt4ncOTEzVDQyThVlQsiL1HNATKS52g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Haibo Chen <haibo.chen@nxp.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/159] gpio: pca953x: avoid to use uninitialized value pinctrl
Date:   Tue, 10 Jan 2023 19:03:43 +0100
Message-Id: <20230110180020.696706051@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

[ Upstream commit 90fee3dd5bfc1b9f4c8c0ba6cd2a35c9d79ca4de ]

There is a variable pinctrl declared without initializer. And then
has the case (switch operation chose the default case) to directly
use this uninitialized value, this is not a safe behavior. So here
initialize the pinctrl as 0 to avoid this issue.
This is reported by Coverity.

Fixes: 13c5d4ce8060 ("gpio: pca953x: Add support for PCAL6534")
Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-pca953x.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index ebe1943b85dd..bf21803a0036 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -473,6 +473,9 @@ static u8 pcal6534_recalc_addr(struct pca953x_chip *chip, int reg, int off)
 	case PCAL6524_DEBOUNCE:
 		pinctrl = ((reg & PCAL_PINCTRL_MASK) >> 1) + 0x1c;
 		break;
+	default:
+		pinctrl = 0;
+		break;
 	}
 
 	return pinctrl + addr + (off / BANK_SZ);
-- 
2.35.1



