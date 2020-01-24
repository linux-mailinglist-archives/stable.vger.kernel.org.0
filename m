Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC6B1481E9
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390915AbgAXLXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:23:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:36288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388604AbgAXLXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:23:37 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8EB9520718;
        Fri, 24 Jan 2020 11:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865016;
        bh=wqSH3Et/Y3xr19traJ9mKhmegGon99lfMzv5u/BNDvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MVuZzUh8OhEWrW8ExfEjtTY0CfxFAi/Zn7Ah4pIS9WKStaR13BtSR5+0ePBCUCmFe
         gqMWM1SrXb87iL+90f1Q9Bpuwzj0C+C7JNgi/07DFDSgNsgZWMb6CFsj5HfNAAjh5K
         nO9rSS8hJAfYZwJebyJ4+zyFG/hwddCQmlxzXySc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Takeshi Kihara <takeshi.kihara.df@renesas.com>,
        Simon Horman <horms+renesas@verge.net.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 415/639] arm64: dts: renesas: ebisu: Remove renesas, no-ether-link property
Date:   Fri, 24 Jan 2020 10:29:45 +0100
Message-Id: <20200124093139.009553201@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takeshi Kihara <takeshi.kihara.df@renesas.com>

[ Upstream commit 90d4fa39d028f2e46c57c3d0e1b759e5287d98b7 ]

It is incorrect to specify the no-ether-link property for the AVB device on
the Ebisu board. This is because the property should only be used when a
board does not provide a proper AVB_LINK signal. However, the Ebisu board
does provide this signal.

As per 87c059e9c39d ("arm64: dts: renesas: salvator-x: Remove renesas,
no-ether-link property") this fixes a bug:

    Steps to reproduce:
    - start AVB TX stream (Using aplay via MSE),
    - disconnect+reconnect the eth cable,
    - after a reconnection the eth connection goes iteratively up/down
      without user interaction,
    - this may heal after some seconds or even stay for minutes.

    As the documentation specifies, the "renesas,no-ether-link" option
    should be used when a board does not provide a proper AVB_LINK signal.
    There is no need for this option enabled on RCAR H3/M3 Salvator-X/XS
    and ULCB starter kits since the AVB_LINK is correctly handled by HW.

    Choosing to keep or remove the "renesas,no-ether-link" option will have
    impact on the code flow in the following ways:
    - keeping this option enabled may lead to unexpected behavior since the
      RX & TX are enabled/disabled directly from adjust_link function
      without any HW interrogation,
    - removing this option, the RX & TX will only be enabled/disabled after
      HW interrogation. The HW check is made through the LMON pin in PSR
      register which specifies AVB_LINK signal value (0 - at low level;
      1 - at high level).

    In conclusion, the present change is also a safety improvement because
    it removes the "renesas,no-ether-link" option leading to a proper way
    of detecting the link state based on HW interrogation and not on
    software heuristic.

Fixes: 8441ef643d7d ("arm64: dts: renesas: r8a77990: ebisu: Enable EthernetAVB")
Signed-off-by: Takeshi Kihara <takeshi.kihara.df@renesas.com>
[simon: updated changelog]
Signed-off-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts b/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts
index 2bc3a4884b003..470c2a35a5aff 100644
--- a/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts
+++ b/arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts
@@ -33,7 +33,6 @@
 &avb {
 	pinctrl-0 = <&avb_pins>;
 	pinctrl-names = "default";
-	renesas,no-ether-link;
 	phy-handle = <&phy0>;
 	phy-mode = "rgmii-txid";
 	status = "okay";
-- 
2.20.1



