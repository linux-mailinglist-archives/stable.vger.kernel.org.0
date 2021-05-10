Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3266E3783AA
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232540AbhEJKq6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:46:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232934AbhEJKos (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:44:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9C9761466;
        Mon, 10 May 2021 10:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642852;
        bh=xUnd5hseQQRNaFMUpf6sZYL5fQh6wgZ6i5EKSwdr364=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WMBhm9ze2SgW636nGDwaI0bEJbeq9KHluzTMxgcUWKgx8PCqnaz10ewGJXu7FcmWN
         uGIFJr72jUGgNBrhMAyUkJnDOXgQUqCTpSTa/QWlDyBPJh7R0ly8wqUgohBraPzUIm
         l/VeniD4Eeg3DzUinkO9VrBWr20qerO3eYSwlZMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        Martin Kepplinger <martin.kepplinger@puri.sm>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/299] arm64: dts: imx8mq-librem5-r3: Mark buck3 as always on
Date:   Mon, 10 May 2021 12:17:54 +0200
Message-Id: <20210510102007.467995416@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
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



