Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4DEF10185F
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:07:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbfKSFco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:32:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:53070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728927AbfKSFco (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:32:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AEA0B21783;
        Tue, 19 Nov 2019 05:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141563;
        bh=qpvMGZ3IB0+wiopYrxiriRauFzfeubkGQ+P4ZAm2Ydc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=keX4uxinIeL1AidTwe+k1rqDuSs52NUzuVpKvfF6yOl+WXQLBRWnAb4YBdHGT/YuH
         dgtkE1V+UOQw3rA1g01sKZqLD3RHxXewl9u87WgCRw7zECbzp7ksmspgXEudjWcQ7V
         vG6EU5EplJg7Ws06pIB9sXogysN5bVk34nTXXceA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Lamparter <chunkeey@gmail.com>,
        John Crispin <john@phrozen.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 203/422] ARM: dts: qcom: ipq4019: fix cpu0s qcom,saw2 reg value
Date:   Tue, 19 Nov 2019 06:16:40 +0100
Message-Id: <20191119051411.735581633@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Lamparter <chunkeey@gmail.com>

[ Upstream commit bd73a3dd257fb838bd456a18eeee0ef0224b7a40 ]

while compiling an ipq4019 target, dtc will complain:
regulator@b089000 unit address format error, expected "2089000"

The saw0 regulator reg value seems to be
copied and pasted from qcom-ipq8064.dtsi.

This patch fixes the reg value to match that of the
unit address which in turn silences the warning.
(There is no driver for qcom,saw2 right now.
So this went unnoticed)

Signed-off-by: Christian Lamparter <chunkeey@gmail.com>
Signed-off-by: John Crispin <john@phrozen.org>
Signed-off-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom-ipq4019.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom-ipq4019.dtsi b/arch/arm/boot/dts/qcom-ipq4019.dtsi
index 54d056b01bb51..8328ad589e2ba 100644
--- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
@@ -313,7 +313,7 @@
 
                 saw0: regulator@b089000 {
                         compatible = "qcom,saw2";
-                        reg = <0x02089000 0x1000>, <0x0b009000 0x1000>;
+			reg = <0x0b089000 0x1000>, <0x0b009000 0x1000>;
                         regulator;
                 };
 
-- 
2.20.1



