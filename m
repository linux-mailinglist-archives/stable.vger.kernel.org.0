Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735385939E6
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241552AbiHOT3H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245158AbiHOTZq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:25:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF4583DF17;
        Mon, 15 Aug 2022 11:41:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6FF42B81084;
        Mon, 15 Aug 2022 18:41:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B526DC433D6;
        Mon, 15 Aug 2022 18:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588871;
        bh=0rSuf08xxpAs4juZrf9DdyilhYifmFUsrkyHzwVov84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+wrWl8B69DrdwxxvJ7hZDxYWd2fEM78hHJDJZbGr1THXLbRJqGWtuOmFmxGlrfM6
         3fjjxDf8+xRGbka6Cen0+3xWvTyxE8ZQLuJZI6hJ+T/177HU15K0iDzB3LOC/h1/Xr
         sCKBYplpabkko6qTi2KIf5BNkUvN173MCN9xJY+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Robert Richter <rric@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 524/779] mmc: cavium-octeon: Add of_node_put() when breaking out of loop
Date:   Mon, 15 Aug 2022 20:02:48 +0200
Message-Id: <20220815180359.662011987@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Liang He <windhl@126.com>

[ Upstream commit 19bbb49acf8d7a03cb83e05624363741a4c3ec6f ]

In octeon_mmc_probe(), we should call of_node_put() when breaking
out of for_each_child_of_node() which has increased and decreased
the refcount during each iteration.

Fixes: 01d95843335c ("mmc: cavium: Add MMC support for Octeon SOCs.")
Signed-off-by: Liang He <windhl@126.com>
Acked-by: Robert Richter <rric@kernel.org>
Link: https://lore.kernel.org/r/20220719095216.1241601-1-windhl@126.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/cavium-octeon.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/cavium-octeon.c b/drivers/mmc/host/cavium-octeon.c
index 2c4b2df52adb..12dca91a8ef6 100644
--- a/drivers/mmc/host/cavium-octeon.c
+++ b/drivers/mmc/host/cavium-octeon.c
@@ -277,6 +277,7 @@ static int octeon_mmc_probe(struct platform_device *pdev)
 		if (ret) {
 			dev_err(&pdev->dev, "Error populating slots\n");
 			octeon_mmc_set_shared_power(host, 0);
+			of_node_put(cn);
 			goto error;
 		}
 		i++;
-- 
2.35.1



