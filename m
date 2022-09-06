Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CECDD5AEBAD
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbiIFOKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240187AbiIFOIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:08:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F9385FBF;
        Tue,  6 Sep 2022 06:45:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C1C061548;
        Tue,  6 Sep 2022 13:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CBCFC433D7;
        Tue,  6 Sep 2022 13:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471945;
        bh=KvyQhflTjblQPyR9dYESvlbdaPju0Rt5R9cprg1dQaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SBoLA+xE9+n0ZD2A8sfpV5w5fg92rxRVk5EG9VjTvjpI1T70jTRFYfPUy2+xp1z8d
         MPNG0kZEJAg5y6OhULD1p6KeyrSEeqG5FZ5He9DG88A90P5K+Yzx4ec9B6MQOT/0TH
         Hz63UBj3W3aAjJFLYnX+yJWeDs3fzMJ79yVbFkB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Ivan T. Ivanov" <iivanov@suse.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 093/155] clk: bcm: rpi: Prevent out-of-bounds access
Date:   Tue,  6 Sep 2022 15:30:41 +0200
Message-Id: <20220906132833.388960769@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Stefan Wahren <stefan.wahren@i2se.com>

[ Upstream commit bc163555603e4ae9c817675ad80d618a4cdbfa2d ]

The while loop in raspberrypi_discover_clocks() relies on the assumption
that the id of the last clock element is zero. Because this data comes
from the Videocore firmware and it doesn't guarantuee such a behavior
this could lead to out-of-bounds access. So fix this by providing
a sentinel element.

Fixes: 93d2725affd6 ("clk: bcm: rpi: Discover the firmware clocks")
Link: https://github.com/raspberrypi/firmware/issues/1688
Suggested-by: Phil Elwell <phil@raspberrypi.com>
Signed-off-by: Stefan Wahren <stefan.wahren@i2se.com>
Link: https://lore.kernel.org/r/20220713154953.3336-2-stefan.wahren@i2se.com
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Ivan T. Ivanov <iivanov@suse.de>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/bcm/clk-raspberrypi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/bcm/clk-raspberrypi.c b/drivers/clk/bcm/clk-raspberrypi.c
index 39d63c983d62c..e495f5f382ab9 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -344,8 +344,13 @@ static int raspberrypi_discover_clocks(struct raspberrypi_clk *rpi,
 	struct rpi_firmware_get_clocks_response *clks;
 	int ret;
 
+	/*
+	 * The firmware doesn't guarantee that the last element of
+	 * RPI_FIRMWARE_GET_CLOCKS is zeroed. So allocate an additional
+	 * zero element as sentinel.
+	 */
 	clks = devm_kcalloc(rpi->dev,
-			    RPI_FIRMWARE_NUM_CLK_ID, sizeof(*clks),
+			    RPI_FIRMWARE_NUM_CLK_ID + 1, sizeof(*clks),
 			    GFP_KERNEL);
 	if (!clks)
 		return -ENOMEM;
-- 
2.35.1



