Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4F26A7308
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 19:11:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjCASL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 13:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjCASL4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 13:11:56 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DBF4AFE0
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 10:11:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 11D29CE1DAC
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18544C433D2;
        Wed,  1 Mar 2023 18:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677694311;
        bh=OtF8ZiBBwfOgsqCNX3FwBB8ECvvndlNZDuoqjQndGxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wKPXuYWvcY91iV4LL1bVEW2SY4iLu8G/lrm2MJS8L7A+HOF11a14UBlA5Zb+zPTNd
         0M9dviBcNa+w8dW6SB2z8DTNG7NvPk4Z0mhSmrXUWsSJeZLreG6zCMDL8ZJoxb1rde
         bYrHIUoOvwtx/1+2LtB/Qd4aZnmkRulmz+lKMf3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 17/42] ARM: dts: stihxxx-b2120: fix polarity of reset line of tsin0 port
Date:   Wed,  1 Mar 2023 19:08:38 +0100
Message-Id: <20230301180657.842673218@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230301180657.003689969@linuxfoundation.org>
References: <20230301180657.003689969@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 4722dd4029c63f10414ffd8d3ffdd6c748391cd7 ]

According to c8sectpfe driver code we first drive reset line low and
then high to reset the port, therefore the reset line is supposed to
be annotated as "active low". This will be important when we convert
the driver to gpiod API.

Reviewed-by: Patrice Chotard <patrice.chotard@foss.st.com>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/stihxxx-b2120.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/stihxxx-b2120.dtsi b/arch/arm/boot/dts/stihxxx-b2120.dtsi
index 2aa94605d3d47..d52a7aaa10743 100644
--- a/arch/arm/boot/dts/stihxxx-b2120.dtsi
+++ b/arch/arm/boot/dts/stihxxx-b2120.dtsi
@@ -178,7 +178,7 @@ tsin0: port {
 				tsin-num = <0>;
 				serial-not-parallel;
 				i2c-bus = <&ssc2>;
-				reset-gpios = <&pio15 4 GPIO_ACTIVE_HIGH>;
+				reset-gpios = <&pio15 4 GPIO_ACTIVE_LOW>;
 				dvb-card = <STV0367_TDA18212_NIMA_1>;
 			};
 		};
-- 
2.39.0



