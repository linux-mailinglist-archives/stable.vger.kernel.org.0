Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4F519B2E9
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390073AbgDAQri (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:47:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:49452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389554AbgDAQrh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:47:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8806F20705;
        Wed,  1 Apr 2020 16:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759657;
        bh=OJk05znDwBNzrtl7qwWp1XcMT+oENkFkHzaJeU+U+Ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQadTsG8OAcG2g0Mqun9dyqJ11tYZaNmGbh/STiLkEFvjZ8AO34h2JLrc2HjgB9xs
         b7Rpo1a7gJoiUmvlkUraVhCI0q+nZdekLcQDS9AYgI64SETdDCgfxTLnuI9SX+qKWX
         /h1JQxXDaeOlftvbGHTwCgsUnpo4YkPLbXdiEYog=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Madalin Bucur <madalin.bucur@oss.nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 148/148] arm64: dts: ls1046ardb: set RGMII interfaces to RGMII_ID mode
Date:   Wed,  1 Apr 2020 18:19:00 +0200
Message-Id: <20200401161606.196310048@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Madalin Bucur <madalin.bucur@oss.nxp.com>

commit d79e9d7c1e4ba5f95f2ff3541880c40ea9722212 upstream.

The correct setting for the RGMII ports on LS1046ARDB is to
enable delay on both Rx and Tx so the interface mode used must
be PHY_INTERFACE_MODE_RGMII_ID.

Since commit 1b3047b5208a80 ("net: phy: realtek: add support for
configuring the RX delay on RTL8211F") the Realtek 8211F PHY driver
has control over the RGMII RX delay and it is disabling it for
RGMII_TXID. The LS1046ARDB uses two such PHYs in RGMII_ID mode but
in the device tree the mode was described as "rgmii".

Changing the phy-connection-type to "rgmii-id" to address the issue.

Fixes: 3fa395d2c48a ("arm64: dts: add LS1046A DPAA FMan nodes")
Signed-off-by: Madalin Bucur <madalin.bucur@oss.nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1046a-rdb.dts
@@ -162,12 +162,12 @@
 &fman0 {
 	ethernet@e4000 {
 		phy-handle = <&rgmii_phy1>;
-		phy-connection-type = "rgmii";
+		phy-connection-type = "rgmii-id";
 	};
 
 	ethernet@e6000 {
 		phy-handle = <&rgmii_phy2>;
-		phy-connection-type = "rgmii";
+		phy-connection-type = "rgmii-id";
 	};
 
 	ethernet@e8000 {


