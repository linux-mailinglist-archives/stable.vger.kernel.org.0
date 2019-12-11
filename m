Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8C8011B838
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbfLKPHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:07:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:54936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730076AbfLKPHo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:07:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38F7720663;
        Wed, 11 Dec 2019 15:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076863;
        bh=lLytQxX7qdL6iU0dEIKBgm6bxyJ3D/XPmqK/cZk5ARA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2OpVGEDDSlICJ4KZigthYH5XKeatgIZCPOwwsFWA6hV3Sj/mMbN5PpMLivvn8BuZ
         aR84DlKD9sMSKv7E9E28mH3sV8ceGdzUmfrK/lvv5fivGB+ZdvjA8soZzP7vUupONs
         OG2WpjdNDhOP33G37XVGPXLMt6aOkUGJCsKhez4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.4 02/92] arm64: tegra: Fix active-low warning for Jetson TX1 regulator
Date:   Wed, 11 Dec 2019 16:04:53 +0100
Message-Id: <20191211150222.535121261@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Hunter <jonathanh@nvidia.com>

commit 1e5e929c009559bd7e898ac8e17a5d01037cb057 upstream.

Commit 34993594181d ("arm64: tegra: Enable HDMI on Jetson TX1")
added a regulator for HDMI on the Jetson TX1 platform. This regulator
has an active high enable, but the GPIO specifier for enabling the
regulator incorrectly defines it as active-low. This causes the
following warning to occur on boot ...

 WARNING KERN regulator@10 GPIO handle specifies active low - ignored

The fixed-regulator binding does not use the active-low flag from the
gpio specifier and purely relies of the presence of the
'enable-active-high' property to determine if it is active high or low
(if this property is omitted). Fix this warning by setting the GPIO
to active-high in the GPIO specifier which aligns with the presense of
the 'enable-active-high' property.

Fixes: 34993594181d ("arm64: tegra: Enable HDMI on Jetson TX1")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2597.dtsi
@@ -1612,7 +1612,7 @@
 			regulator-name = "VDD_HDMI_5V0";
 			regulator-min-microvolt = <5000000>;
 			regulator-max-microvolt = <5000000>;
-			gpio = <&exp1 12 GPIO_ACTIVE_LOW>;
+			gpio = <&exp1 12 GPIO_ACTIVE_HIGH>;
 			enable-active-high;
 			vin-supply = <&vdd_5v0_sys>;
 		};


