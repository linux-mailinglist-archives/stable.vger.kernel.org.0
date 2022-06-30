Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DDA3561C7D
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:00:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235485AbiF3N7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:59:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236415AbiF3N6m (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:58:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9AE94163B;
        Thu, 30 Jun 2022 06:51:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2EBBB82AFA;
        Thu, 30 Jun 2022 13:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3347C34115;
        Thu, 30 Jun 2022 13:51:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597078;
        bh=Hv5XT+wihpAxWcKTmxWkBoWJWkQXIxwXbE/EI2bjpSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xhn6jJFAjAyJU1Tmh0ZTrIby0B5DlDF5klLeLKFQIgndg3J+pXG+uwfn+Awp1YDLG
         wNfchk+RxRq7xONqD2lmaGWIf+hKW/RFhe08H6SJeTExO0x9AIy7zVOJctHqls/hBE
         WkT5peYzPvaCHHARmdCrWQlRqVRy3Yf+sPrcGphQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 20/49] gpio: winbond: Fix error code in winbond_gpio_get()
Date:   Thu, 30 Jun 2022 15:46:33 +0200
Message-Id: <20220630133234.501028667@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
References: <20220630133233.910803744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 9ca766eaea2e87b8b773bff04ee56c055cb76d4e ]

This error path returns 1, but it should instead propagate the negative
error code from winbond_sio_enter().

Fixes: a0d65009411c ("gpio: winbond: Add driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-winbond.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-winbond.c b/drivers/gpio/gpio-winbond.c
index 7f8f5b02e31d..4b61d975cc0e 100644
--- a/drivers/gpio/gpio-winbond.c
+++ b/drivers/gpio/gpio-winbond.c
@@ -385,12 +385,13 @@ static int winbond_gpio_get(struct gpio_chip *gc, unsigned int offset)
 	unsigned long *base = gpiochip_get_data(gc);
 	const struct winbond_gpio_info *info;
 	bool val;
+	int ret;
 
 	winbond_gpio_get_info(&offset, &info);
 
-	val = winbond_sio_enter(*base);
-	if (val)
-		return val;
+	ret = winbond_sio_enter(*base);
+	if (ret)
+		return ret;
 
 	winbond_sio_select_logical(*base, info->dev);
 
-- 
2.35.1



