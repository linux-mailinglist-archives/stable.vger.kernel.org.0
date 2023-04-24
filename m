Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 971316ECEB8
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbjDXNeo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbjDXNe3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:34:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4D18A57
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:34:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 482516239D
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7E6C433EF;
        Mon, 24 Apr 2023 13:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343243;
        bh=5Q/alzVw3POn6zQY3MwBas8+2QDzrK6IIwvhPWzQx84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vK6V3gXC4PVXivpTrtcpYkvQX26biyWYFVWsSpRtMABq2l3r54cfVXSEzvuYnNH2m
         TR7R0Z0w8eylOgER5+dCYpCpUifZosNU8W2/yfvGMeb98oJlzRba9YxAEhlX9VjDmc
         nPZW3oA5kR5pEJ/gipJN7Mq/w8cOLt+HdywyVWIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/68] regulator: fan53555: Explicitly include bits header
Date:   Mon, 24 Apr 2023 15:17:37 +0200
Message-Id: <20230424131127.927593076@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 4fb9a5060f73627303bc531ceaab1b19d0a24aef ]

Since commit f2a9eb975ab2 ("regulator: fan53555: Add support for
FAN53526") the driver makes use of the BIT() macro, but relies on the
bits header being implicitly included.

Explicitly pull the header in to avoid potential build failures in some
configurations.

While here, reorder include directives alphabetically.

Fixes: f2a9eb975ab2 ("regulator: fan53555: Add support for FAN53526")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20230406171806.948290-3-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fan53555.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index aa426183b6a11..1af12074a75ab 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -8,18 +8,19 @@
 // Copyright (c) 2012 Marvell Technology Ltd.
 // Yunfan Zhang <yfzhang@marvell.com>
 
+#include <linux/bits.h>
+#include <linux/err.h>
+#include <linux/i2c.h>
 #include <linux/module.h>
+#include <linux/of_device.h>
 #include <linux/param.h>
-#include <linux/err.h>
 #include <linux/platform_device.h>
+#include <linux/regmap.h>
 #include <linux/regulator/driver.h>
+#include <linux/regulator/fan53555.h>
 #include <linux/regulator/machine.h>
 #include <linux/regulator/of_regulator.h>
-#include <linux/of_device.h>
-#include <linux/i2c.h>
 #include <linux/slab.h>
-#include <linux/regmap.h>
-#include <linux/regulator/fan53555.h>
 
 /* Voltage setting */
 #define FAN53555_VSEL0		0x00
-- 
2.39.2



