Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A90B56F9B2
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbiGKJHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229897AbiGKJHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:07:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B112422B1E;
        Mon, 11 Jul 2022 02:07:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4F8D161188;
        Mon, 11 Jul 2022 09:07:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7EDC34115;
        Mon, 11 Jul 2022 09:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530434;
        bh=XD998FoUy+aewdU9KTZ9JC7PXHfD2tl8I1AX7k+wJ/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nsmcR7gtxU7X8HgmYnyx+mDaVltxctX1L+1hEV/PBCErFU+KUl7QQreBfsL/6qkrd
         a9e6keAqWuDJeDULgMPkzC8U7PrHn1zOL/iLVEkrpHgXJg/au9fI+Af38VdEF+UUug
         MA59+DPm16khWFdctOePHzFXqjJI4MPqDC/3s6nE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Satish Nagireddy <satish.nagireddy@getcruise.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@amd.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 10/14] i2c: cadence: Unregister the clk notifier in error path
Date:   Mon, 11 Jul 2022 11:06:29 +0200
Message-Id: <20220711090535.824091103@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090535.517697227@linuxfoundation.org>
References: <20220711090535.517697227@linuxfoundation.org>
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
 drivers/i2c/busses/i2c-cadence.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -992,6 +992,7 @@ static int cdns_i2c_probe(struct platfor
 	return 0;
 
 err_clk_dis:
+	clk_notifier_unregister(id->clk, &id->clk_rate_change_nb);
 	clk_disable_unprepare(id->clk);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);


