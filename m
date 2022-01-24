Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143D2499A85
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573296AbiAXVor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1455569AbiAXVfk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:35:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F30C05A186;
        Mon, 24 Jan 2022 12:22:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B6ECB8122D;
        Mon, 24 Jan 2022 20:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DD7C340E7;
        Mon, 24 Jan 2022 20:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055746;
        bh=kOahFSvEW43v6s3fzF/seoeZFzaSHPDFkEhMXFiTIMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmsPccyqcWxMyDRXCgMtVB9K1001TSoMPV+mpZ/oLNB655FyAqSgbVWL70hAtkE/R
         tuoOUUCZ/iN9rOiDtacCnlScVks2bKjDex9rdOJnGeQpHrtNCQ230tFgq0Gw9WG05W
         hSuduQfpchjWGWO2sf/KOJZwx1AlzHC1uXu2ieXk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Steev Klimaszewski <steev@kali.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 251/846] arm64: dts: qcom: c630: Fix soundcard setup
Date:   Mon, 24 Jan 2022 19:36:08 +0100
Message-Id: <20220124184109.603304599@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

[ Upstream commit c02b360ca67ebeb9de07b47b2fe53f964c2561d1 ]

Currently Soundcard has 1 rx device for headset and SoundWire Speaker Playback.

This setup has issues, ex if we try to play on headset the audio stream is
also sent to SoundWire Speakers and we will hear sound in both headsets and speakers.

Make a separate device for Speakers and Headset so that the streams are
different and handled properly.

Fixes: 45021d35fcb2 ("arm64: dts: qcom: c630: Enable audio support")
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Tested-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211209175342.20386-2-srinivas.kandagatla@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sdm850-lenovo-yoga-c630.dts | 27 +++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index 2ba23aa582a18..617a634ac9051 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -518,6 +518,10 @@
 	dai@1 {
 		reg = <1>;
 	};
+
+	dai@2 {
+		reg = <2>;
+	};
 };
 
 &sound {
@@ -530,6 +534,7 @@
 		"SpkrLeft IN", "SPK1 OUT",
 		"SpkrRight IN", "SPK2 OUT",
 		"MM_DL1",  "MultiMedia1 Playback",
+		"MM_DL3",  "MultiMedia3 Playback",
 		"MultiMedia2 Capture", "MM_UL2";
 
 	mm1-dai-link {
@@ -546,6 +551,13 @@
 		};
 	};
 
+	mm3-dai-link {
+		link-name = "MultiMedia3";
+		cpu {
+			sound-dai = <&q6asmdai  MSM_FRONTEND_DAI_MULTIMEDIA3>;
+		};
+	};
+
 	slim-dai-link {
 		link-name = "SLIM Playback";
 		cpu {
@@ -575,6 +587,21 @@
 			sound-dai = <&wcd9340 1>;
 		};
 	};
+
+	slim-wcd-dai-link {
+		link-name = "SLIM WCD Playback";
+		cpu {
+			sound-dai = <&q6afedai SLIMBUS_1_RX>;
+		};
+
+		platform {
+			sound-dai = <&q6routing>;
+		};
+
+		codec {
+			sound-dai =  <&wcd9340 2>;
+		};
+	};
 };
 
 &tlmm {
-- 
2.34.1



