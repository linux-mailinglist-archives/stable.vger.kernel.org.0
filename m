Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 976A3499797
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:29:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448804AbiAXVNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:13:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59964 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1446212AbiAXVHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:07:35 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C957561425;
        Mon, 24 Jan 2022 21:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C2BC340E8;
        Mon, 24 Jan 2022 21:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058454;
        bh=DX+nFBJs/yKtyiEOKkXjDicl5+9iBgWUYkW0pg5pwmk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UcgmLeFWWARiCVxFiKjehv0+7jlcStqKEQpK2lCe+2iBhCoQUI32I8JwZpwSNJHXa
         hItF1jcvXxOHRqMdrcExSM6lbcuNpjQrCPeV98piGGe6yurFG3ea5/pqdvQ9SZaUkU
         2YaRmLCwWtWFcOjFU09v/79TQjdpat2xO3V+h84I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Steev Klimaszewski <steev@kali.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0293/1039] arm64: dts: qcom: c630: Fix soundcard setup
Date:   Mon, 24 Jan 2022 19:34:42 +0100
Message-Id: <20220124184135.128752743@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index d6b2ba4396f68..2e882a977e2c4 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -523,6 +523,10 @@
 	dai@1 {
 		reg = <1>;
 	};
+
+	dai@2 {
+		reg = <2>;
+	};
 };
 
 &sound {
@@ -535,6 +539,7 @@
 		"SpkrLeft IN", "SPK1 OUT",
 		"SpkrRight IN", "SPK2 OUT",
 		"MM_DL1",  "MultiMedia1 Playback",
+		"MM_DL3",  "MultiMedia3 Playback",
 		"MultiMedia2 Capture", "MM_UL2";
 
 	mm1-dai-link {
@@ -551,6 +556,13 @@
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
@@ -580,6 +592,21 @@
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



