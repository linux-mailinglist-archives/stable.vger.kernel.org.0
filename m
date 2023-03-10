Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3819B6B459E
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbjCJOfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbjCJOfQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:35:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97824F8288
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:35:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 325D3617B4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C214C433EF;
        Fri, 10 Mar 2023 14:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458914;
        bh=62Va43WyIwFWayLo4X1uRfTfWTCYOcpNilVJO4COQEA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bgz7AQEvYUuyyYUof1Bwj00UWJWnhST3P6q8Y+jnzPPYuJe6CDXQP+tr29SpEORja
         SD0HECQveqMWZfQMAtdmpSFn8MoGb4W3mT7dr9a2yYbFItrh4yxev/tUoljdC5C1Ss
         Mi+FbikDKxUDKnTyHv053WSiJ4/WgJqvc3vwKSuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luca Ellero <l.ellero@asem.it>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 155/357] Input: ads7846 - dont check penirq immediately for 7845
Date:   Fri, 10 Mar 2023 14:37:24 +0100
Message-Id: <20230310133741.551839434@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luca Ellero <l.ellero@asem.it>

[ Upstream commit fa9f4275b20ec7b2a8fb05c66362d10b36f9efec ]

To discard false readings, one should use "ti,penirq-recheck-delay-usecs".
Checking get_pendown_state() at the beginning, most of the time fails
causing malfunctioning.

Fixes: ffa458c1bd9b ("spi: ads7846 driver")
Signed-off-by: Luca Ellero <l.ellero@asem.it>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230126105227.47648-4-l.ellero@asem.it
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ads7846.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index feaacd86d19e4..0506115211dd4 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -790,14 +790,8 @@ static void ads7846_report_state(struct ads7846 *ts)
 	if (x == MAX_12BIT)
 		x = 0;
 
-	if (ts->model == 7843) {
+	if (ts->model == 7843 || ts->model == 7845) {
 		Rt = ts->pressure_max / 2;
-	} else if (ts->model == 7845) {
-		if (get_pendown_state(ts))
-			Rt = ts->pressure_max / 2;
-		else
-			Rt = 0;
-		dev_vdbg(&ts->spi->dev, "x/y: %d/%d, PD %d\n", x, y, Rt);
 	} else if (likely(x && z1)) {
 		/* compute touch pressure resistance using equation #2 */
 		Rt = z2;
-- 
2.39.2



