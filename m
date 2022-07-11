Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E69E56FAE0
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231627AbiGKJXJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:23:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231959AbiGKJWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:22:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CBE5C356;
        Mon, 11 Jul 2022 02:13:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 84A7E61188;
        Mon, 11 Jul 2022 09:13:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63EE7C34115;
        Mon, 11 Jul 2022 09:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530806;
        bh=ddvnf/kpXr5ctM8ugEd/957e7Vj5A8FhBl6VTjMoKys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8z0QxZjlmOFDuMPD+tIQ9PqjRk55LKd99aEK2GwY9uxDDXCAJk8bBqk77mR3na6g
         92jV3dy6l9X3V7hAOoiypR9Adl4y771EEeblo1+89UqxNMhCRKANYZFAxl3bN5nwB4
         5oC5tMCu+NkEOuSCJynO8ET4vihtnqU28kd94YTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Satish Nagireddy <satish.nagireddy@getcruise.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@amd.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 45/55] i2c: cadence: Unregister the clk notifier in error path
Date:   Mon, 11 Jul 2022 11:07:33 +0200
Message-Id: <20220711090543.084972317@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090541.764895984@linuxfoundation.org>
References: <20220711090541.764895984@linuxfoundation.org>
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
index 50e3ddba52ba..01564bd96c62 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -1289,6 +1289,7 @@ static int cdns_i2c_probe(struct platform_device *pdev)
 	return 0;
 
 err_clk_dis:
+	clk_notifier_unregister(id->clk, &id->clk_rate_change_nb);
 	clk_disable_unprepare(id->clk);
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
-- 
2.35.1



