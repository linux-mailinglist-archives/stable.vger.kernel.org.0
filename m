Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852E759E251
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353717AbiHWKcx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:32:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355012AbiHWKas (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:30:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78F685AAA;
        Tue, 23 Aug 2022 02:06:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFCC761596;
        Tue, 23 Aug 2022 09:06:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA5A6C433B5;
        Tue, 23 Aug 2022 09:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661245589;
        bh=GBN9yMYjGurun1AV7Y40ykMKxztoq6vHXN9KuxWaQRQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pz3r1zVPgOEpZria0vYEOH3LlyJkmmJIR+jZl0NXdt+hr36FGaONV3qeMlhUzTQh7
         u8DImZoPaa8ccL7C/5dQI1U/pd6JDrGbZ8rUFxQnTLRZB2VxQ70nRsgB6QAThfo9s3
         iqRAbgFR8BboITl574qbQvUouV3v0FNWEseD3AjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 125/287] soundwire: bus_type: fix remove and shutdown support
Date:   Tue, 23 Aug 2022 10:24:54 +0200
Message-Id: <20220823080104.601080377@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080100.268827165@linuxfoundation.org>
References: <20220823080100.268827165@linuxfoundation.org>
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

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit df6407782964dc7e35ad84230abb38f46314b245 ]

The bus sdw_drv_remove() and sdw_drv_shutdown() helpers are used
conditionally, if the driver provides these routines.

These helpers already test if the driver provides a .remove or
.shutdown callback, so there's no harm in invoking the
sdw_drv_remove() and sdw_drv_shutdown() unconditionally.

In addition, the current code is imbalanced with
dev_pm_domain_attach() called from sdw_drv_probe(), but
dev_pm_domain_detach() called from sdw_drv_remove() only if the driver
provides a .remove callback.

Fixes: 9251345dca24b ("soundwire: Add SoundWire bus type")
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Rander Wang <rander.wang@intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220610015105.25987-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/bus_type.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/soundwire/bus_type.c b/drivers/soundwire/bus_type.c
index 283b2832728e..414621f3c43c 100644
--- a/drivers/soundwire/bus_type.c
+++ b/drivers/soundwire/bus_type.c
@@ -154,12 +154,8 @@ int __sdw_register_driver(struct sdw_driver *drv, struct module *owner)
 
 	drv->driver.owner = owner;
 	drv->driver.probe = sdw_drv_probe;
-
-	if (drv->remove)
-		drv->driver.remove = sdw_drv_remove;
-
-	if (drv->shutdown)
-		drv->driver.shutdown = sdw_drv_shutdown;
+	drv->driver.remove = sdw_drv_remove;
+	drv->driver.shutdown = sdw_drv_shutdown;
 
 	return driver_register(&drv->driver);
 }
-- 
2.35.1



