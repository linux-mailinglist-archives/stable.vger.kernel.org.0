Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23D0D30CC0B
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:45:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239793AbhBBTmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:42:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:41108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233295AbhBBNxy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:53:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FB0F64FCE;
        Tue,  2 Feb 2021 13:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273457;
        bh=WvNPykZ15mmcWc1Jg66LRN65j/h4n8jhjuQmLuHbAYY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W44WpsL2IaARHKHKXPgex4mFurUxhv/7Ihr1okPkQOFDMDa1SYaPlkboy+Jdw/AwU
         rro6/HL53kJLlVvTx0aLY8oD0LwESAnDaNhF0K270caMxAL9LbCyEvQ5fLN5Fqsn98
         P2ZeW58LmkuSbYisTliudelQXdmugTq89qGWPKko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 082/142] arm64: dts: ls1028a: fix the offset of the reset register
Date:   Tue,  2 Feb 2021 14:37:25 +0100
Message-Id: <20210202133001.091235382@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 1653e3d470629d25c64cd8a2f84adb20a9348b0c ]

The offset of the reset request register is 0, the absolute address is
0x1e60000. Boards without PSCI support will fail to perform a reset:

[   26.734700] reboot: Restarting system
[   27.743259] Unable to restart system
[   27.746845] Reboot failed -- System halted

Fixes: 8897f3255c9c ("arm64: dts: Add support for NXP LS1028A SoC")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
index 33aa0efa2293a..62f4dcb96e70d 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi
@@ -93,7 +93,7 @@
 	reboot {
 		compatible ="syscon-reboot";
 		regmap = <&rst>;
-		offset = <0xb0>;
+		offset = <0>;
 		mask = <0x02>;
 	};
 
-- 
2.27.0



