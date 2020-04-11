Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C26E1A5910
	for <lists+stable@lfdr.de>; Sun, 12 Apr 2020 01:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729187AbgDKXJT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 19:09:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729184AbgDKXJT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 19:09:19 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 920AA2173E;
        Sat, 11 Apr 2020 23:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646559;
        bh=YwOEWJys0ZVCDYmhC/244uFd8fv9w4ppVjzDJ/nl4ZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ujURSf7l3CSZjZgFvkj37Emj6VO8/XJqSL5xJrUh6p9trrnEjTAOObjJIyCKYf53w
         72HcwvaNXMSrIsHXrZ399k5Lvau035PX2KJDyBxs9E9gjsvjYr+7m7wmKFb3ndqW9W
         n0ii6FpWyeJSsbhGz4gQElWFevY68W3b3Sk6arlQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stephan Gerhold <stephan@gerhold.net>,
        Michael Srba <Michael.Srba@seznam.cz>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 108/121] arm64: dts: qcom: msm8916-samsung-a2015: Reserve Samsung firmware memory
Date:   Sat, 11 Apr 2020 19:06:53 -0400
Message-Id: <20200411230706.23855-108-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephan Gerhold <stephan@gerhold.net>

[ Upstream commit 8f4a7a00c1019df72cda3002643fb5823ef39183 ]

At the moment, writing large amounts of data to the eMMC causes the device
to freeze. The symptoms vary, sometimes the device reboots immediately,
but usually it will just get stuck.

It turns out that the issue is not actually related to the eMMC:
Apparently, Samsung has made some modifications to the TrustZone firmware.
These require additional memory which is reserved at 0x85500000-0x86000000.
The downstream kernel describes this memory reservation as:

/* Additionally Reserved 6MB for TIMA and Increased the TZ app size
 * by 2MB [total 8 MB ]
 */

This suggests that it is used for additional TZ apps, although the extra
memory is actually 11 MB instead of the 8 MB mentioned in the comment.

Writing to the protected memory causes the kernel to crash or freeze.
In our case, writing to the eMMC causes the disk cache to fill
the available RAM, until the kernel eventually crashes
when attempting to use the reserved memory.

Add the additional memory as reserved-memory to fix this problem.

Fixes: 1329c1ab0730 ("arm64: dts: qcom: Add device tree for Samsung Galaxy A3U/A5U")
Reported-by: Michael Srba <Michael.Srba@seznam.cz>
Tested-by: Michael Srba <Michael.Srba@seznam.cz> # a3u
Tested-by: Stephan Gerhold <stephan@gerhold.net> # a5u
Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
Link: https://lore.kernel.org/r/20191231112511.83342-1-stephan@gerhold.net
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/qcom/msm8916-samsung-a2015-common.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8916-samsung-a2015-common.dtsi b/arch/arm64/boot/dts/qcom/msm8916-samsung-a2015-common.dtsi
index bd1eb3eeca53f..43c5e0f882f14 100644
--- a/arch/arm64/boot/dts/qcom/msm8916-samsung-a2015-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916-samsung-a2015-common.dtsi
@@ -15,6 +15,14 @@
 		stdout-path = "serial0";
 	};
 
+	reserved-memory {
+		/* Additional memory used by Samsung firmware modifications */
+		tz-apps@85500000 {
+			reg = <0x0 0x85500000 0x0 0xb00000>;
+			no-map;
+		};
+	};
+
 	soc {
 		sdhci@7824000 {
 			status = "okay";
-- 
2.20.1

