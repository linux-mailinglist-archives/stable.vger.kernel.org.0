Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4CCC66C6BB
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbjAPQYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:24:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233052AbjAPQXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:23:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368D72A9B1
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:12:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A897BB81060
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1796CC433F0;
        Mon, 16 Jan 2023 16:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673885572;
        bh=UFVSMEluSimBVWnAzAFm8/z9GKq6wSrJmfTcgmBljNY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qSpIpuAIO2nvFrArfpCRBCMrZhdR38hPqyB9V0R04QC8kFQTtkhuPxjxrShaywpPW
         eLRN8tP7GS3VX88kZGq5BDLYLvi5dmy8UAfclsHRLAgwwQe1rJubADo0cwqF2P8G5P
         ciYt8hK89U8YMKowE7SYjWtzXLNl0sGiri0HYlj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Ricardo Ribalda <ribalda@chromium.org>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 103/658] media: i2c: ad5820: Fix error path
Date:   Mon, 16 Jan 2023 16:43:11 +0100
Message-Id: <20230116154914.243031653@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 9fce241660f37d9e95e93c0ae6fba8cfefa5797b ]

Error path seems to be swaped. Fix the order and provide some meaningful
names.

Fixes: bee3d5115611 ("[media] ad5820: Add driver for auto-focus coil")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ad5820.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ad5820.c b/drivers/media/i2c/ad5820.c
index 7a49651f4d1f..d7d85edeedd5 100644
--- a/drivers/media/i2c/ad5820.c
+++ b/drivers/media/i2c/ad5820.c
@@ -314,18 +314,18 @@ static int ad5820_probe(struct i2c_client *client,
 
 	ret = media_entity_pads_init(&coil->subdev.entity, 0, NULL);
 	if (ret < 0)
-		goto cleanup2;
+		goto clean_mutex;
 
 	ret = v4l2_async_register_subdev(&coil->subdev);
 	if (ret < 0)
-		goto cleanup;
+		goto clean_entity;
 
 	return ret;
 
-cleanup2:
-	mutex_destroy(&coil->power_lock);
-cleanup:
+clean_entity:
 	media_entity_cleanup(&coil->subdev.entity);
+clean_mutex:
+	mutex_destroy(&coil->power_lock);
 	return ret;
 }
 
-- 
2.35.1



