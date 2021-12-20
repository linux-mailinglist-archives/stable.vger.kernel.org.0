Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69D9547ADC4
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234669AbhLTOzm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:55:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:42030 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237784AbhLTOwb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:52:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C833611B9;
        Mon, 20 Dec 2021 14:52:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA0EC36AE7;
        Mon, 20 Dec 2021 14:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011949;
        bh=8vW+unLysfntXu6iIc1zwHVSbTG5anRrRkbtP5NDjyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oCgIysGFtrPky5gYIZk09Li1E4tkxgV/G3oIqIir7nq1lFs4+e9Sj92JQitqKsh5E
         JUSiJ+u1jHpadKcwR9RgmkaYqGgXZxH4OGEdeFdS94oQrf3Y58aZQh5aUmiaFBPygj
         9DDSvW4LS4QbJf/HrcgPLwf9ZCu+eXYTuz8AZeXM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathew McBride <matt@traverse.com.au>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 5.15 026/177] arm64: dts: ten64: remove redundant interrupt declaration for gpio-keys
Date:   Mon, 20 Dec 2021 15:32:56 +0100
Message-Id: <20211220143040.958536935@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathew McBride <matt@traverse.com.au>

commit c88c5e461939a06ae769a01649d5c6b5a156f883 upstream.

gpio-keys already 'inherits' the interrupts from the controller
of the specified GPIO, so having another declaration is redundant.
On >=v5.15 this started causing an oops under gpio_keys_probe as
the IRQ was already claimed.

Signed-off-by: Mathew McBride <matt@traverse.com.au>
Fixes: 418962eea358 ("arm64: dts: add device tree for Traverse Ten64 (LS1088A)")
Cc: stable@vger.kernel.org
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1088a-ten64.dts
@@ -38,7 +38,6 @@
 		powerdn {
 			label = "External Power Down";
 			gpios = <&gpio1 17 GPIO_ACTIVE_LOW>;
-			interrupts = <&gpio1 17 IRQ_TYPE_EDGE_FALLING>;
 			linux,code = <KEY_POWER>;
 		};
 
@@ -46,7 +45,6 @@
 		admin {
 			label = "ADMIN button";
 			gpios = <&gpio3 8 GPIO_ACTIVE_HIGH>;
-			interrupts = <&gpio3 8 IRQ_TYPE_EDGE_RISING>;
 			linux,code = <KEY_WPS_BUTTON>;
 		};
 	};


