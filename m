Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BBAA537E82
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238286AbiE3Nsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238773AbiE3Np4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:45:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07CE8A006E;
        Mon, 30 May 2022 06:33:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C179BB80DB0;
        Mon, 30 May 2022 13:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0E5C385B8;
        Mon, 30 May 2022 13:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917609;
        bh=CHObYO3QTAakNe5T3Fe914iXUbpSy1aT88lWYZtUQ/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S3q611tMgYLwVVLXnM9npCzgnB+kWTRnFanJRgz5EzTXHwcCnbdDRD0Y76jxezlmR
         bdy9Fwj4euCd2j+L0Ho+znBLPTFSU+8q/dp4QTAoDIegI4IQTKcbaq8+CUbIp+/bN8
         9p1KQNOdxwoChcpVBAF6iJ/C9xBo1iwynFQ/6gMuazoG+oFOO5lvjqjbyIT0fmINZZ
         oSZ6yRZv3aFyKgvhqm6C79m0mj4AYRUDhfYxCv0vqFlPxxSNTDN1xMVavvzrK4NiBY
         JW3msTpLk9OxdGDjn6U9l1yAPFGPo6Rtji9NpuF0iBkWE2gBN1KYqmi+o1f4sde7Lv
         V40I5vBR8AetQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, dongchun.zhu@mediatek.com,
        linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 039/135] media: Revert "media: dw9768: activate runtime PM and turn off device"
Date:   Mon, 30 May 2022 09:29:57 -0400
Message-Id: <20220530133133.1931716-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 7dd0f93a31af03cba81c684c4c361bba510ffe71 ]

This reverts commit c09d776eaa060534a1663e3b89d842db3e1d9076.

Revert the commit as it breaks runtime PM support on OF based systems.
More fixes to the driver are needed.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Tomasz Figa <tfiga@chromium.org>
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/dw9768.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/media/i2c/dw9768.c b/drivers/media/i2c/dw9768.c
index 65c6acf3ced9..c086580efac7 100644
--- a/drivers/media/i2c/dw9768.c
+++ b/drivers/media/i2c/dw9768.c
@@ -469,11 +469,6 @@ static int dw9768_probe(struct i2c_client *client)
 
 	dw9768->sd.entity.function = MEDIA_ENT_F_LENS;
 
-	/*
-	 * Device is already turned on by i2c-core with ACPI domain PM.
-	 * Attempt to turn off the device to satisfy the privacy LED concerns.
-	 */
-	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 	if (!pm_runtime_enabled(dev)) {
 		ret = dw9768_runtime_resume(dev);
@@ -488,7 +483,6 @@ static int dw9768_probe(struct i2c_client *client)
 		dev_err(dev, "failed to register V4L2 subdev: %d", ret);
 		goto err_power_off;
 	}
-	pm_runtime_idle(dev);
 
 	return 0;
 
-- 
2.35.1

