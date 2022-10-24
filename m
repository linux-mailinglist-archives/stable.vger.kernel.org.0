Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1E160A70B
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiJXMrm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234683AbiJXMp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:45:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6265A6156;
        Mon, 24 Oct 2022 05:10:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D1F86128E;
        Mon, 24 Oct 2022 12:09:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF02C433D6;
        Mon, 24 Oct 2022 12:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613374;
        bh=cHT/tctzQJbGiXiQn4s+uUUWvv1Z72ev5clpduBCXxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BC2w4zXgazcjXBj03+wWOvmxN0Zkt8ShfQvMaUQnZxuLFovN8+DR/gsirqroUrma8
         skFkL05ftvG/yNDHGQtFyDqgK7qNe8RQ947WW/AHl5AWKCeHEKlwTPuNDZUhd4IJyN
         UAmQP4zTtuTYEOE7ZVBrKS09I8bgNcZDag2EVp5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 112/255] ARM: dts: turris-omnia: Fix mpp26 pin name and comment
Date:   Mon, 24 Oct 2022 13:30:22 +0200
Message-Id: <20221024113006.214478404@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 49e93898f0dc177e645c22d0664813567fd9ec00 ]

There is a bug in Turris Omnia's schematics, whereupon the MPP[26] pin,
which is routed to CN11 pin header, is documented as SPI CS1, but
MPP[26] pin does not support this function. Instead it controls chip
select 2 if in "spi0" mode.

Fix the name of the pin node in pinctrl node and fix the comment in SPI
node.

Fixes: 26ca8b52d6e1 ("ARM: dts: add support for Turris Omnia")
Signed-off-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-385-turris-omnia.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/armada-385-turris-omnia.dts b/arch/arm/boot/dts/armada-385-turris-omnia.dts
index fde4c302f08e..92e08486ec81 100644
--- a/arch/arm/boot/dts/armada-385-turris-omnia.dts
+++ b/arch/arm/boot/dts/armada-385-turris-omnia.dts
@@ -307,7 +307,7 @@
 		marvell,function = "spi0";
 	};
 
-	spi0cs1_pins: spi0cs1-pins {
+	spi0cs2_pins: spi0cs2-pins {
 		marvell,pins = "mpp26";
 		marvell,function = "spi0";
 	};
@@ -342,7 +342,7 @@
 		};
 	};
 
-	/* MISO, MOSI, SCLK and CS1 are routed to pin header CN11 */
+	/* MISO, MOSI, SCLK and CS2 are routed to pin header CN11 */
 };
 
 &uart0 {
-- 
2.35.1



