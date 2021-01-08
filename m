Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42782EED85
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 07:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbhAHGme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 01:42:34 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:3466 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbhAHGme (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 01:42:34 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5ff7feb10000>; Thu, 07 Jan 2021 22:41:53 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 8 Jan
 2021 06:41:52 +0000
Received: from jckuo-lt.nvidia.com (172.20.145.6) by mail.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server id 15.0.1473.3 via Frontend
 Transport; Fri, 8 Jan 2021 06:41:50 +0000
From:   JC Kuo <jckuo@nvidia.com>
To:     <mathias.nyman@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <thierry.reding@gmail.com>, <jonathanh@nvidia.com>,
        <robh@kernel.org>
CC:     <linux-tegra@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <nkristam@nvidia.com>, <stable@vger.kernel.org>,
        JC Kuo <jckuo@nvidia.com>
Subject: [PATCH v2] xhci: tegra: Delay for disabling LFPS detector
Date:   Fri, 8 Jan 2021 14:41:48 +0800
Message-ID: <20210108064148.26766-1-jckuo@nvidia.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-NVConfidentiality: public
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1610088113; bh=pczClffUlnMYECBb52f5ayAnqt859pvkCJeq1rn2FTQ=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:MIME-Version:
         X-NVConfidentiality:Content-Transfer-Encoding:Content-Type;
        b=eoLjhqaXttCCV9F88l1SH+B0VEfLHw/1twmDD2ElY/juSHvJeOMYCxKb4jPi9Xntb
         EWqW+/NBiwxQr1WP8zVU9/TzBzt5ia5X2NGmUVcbIZ57wDLs1DxSPF8eWGLY3pfNku
         knsNU08gNzr09MH1Ki9d5ZPc7DWomlkTwL8WlGmCxbwg7l4meYuys4QzzhwMn9Pz0l
         qIaBJFOB+XE9O+3tWT0yZ6Shv9g7cvtiWSB7+Dl+EAiBFmM5V8/dWAJwPTR4/BRgWY
         ghEWpPiQ5smY3AD6xPv2KvWtbqFsBnTTlwZJ5/F2j1jBgEnc/9uLR2od3MFTGoYiCd
         KModYdqZU1yDw==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Occasionally, we are seeing some SuperSpeed devices resumes right after
being directed to U3. This commits add 500us delay to ensure LFPS
detector is disabled before sending ACK to firmware.

[   16.099363] tegra-xusb 70090000.usb: entering ELPG
[   16.104343] tegra-xusb 70090000.usb: 2-1 isn't suspended: 0x0c001203
[   16.114576] tegra-xusb 70090000.usb: not all ports suspended: -16
[   16.120789] tegra-xusb 70090000.usb: entering ELPG failed

The register write passes through a few flop stages of 32KHz clock domain.
NVIDIA ASIC designer reviewed RTL and suggests 500us delay.

Cc: stable@vger.kernel.org
Signed-off-by: JC Kuo <jckuo@nvidia.com>
---
 drivers/usb/host/xhci-tegra.c | 6 ++++++
 1 file changed, 6 insertions(+)

changes in v2:=20
    describes how 500us was determined in commit message
    cc stable@vger.kernel.org

diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
index 934be1686352..20cdc11f7dc6 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -623,6 +623,12 @@ static void tegra_xusb_mbox_handle(struct tegra_xusb *=
tegra,
 								     enable);
 			if (err < 0)
 				break;
+
+			/*
+			 * wait 500us for LFPS detector to be disabled before sending ACK
+			 */
+			if (!enable)
+				usleep_range(500, 1000);
 		}
=20
 		if (err < 0) {
--=20
2.25.1

