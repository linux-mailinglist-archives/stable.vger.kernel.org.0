Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEF0541805
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378765AbiFGVH1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:07:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379729AbiFGVGQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:06:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1462109FC;
        Tue,  7 Jun 2022 11:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F98361734;
        Tue,  7 Jun 2022 18:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE90C385A5;
        Tue,  7 Jun 2022 18:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627810;
        bh=CHObYO3QTAakNe5T3Fe914iXUbpSy1aT88lWYZtUQ/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DdWjTtJMisMc+TDXrS+pSGp4xjALh81EB7M+cVpbddyONwjR9SxtcZJu6lFNeFtJ/
         zhFKccXY636b/Fj4B4Pf8M/Wnk4Z1Kj0RHIHWqPFkvtTXZXmKM5z5Bij2EHvc+x1Jk
         6XyfABvz+veIGTOZVndYtwZR82jqtoA4F9tbPebM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 100/879] media: Revert "media: dw9768: activate runtime PM and turn off device"
Date:   Tue,  7 Jun 2022 18:53:38 +0200
Message-Id: <20220607165005.598260361@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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



