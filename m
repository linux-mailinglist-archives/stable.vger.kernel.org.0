Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC4D49A989
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349338AbiAYDXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386940AbiAXUgK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:36:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00339C038AE5;
        Mon, 24 Jan 2022 11:49:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90EF7B81188;
        Mon, 24 Jan 2022 19:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3381C340E5;
        Mon, 24 Jan 2022 19:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053757;
        bh=7YyOM7VdATn/fg3G6KlcXEwxLFCFISDdhKejS+MmA9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yawm2nGOFkXKYy/9nAAd3bU+ILtMEI4lTDO6+hjONWijnfFMHOFyggdx59G+Dyppb
         Ft7eT/UUtJCGJMZoDdQQIUrfaQNwbimXudbnbTd9FqR7a5kf9E3VAqLiboYTbiTYtZ
         80JyVlnZ9yCA+KK2t0G6WbDBsGCPQLFDqmxJOqRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Steev Klimaszewski <steev@kali.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 167/563] arm64: dts: qcom: c630: Fix soundcard setup
Date:   Mon, 24 Jan 2022 19:38:52 +0100
Message-Id: <20220124184030.178934142@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index ad6561843ba28..e080c317b5e3d 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -365,6 +365,10 @@
 	dai@1 {
 		reg = <1>;
 	};
+
+	dai@2 {
+		reg = <2>;
+	};
 };
 
 &sound {
@@ -377,6 +381,7 @@
 		"SpkrLeft IN", "SPK1 OUT",
 		"SpkrRight IN", "SPK2 OUT",
 		"MM_DL1",  "MultiMedia1 Playback",
+		"MM_DL3",  "MultiMedia3 Playback",
 		"MultiMedia2 Capture", "MM_UL2";
 
 	mm1-dai-link {
@@ -393,6 +398,13 @@
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
@@ -422,6 +434,21 @@
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



