Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E594A541194
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356322AbiFGTjA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:39:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356419AbiFGTiY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:38:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 793D436692;
        Tue,  7 Jun 2022 11:13:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CABEAB82377;
        Tue,  7 Jun 2022 18:13:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F6AC385A2;
        Tue,  7 Jun 2022 18:13:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625628;
        bh=CHObYO3QTAakNe5T3Fe914iXUbpSy1aT88lWYZtUQ/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UGFOjNgf0gRZ/4tbbiHwungvWluo/Iko6eePax+Q4UUtQLvjLB0zyIDYhnfa87x2d
         D6A1kGsN9QTv3NnAQ576yxEgIcuXpEoRolp5V3t/KOHiNCjsusr8vTVUR6pqzYMqbX
         3+WfYqC2fJ6kc1WTOJhdC90ukI2aqmV0KRNggSfU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Bingbu Cao <bingbu.cao@intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 087/772] media: Revert "media: dw9768: activate runtime PM and turn off device"
Date:   Tue,  7 Jun 2022 18:54:39 +0200
Message-Id: <20220607164951.608392055@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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



