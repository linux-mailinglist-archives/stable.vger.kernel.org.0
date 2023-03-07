Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C0D86AE88A
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbjCGRQ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:16:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbjCGRQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:16:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CEE842BDE
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:12:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 359AB61506
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF39C433EF;
        Tue,  7 Mar 2023 17:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209132;
        bh=IkgaqJ6tWn/Y6CKKfbRR7bpP2chwRFsSEYUHUiZhBqs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jyO8/26AwS76RSHL1D1ZakosqSZxn2PQ6qjDTC6yJJQ3YF/liHMkd3qymO3WstBFM
         GDsoA2/xlPRD9XfNAsZ1WN7k11hWqt/HtCalc29hla2ekkNzWsiasOUr1WoyQ/dL9b
         oLiQQbiLgY7dhb4B+aOq5EwJPB1S4pt1zFJHkEXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andre Przywara <andre.przywara@arm.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0091/1001] ARM: dts: sun8i: nanopi-duo2: Fix regulator GPIO reference
Date:   Tue,  7 Mar 2023 17:47:43 +0100
Message-Id: <20230307170026.113871753@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 2177d4ae971f79b4a9a3c411f2fb8ae6113d1430 ]

The property named in the schema is 'enable-gpios', not 'enable-gpio'.
This makes no difference at runtime, because the regulator is marked as
always-on, but it breaks validation.

Fixes: 4701fc6e5dd9 ("ARM: dts: sun8i: add FriendlyARM NanoPi Duo2")
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Samuel Holland <samuel@sholland.org>
Link: https://lore.kernel.org/r/20221231225854.16320-2-samuel@sholland.org
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-h3-nanopi-duo2.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun8i-h3-nanopi-duo2.dts b/arch/arm/boot/dts/sun8i-h3-nanopi-duo2.dts
index 43641cb82398f..343b02b971555 100644
--- a/arch/arm/boot/dts/sun8i-h3-nanopi-duo2.dts
+++ b/arch/arm/boot/dts/sun8i-h3-nanopi-duo2.dts
@@ -57,7 +57,7 @@ reg_vdd_cpux: vdd-cpux-regulator {
 		regulator-ramp-delay = <50>; /* 4ms */
 
 		enable-active-high;
-		enable-gpio = <&r_pio 0 8 GPIO_ACTIVE_HIGH>; /* PL8 */
+		enable-gpios = <&r_pio 0 8 GPIO_ACTIVE_HIGH>; /* PL8 */
 		gpios = <&r_pio 0 6 GPIO_ACTIVE_HIGH>; /* PL6 */
 		gpios-states = <0x1>;
 		states = <1100000 0>, <1300000 1>;
-- 
2.39.2



