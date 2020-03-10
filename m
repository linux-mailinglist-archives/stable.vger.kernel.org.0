Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFF617FC1B
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731307AbgCJNKP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:10:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730874AbgCJNKO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:10:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 48F692469C;
        Tue, 10 Mar 2020 13:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845813;
        bh=gdTqg6g5SFcFPliqxorv+NyWqjDzIbIfRM5vZNziTdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wvjpDo3phbYilfG3x7DfxomShCXdzoXt3j9zhgkb2Alzx/fEUGcR+/5Q8pGeiIHaa
         ISPGpOUHALQ60cQjOXM77opzBHLLOluo1zpuhz87A02xhrLxPc043Y/MRQbdZEXhfs
         TED2ImlxYikst6DkBIU4k4HB8fY/p6FRPdx/mJnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Machek <pavel@denx.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 4.14 110/126] ARM: dts: ls1021a: Restore MDIO compatible to gianfar
Date:   Tue, 10 Mar 2020 13:42:11 +0100
Message-Id: <20200310124210.593486859@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>

commit 7155c44624d061692b4c13aa8343f119c67d4fc0 upstream.

The difference between "fsl,etsec2-mdio" and "gianfar" has to do with
the .get_tbipa function, which calculates the address of the TBIPA
register automatically, if not explicitly specified. [ see
drivers/net/ethernet/freescale/fsl_pq_mdio.c ]. On LS1021A, the TBIPA
register is at offset 0x30 within the port register block, which is what
the "gianfar" method of calculating addresses actually does.

Luckily, the bad "compatible" is inconsequential for ls1021a.dtsi,
because the TBIPA register is explicitly specified via the second "reg"
(<0x0 0x2d10030 0x0 0x4>), so the "get_tbipa" function is dead code.
Nonetheless it's good to restore it to its correct value.

Background discussion:
https://www.spinics.net/lists/stable/msg361156.html

Fixes: c7861adbe37f ("ARM: dts: ls1021: Fix SGMII PCS link remaining down after PHY disconnect")
Reported-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/boot/dts/ls1021a.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/ls1021a.dtsi
+++ b/arch/arm/boot/dts/ls1021a.dtsi
@@ -562,7 +562,7 @@
 		};
 
 		mdio0: mdio@2d24000 {
-			compatible = "fsl,etsec2-mdio";
+			compatible = "gianfar";
 			device_type = "mdio";
 			#address-cells = <1>;
 			#size-cells = <0>;
@@ -570,7 +570,7 @@
 		};
 
 		mdio1: mdio@2d64000 {
-			compatible = "fsl,etsec2-mdio";
+			compatible = "gianfar";
 			device_type = "mdio";
 			#address-cells = <1>;
 			#size-cells = <0>;


