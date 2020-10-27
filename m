Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF4E629B9AB
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1802695AbgJ0Puy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:50:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:43740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1802359AbgJ0Pqb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:46:31 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 247EC21D42;
        Tue, 27 Oct 2020 15:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813590;
        bh=V6MQEupNqkeHYdnaJItOH2zf0i2aYj1g8e3cKMZ8rp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxRbFu9GyHSyaWhFQw1yzBttULsxuoLv3+WQgSFQZDqiKNFyYj7bnIQI1kpYEHqG8
         geMty1ywSlvgXNvGzfguOKlkZzsNHS/8m2rutGzpzmTQC82esy/wX8Z8uw23pn8i6M
         Yswjl/VjvGqyHxH6OxsBgTyat47FeHtTEP/dEd74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Pundir <amit.pundir@linaro.org>,
        John Stultz <john.stultz@linaro.org>,
        Steev Klimaszewski <steev@kali.org>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 603/757] arm64: dts: sdm845: Fixup OPP table for all qup devices
Date:   Tue, 27 Oct 2020 14:54:13 +0100
Message-Id: <20201027135518.828227651@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rajendra Nayak <rnayak@codeaurora.org>

[ Upstream commit e0b760a5f6c9e54db8bd22b1d6b19223e6b92264 ]

This OPP table was based on the clock VDD-FMAX tables seen in
downstream code, however it turns out the downstream clock
driver does update these tables based on later/production
rev of the chip and whats seen in the tables belongs to an
early engineering rev of the SoC.
Fix up the OPP tables such that it now matches with the
production rev of sdm845 SoC.

Tested-by: Amit Pundir <amit.pundir@linaro.org>
Tested-by: John Stultz <john.stultz@linaro.org>
Tested-by: Steev Klimaszewski <steev@kali.org>
Fixes: 13cadb34e593 ("arm64: dts: sdm845: Add OPP table for all qup devices")
Reported-by: John Stultz <john.stultz@linaro.org>
Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
Link: https://lore.kernel.org/r/1597227730-16477-1-git-send-email-rnayak@codeaurora.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index 2884577dcb777..eca81cffd2c19 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -1093,8 +1093,8 @@ rng: rng@793000 {
 		qup_opp_table: qup-opp-table {
 			compatible = "operating-points-v2";
 
-			opp-19200000 {
-				opp-hz = /bits/ 64 <19200000>;
+			opp-50000000 {
+				opp-hz = /bits/ 64 <50000000>;
 				required-opps = <&rpmhpd_opp_min_svs>;
 			};
 
@@ -1107,6 +1107,11 @@ opp-100000000 {
 				opp-hz = /bits/ 64 <100000000>;
 				required-opps = <&rpmhpd_opp_svs>;
 			};
+
+			opp-128000000 {
+				opp-hz = /bits/ 64 <128000000>;
+				required-opps = <&rpmhpd_opp_nom>;
+			};
 		};
 
 		qupv3_id_0: geniqup@8c0000 {
-- 
2.25.1



