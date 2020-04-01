Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE0019AFCF
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732470AbgDAQVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:21:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:44160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732497AbgDAQVR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:21:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8765820658;
        Wed,  1 Apr 2020 16:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585758077;
        bh=yoXhOL7nTVasZHR6cKwhWMciTV/1jPkQpUjZtocCq3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFLjohpR5Bnrjd2rCojIAnwbKpnK5UFvlVgnMIq3wefmjIKACY8E5ngtK1bvPvoG/
         2nLcZgKSBD0W6QjoDPnXSOlSCuSzfoOgUX6IZjnG9CshtgL/dglst9jL7p5p4Y0xP9
         o+skzfKOncPl8ETP1uoNmCTp0AhXGX2nlyJHtPyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Madalin Bucur <madalin.bucur@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 29/30] arm64: dts: ls1043a-rdb: correct RGMII delay mode to rgmii-id
Date:   Wed,  1 Apr 2020 18:17:33 +0200
Message-Id: <20200401161436.096040580@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161414.345528747@linuxfoundation.org>
References: <20200401161414.345528747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madalin Bucur <madalin.bucur@oss.nxp.com>

commit 4022d808c45277693ea86478fab1f081ebf997e8 upstream.

The correct setting for the RGMII ports on LS1043ARDB is to
enable delay on both Rx and Tx so the interface mode used must
be PHY_INTERFACE_MODE_RGMII_ID.

Since commit 1b3047b5208a80 ("net: phy: realtek: add support for
configuring the RX delay on RTL8211F") the Realtek 8211F PHY driver
has control over the RGMII RX delay and it is disabling it for
RGMII_TXID. The LS1043ARDB uses two such PHYs in RGMII_ID mode but
in the device tree the mode was described as "rgmii_txid".
This issue was not apparent at the time as the PHY driver took the
same action for RGMII_TXID and RGMII_ID back then but it became
visible (RX no longer working) after the above patch.

Changing the phy-connection-type to "rgmii-id" to address the issue.

Fixes: bf02f2ffe59c ("arm64: dts: add LS1043A DPAA FMan support")
Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1043a-rdb.dts
@@ -119,12 +119,12 @@
 
 	ethernet@e4000 {
 		phy-handle = <&rgmii_phy1>;
-		phy-connection-type = "rgmii-txid";
+		phy-connection-type = "rgmii-id";
 	};
 
 	ethernet@e6000 {
 		phy-handle = <&rgmii_phy2>;
-		phy-connection-type = "rgmii-txid";
+		phy-connection-type = "rgmii-id";
 	};
 
 	ethernet@e8000 {


