Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2FF6BB275
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:36:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232820AbjCOMg3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232212AbjCOMgG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:36:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CFB2900AB;
        Wed, 15 Mar 2023 05:35:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D82F7B81E09;
        Wed, 15 Mar 2023 12:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53127C433EF;
        Wed, 15 Mar 2023 12:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883708;
        bh=0ZTy/K+sQEEKWVa5LE+BZI7IWuHHjn6btf/32a0R+mM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0E8bPNTf7Ep08l+nCedBU2l2HBX0oYBM03Zqq65MFQ/omybMBi0ipuF8yuYBLja6o
         hUIeSdHGn3TDV2x7PBcRtapmKQk9ApuV4CuZuSMBuGVPAivdcNS++wnJmkeKgQWtQ7
         onikNydTgVjJB+KE/ycI2LcuoWx2YoqD0Pt6SlAY=
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
Subject: [PATCH 6.1 101/143] platform: x86: MLX_PLATFORM: select REGMAP instead of depending on it
Date:   Wed, 15 Mar 2023 13:13:07 +0100
Message-Id: <20230315115743.575533678@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index f5312f51de19f..b02a8125bc7d5 100644
--- a/drivers/platform/x86/Kconfig
+++ b/drivers/platform/x86/Kconfig
@@ -997,7 +997,8 @@ config SERIAL_MULTI_INSTANTIATE
 
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



