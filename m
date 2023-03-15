Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B74F26BB19B
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:29:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232578AbjCOM3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:29:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232348AbjCOM2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:28:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F9A3B75B;
        Wed, 15 Mar 2023 05:27:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A80661D49;
        Wed, 15 Mar 2023 12:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C890C433EF;
        Wed, 15 Mar 2023 12:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883268;
        bh=6uZGlOEALfQB14/jsIL8GLQ5euDfKimvvn8zAye8AQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RCE0D/Aqvt6v20v++hmSFfaZK4HPeg7trzeSB4isVJqTYnR5VO9q3/fJCj+AeWgnS
         74rdxWi6Y/Wfo8JJzzckCtNTroth91frb1AAX3IcowbQ7Odu9qqQM+nVJkqkYOSRnq
         3n9IJ1PXkfDy5sjauOTKm8nToG02m/6OALhb5y3g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Darren Hart <dvhart@infradead.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        platform-driver-x86@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/145] platform: x86: MLX_PLATFORM: select REGMAP instead of depending on it
Date:   Wed, 15 Mar 2023 13:12:18 +0100
Message-Id: <20230315115741.391999629@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 7e7e1541c91615e9950d0b96bcd1806d297e970e ]

REGMAP is a hidden (not user visible) symbol. Users cannot set it
directly thru "make *config", so drivers should select it instead of
depending on it if they need it.

Consistently using "select" or "depends on" can also help reduce
Kconfig circular dependency issues.

Therefore, change the use of "depends on REGMAP" to "select REGMAP".

Fixes: ef0f62264b2a ("platform/x86: mlx-platform: Add physical bus number auto detection")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Vadim Pasternak <vadimp@mellanox.com>
Cc: Darren Hart <dvhart@infradead.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Mark Gross <markgross@kernel.org>
Cc: platform-driver-x86@vger.kernel.org
Link: https://lore.kernel.org/r/20230226053953.4681-7-rdunlap@infradead.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
index cd8146dbdd453..61186829d1f6b 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -943,7 +943,8 @@ config I2C_MULTI_INSTANTIATE
 
 config MLX_PLATFORM
 	tristate "Mellanox Technologies platform support"
-	depends on I2C && REGMAP
+	depends on I2C
+	select REGMAP
 	help
 	  This option enables system support for the Mellanox Technologies
 	  platform. The Mellanox systems provide data center networking
-- 
2.39.2



