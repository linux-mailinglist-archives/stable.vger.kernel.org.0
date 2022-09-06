Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7244F5AE9F1
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 15:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240639AbiIFNfz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 09:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240680AbiIFNfS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 09:35:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FAD76766;
        Tue,  6 Sep 2022 06:33:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4CFE761545;
        Tue,  6 Sep 2022 13:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E0B6C433C1;
        Tue,  6 Sep 2022 13:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471227;
        bh=zymJlPrCaPCmih25Es7c22qtTFc8tp9e2wy4ZVY4I9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vXet3YWkeu66aQha9U462Uzp52IDaIbjTMjyueoXN6fFaN3PO+sV7BEfHcqG1m1al
         lDnxrR3zj8VmDIh4BVRCfgNLDqO0qvRX8YSkZS8mZrbMqqsdPv9uPiouOWCFa77h1I
         WPde31lrjvyxMLDSyDgCYL/oQ7ZXvfoGB84SDXcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Ivan T. Ivanov" <iivanov@suse.de>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/80] clk: bcm: rpi: Prevent out-of-bounds access
Date:   Tue,  6 Sep 2022 15:30:37 +0200
Message-Id: <20220906132818.672622344@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132816.936069583@linuxfoundation.org>
References: <20220906132816.936069583@linuxfoundation.org>
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
index ff87305cbe9d9..27ae08c4952e7 100644
--- a/drivers/clk/bcm/clk-raspberrypi.c
+++ b/drivers/clk/bcm/clk-raspberrypi.c
@@ -251,8 +251,13 @@ static int raspberrypi_discover_clocks(struct raspberrypi_clk *rpi,
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



