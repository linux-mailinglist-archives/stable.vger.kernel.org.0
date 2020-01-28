Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 386E514BA96
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:40:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbgA1OQX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:16:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730287AbgA1OQV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:16:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB4D121739;
        Tue, 28 Jan 2020 14:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220980;
        bh=Asem7IW4pfnaVsHKtykisjf36XKgnSCDpm8rUQf2wXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IE53oZX9majYpLQHXVd2c1AhELpG2T1QQehYsTNTQN1kFF/faljH/RRRR0kz8epGb
         xYwxnaUk81YtihadXDECcm2SVzGNftFaeuFtkm5UB2o5z1qF7JMshqjD6s9ZOQ68io
         Hn2jNQ6n6hTiFyvJfKE47l2+tBfwb9lmhgQHh4po=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Manabu Igusa <migusa@arrowjapan.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 041/271] arm64: dts: apq8016-sbc: Increase load on l11 for SDCARD
Date:   Tue, 28 Jan 2020 15:03:10 +0100
Message-Id: <20200128135855.719683117@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
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
index 601be6127628a..948efff7d830c 100644
--- a/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
+++ b/arch/arm64/boot/dts/qcom/apq8016-sbc.dtsi
@@ -355,6 +355,8 @@
 	l11 {
 		regulator-min-microvolt = <1750000>;
 		regulator-max-microvolt = <3337000>;
+		regulator-allow-set-load;
+		regulator-system-load = <200000>;
 	};
 
 	l12 {
-- 
2.20.1



