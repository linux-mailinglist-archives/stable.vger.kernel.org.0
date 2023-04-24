Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90C236ECE1D
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:29:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbjDXN31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:29:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbjDXN3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:29:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A3AE72A7
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:28:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 941396231B
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2B5EC433EF;
        Mon, 24 Apr 2023 13:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342938;
        bh=GeT/JPhqCfQo5Ixkw3LlobvoLmmRZkTaJDHa0CKIiEU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NPvWyduJ6ZKsoo0suaFvudl5w/gWkfY0G94cly36J3L71GIyyHdjn81UMO7KEEaCu
         nq41qYvzZqoXVuoHphqH9DFM1LLhiRnpSA2Dw+NkNmks4Z6csykpI6oKy8exHo5WoF
         M3FlxYpdmXmHzUadSKRGLp3M1ranF1joaZqCn50w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 016/110] regulator: fan53555: Fix wrong TCS_SLEW_MASK
Date:   Mon, 24 Apr 2023 15:16:38 +0200
Message-Id: <20230424131136.726893759@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit c5d5b55b3c1a314137a251efc1001dfd435c6242 ]

The support for TCS4525 regulator has been introduced with a wrong
ramp-rate mask, which has been defined as a logical expression instead
of a bit shift operation.

For clarity, fix it using GENMASK() macro.

Fixes: 914df8faa7d6 ("regulator: fan53555: Add TCS4525 DCDC support")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20230406171806.948290-4-cristian.ciocaltea@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fan53555.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/fan53555.c b/drivers/regulator/fan53555.c
index 45f07d2ad1c58..41537c45f0367 100644
--- a/drivers/regulator/fan53555.c
+++ b/drivers/regulator/fan53555.c
@@ -61,7 +61,7 @@
 #define TCS_VSEL1_MODE		(1 << 6)
 
 #define TCS_SLEW_SHIFT		3
-#define TCS_SLEW_MASK		(0x3 < 3)
+#define TCS_SLEW_MASK		GENMASK(4, 3)
 
 enum fan53555_vendor {
 	FAN53526_VENDOR_FAIRCHILD = 0,
-- 
2.39.2



