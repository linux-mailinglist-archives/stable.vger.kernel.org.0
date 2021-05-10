Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6CF3785B6
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:29:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235544AbhEJLBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:01:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:52812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234561AbhEJK4j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A9DC361985;
        Mon, 10 May 2021 10:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643626;
        bh=xUnd5hseQQRNaFMUpf6sZYL5fQh6wgZ6i5EKSwdr364=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pgVtXTtJjM26IU5s1a5EqFrv12zEuAamSfWBbBtaRK32wckZOoe4hEKYWfBf59HaZ
         fJsU57xevRzY9Z75951LJbbKugjRyaj9GTx8CjY22+hc8gFbM3Pk9lvfrub8Fjx+1a
         0f5HU+zqB30GiC1qWLuf5kzVnANPaD25qwQ5SVwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 090/342] arm64: dts: imx8mq-librem5-r3: Mark buck3 as always on
Date:   Mon, 10 May 2021 12:18:00 +0200
Message-Id: <20210510102013.081530895@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
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
index 6704ea2c72a3..cc29223ca188 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq-librem5-r3.dts
+++ b/arch/arm64/boot/dts/freescale/imx8mq-librem5-r3.dts
@@ -22,6 +22,10 @@
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



