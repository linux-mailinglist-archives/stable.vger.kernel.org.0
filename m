Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68AE11015F5
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730644AbfKSFs4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:48:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731414AbfKSFsz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:48:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D41C20862;
        Tue, 19 Nov 2019 05:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142534;
        bh=UJIkCko1T/uvwuZdVtUds6NrBGotpYuWsGiGTTT/KO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aRhnQopHcQQyDcP7+M/8tDuJ/59UVvm+pB9mvVKWInvkwiuwQ4m79s2Xw87eL9ZNL
         lcKpejqg2r+mgCeWdKZiNoNMokNpVJsAgtj63UTmefKTsdMTsdsj4+Pn+uZf7UQYFL
         Ukhfy/pOHhiaQyu9YDSJzjIaovtck9Sxz8xNOuJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Lamparter <chunkeey@gmail.com>,
        John Crispin <john@phrozen.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 113/239] ARM: dts: qcom: ipq4019: fix cpu0s qcom,saw2 reg value
Date:   Tue, 19 Nov 2019 06:18:33 +0100
Message-Id: <20191119051328.435735112@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
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
index 10d112a4078ec..19156cbb60034 100644
--- a/arch/arm/boot/dts/qcom-ipq4019.dtsi
+++ b/arch/arm/boot/dts/qcom-ipq4019.dtsi
@@ -234,7 +234,7 @@
 
                 saw0: regulator@b089000 {
                         compatible = "qcom,saw2";
-                        reg = <0x02089000 0x1000>, <0x0b009000 0x1000>;
+			reg = <0x0b089000 0x1000>, <0x0b009000 0x1000>;
                         regulator;
                 };
 
-- 
2.20.1



