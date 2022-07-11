Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62E1556FA7F
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiGKJSe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:18:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbiGKJSB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:18:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3C511C2C;
        Mon, 11 Jul 2022 02:11:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 774DFB80D2C;
        Mon, 11 Jul 2022 09:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE929C34115;
        Mon, 11 Jul 2022 09:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530696;
        bh=ZG3Rwy9JP7agOxmwR8S1bH1vQXy48ESdKQsRF6M9y7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vqeyddb/008She3tovImfeaz7cjO8Cp0fH6UbsDJnGmKhEmdBiPeIeHCjU1gEN212
         4fa7NjQa4WZEynegkXHbdQWG0NPBKP9M+ZEceNMh0a7crofylRseWwIy094hDWYuuC
         sZfo4htBXrCYXkCV6SbnzXH0TeE+8VhFyi40HXNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Satish Nagireddy <satish.nagireddy@getcruise.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@amd.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 28/38] i2c: cadence: Unregister the clk notifier in error path
Date:   Mon, 11 Jul 2022 11:07:10 +0200
Message-Id: <20220711090539.558704008@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
References: <20220711090538.722676354@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Satish Nagireddy <satish.nagireddy@getcruise.com>

[ Upstream commit 3501f0c663063513ad604fb1b3f06af637d3396d ]

This patch ensures that the clock notifier is unregistered
when driver probe is returning error.

Fixes: df8eb5691c48 ("i2c: Add driver for Cadence I2C controller")
Signed-off-by: Satish Nagireddy <satish.nagireddy@getcruise.com>
Tested-by: Lars-Peter Clausen <lars@metafoo.de>
Reviewed-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-cadence.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index 8a3a0991bc1c..3a1bdc75275f 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -985,6 +985,7 @@ static int cdns_i2c_probe(struct platform_device *pdev)
 	return 0;
 
 err_clk_dis:
+	clk_notifier_unregister(id->clk, &id->clk_rate_change_nb);
 	clk_disable_unprepare(id->clk);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.35.1



