Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC8E2147BE7
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387645AbgAXJrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:47:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387474AbgAXJrR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:47:17 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBF4720718;
        Fri, 24 Jan 2020 09:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859236;
        bh=o+1zk+zzVpUuf6g8Fni7n0uZyouibd7QiiosuG0Zudo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OLNPzRhWxE2wv+O3gXqt2PyL5aObii7uzpKKOmgqi5MqUFkl148AHHLSV7+o47HVy
         dcyUEpnAO/6uGsCHWZ7xE2IDNQJKYlqhuYoUaIPYz6TA5qFmyhgGKJNZT/J7ABRKB7
         HrgqYiE5R7N+4+31mzXknw+lu86U/S/ia0L3zTDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manabu Igusa <migusa@arrowjapan.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 061/343] arm64: dts: apq8016-sbc: Increase load on l11 for SDCARD
Date:   Fri, 24 Jan 2020 10:27:59 +0100
Message-Id: <20200124092927.874227485@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

[ Upstream commit af61bef513ba179559e56908b8c465e587bc3890 ]

In the same way as for msm8974-hammerhead, l11 load, used for SDCARD
VMMC, needs to be increased in order to prevent any voltage drop issues
(due to limited current) happening with some SDCARDS or during specific
operations (e.g. write).

Tested on Dragonboard-410c and DART-SD410 boards.

Fixes: 4c7d53d16d77 (arm64: dts: apq8016-sbc: add regulators support)
Reported-by: Manabu Igusa <migusa@arrowjapan.com>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi b/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
index b6b44fdf7face..c1028b47edde9 100644
--- a/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
+++ b/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
@@ -458,6 +458,8 @@
 	l11 {
 		regulator-min-microvolt = <1750000>;
 		regulator-max-microvolt = <3337000>;
+		regulator-allow-set-load;
+		regulator-system-load = <200000>;
 	};
 
 	l12 {
-- 
2.20.1



