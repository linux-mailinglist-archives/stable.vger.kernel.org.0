Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E564059E02C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:37:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241602AbiHWL23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243315AbiHWLY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:24:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42353876B6;
        Tue, 23 Aug 2022 02:23:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE70D612F4;
        Tue, 23 Aug 2022 09:23:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0F7EC4314A;
        Tue, 23 Aug 2022 09:23:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246637;
        bh=hL/16M+dei/IXOjD5UfzwMn82C1KO1dHKyhbnjte2ME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fw98ut9huRWEUQwR1fVhwueHujHg1CniWvMaFQ6Z/tRKIqd4bmMt416MqE9kmxx7O
         2QAtS1HWtoQ1r8Ye0SLQN9v5IKP1SAGksQJIumw2xZRyLz7HwnAkkcYnQtUZmza216
         JJiH4NEG6neSI1XaFHbYLGB0WynRHFHXpbJ1AVOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Rander Wang <rander.wang@intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 173/389] soundwire: bus_type: fix remove and shutdown support
Date:   Tue, 23 Aug 2022 10:24:11 +0200
Message-Id: <20220823080122.860846311@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
index 4a465f55039f..2fe5a51918c8 100644
--- a/drivers/soundwire/bus_type.c
+++ b/drivers/soundwire/bus_type.c
@@ -155,12 +155,8 @@ int __sdw_register_driver(struct sdw_driver *drv, struct module *owner)
 
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



