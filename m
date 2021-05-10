Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34225378802
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238881AbhEJLUR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:45768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236423AbhEJLIG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A39FC61992;
        Mon, 10 May 2021 11:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644469;
        bh=HH76M35kDKlyVQQ07uDGSiDSpAq86qUC+3p4qvtpPAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hc3B6qHq+7MEM7UaarAC9+OVF+8rO3bTIl7UnxmKgHjp4xsMqEfpUist4IXXNJO+D
         12XZJEu0Rzq1n4bDbL5ZT+e5NlUVQEhtFuQggsleiekWW9+K5+dpQ4R0k0JZv/uhhS
         hXW1NwQ8+PgwZvp37/Vg2XlM09KmwMB4D16RwZPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 095/384] arm64: dts: imx8mq-librem5-r3: Mark buck3 as always on
Date:   Mon, 10 May 2021 12:18:04 +0200
Message-Id: <20210510102018.022690911@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>

[ Upstream commit a362b0cc94d476b097ba0ff466958c1d4e27e219 ]

Commit 99e71c029213 ("arm64: dts: imx8mq-librem5: Don't mark buck3 as always on")
removed always-on marking from GPU regulator, which is great for power
saving - however it introduces additional i2c0 traffic which can be deadly
for devices from the Dogwood batch.

To workaround the i2c0 shutdown issue on Dogwood, this commit marks
buck3 as always-on again - but only for Dogwood (r3).

Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Signed-off-by: Martin Kepplinger <martin.kepplinger@puri.sm>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mq-librem5-r3.dts | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/freescale/imx8mq-librem5-r3.dts b/arch/arm64/boot/dts/freescale/imx8mq-librem5-r3.dts
index 0d38327043f8..cd3c3edd48fa 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-librem5-r3.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mq-librem5-r3.dts
@@ -28,6 +28,10 @@
 	ti,termination-current = <144000>;  /* uA */
 };
 
+&buck3_reg {
+	regulator-always-on;
+};
+
 &proximity {
 	proximity-near-level = <25>;
 };
-- 
2.30.2



