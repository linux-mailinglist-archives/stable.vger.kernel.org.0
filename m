Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE4D579DE3
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:55:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242112AbiGSMzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242114AbiGSMy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:54:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83F2699645;
        Tue, 19 Jul 2022 05:22:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F05A161632;
        Tue, 19 Jul 2022 12:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD4FC341C6;
        Tue, 19 Jul 2022 12:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233321;
        bh=fr9eRr9LYNLPJAml2G3Qm16Rayd/ibjXZQcpvaqCjY4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UV8lbnjyWl/Jhxfws4XvQKi80BpZs0AO3Xr7TDP2BTuSuuJiR0EZUZLYe6NgJ+J6v
         6vtGkWD4vW7mT3OvokIeaRvEWUSvlGohUWMI3Dj1FCad6vu0Uq8qS5taYh7AE2MuVt
         TERO7OhC9dpCM0IYeHV779L8R6U+m8ZdpvQnA8GY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michal Suchanek <msuchanek@suse.de>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 082/231] ARM: dts: sunxi: Fix SPI NOR campatible on Orange Pi Zero
Date:   Tue, 19 Jul 2022 13:52:47 +0200
Message-Id: <20220719114721.762527290@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Suchanek <msuchanek@suse.de>

[ Upstream commit 884b66976a7279ee889ba885fe364244d50b79e7 ]

The device tree should include generic "jedec,spi-nor" compatible, and a
manufacturer-specific one.
The macronix part is what is shipped on the boards that come with a
flash chip.

Fixes: 45857ae95478 ("ARM: dts: orange-pi-zero: add node for SPI NOR")
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Signed-off-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://lore.kernel.org/r/20220708174529.3360-1-msuchanek@suse.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts b/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts
index f19ed981da9d..3706216ffb40 100644
--- a/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts
+++ b/arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts
@@ -169,7 +169,7 @@ &spi0 {
 	flash@0 {
 		#address-cells = <1>;
 		#size-cells = <1>;
-		compatible = "mxicy,mx25l1606e", "winbond,w25q128";
+		compatible = "mxicy,mx25l1606e", "jedec,spi-nor";
 		reg = <0>;
 		spi-max-frequency = <40000000>;
 	};
-- 
2.35.1



