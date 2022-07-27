Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3C8582E31
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbiG0RJz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237264AbiG0RIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:08:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D2572ED0;
        Wed, 27 Jul 2022 09:40:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2AC80CE230F;
        Wed, 27 Jul 2022 16:40:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B604C433C1;
        Wed, 27 Jul 2022 16:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940034;
        bh=Zp7O+qA6v8hNhs/CuX4OQqC8NTPMh5+4zcXaPfJnW5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXmxulfV38spYBck0YF1gC4WKcUOfg5rxHyjEQLQE7qjBPvp9/c7FTDLNkGHaIKwW
         wUX5+JSJvMQxQhSO7YnGoljNh974+KZT1uqy8irSZaagKf4FPGrAoYCjTunHdTixYa
         eE3tBYMb+hDQliBgEeiu+PAQub+6Q0mQ6KRDdQOo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 082/201] i2c: mlxcpld: Fix register setting for 400KHz frequency
Date:   Wed, 27 Jul 2022 18:09:46 +0200
Message-Id: <20220727161031.138829059@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit e1f77ecc75aaee6bed04e8fd7830e00032af012e ]

Fix setting of 'Half Cycle' register for 400KHz frequency.

Fixes: fa1049135c15 ("i2c: mlxcpld: Modify register setting for 400KHz frequency")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mlxcpld.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-mlxcpld.c b/drivers/i2c/busses/i2c-mlxcpld.c
index 015e11c4663f..077d716c73ca 100644
--- a/drivers/i2c/busses/i2c-mlxcpld.c
+++ b/drivers/i2c/busses/i2c-mlxcpld.c
@@ -49,7 +49,7 @@
 #define MLXCPLD_LPCI2C_NACK_IND		2
 
 #define MLXCPLD_I2C_FREQ_1000KHZ_SET	0x04
-#define MLXCPLD_I2C_FREQ_400KHZ_SET	0x0c
+#define MLXCPLD_I2C_FREQ_400KHZ_SET	0x0e
 #define MLXCPLD_I2C_FREQ_100KHZ_SET	0x42
 
 enum mlxcpld_i2c_frequency {
-- 
2.35.1



