Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50593324D98
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 11:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbhBYKGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 05:06:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235115AbhBYKBp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 05:01:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBB6E64F2D;
        Thu, 25 Feb 2021 09:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246978;
        bh=fBlnvMMfjEELxcWjR0KXlBriOmBFrle+QhYoTAUOrjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i5uXZpHdVjY+IThyxPOy0SfDSDkBhUHChN/TRdE8mU6nfDs4rh5+Cn57wY7PumZnH
         A7MbXd2PAlMWTcwPg4Y7VsXL1ET0NdKYrgm6Xq91DnMQ7COQgrafWF2C2XdZyznRDf
         sG7iVBeFePcW7UnK74ZpG39EZj9Vl3YBSPhicplE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameer Pujar <spujar@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 5.4 06/17] arm64: tegra: Add power-domain for Tegra210 HDA
Date:   Thu, 25 Feb 2021 10:53:51 +0100
Message-Id: <20210225092515.316740451@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092515.001992375@linuxfoundation.org>
References: <20210225092515.001992375@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameer Pujar <spujar@nvidia.com>

commit 1e0ca5467445bc1f41a9e403d6161a22f313dae7 upstream.

HDA initialization is failing occasionally on Tegra210 and following
print is observed in the boot log. Because of this probe() fails and
no sound card is registered.

  [16.800802] tegra-hda 70030000.hda: no codecs found!

Codecs request a state change and enumeration by the controller. In
failure cases this does not seem to happen as STATETS register reads 0.

The problem seems to be related to the HDA codec dependency on SOR
power domain. If it is gated during HDA probe then the failure is
observed. Building Tegra HDA driver into kernel image avoids this
failure but does not completely address the dependency part. Fix this
problem by adding 'power-domains' DT property for Tegra210 HDA. Note
that Tegra186 and Tegra194 HDA do this already.

Fixes: 742af7e7a0a1 ("arm64: tegra: Add Tegra210 support")
Depends-on: 96d1f078ff0 ("arm64: tegra: Add SOR power-domain for Tegra210")
Cc: <stable@vger.kernel.org>
Signed-off-by: Sameer Pujar <spujar@nvidia.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/nvidia/tegra210.dtsi |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/boot/dts/nvidia/tegra210.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210.dtsi
@@ -917,6 +917,7 @@
 			 <&tegra_car 128>, /* hda2hdmi */
 			 <&tegra_car 111>; /* hda2codec_2x */
 		reset-names = "hda", "hda2hdmi", "hda2codec_2x";
+		power-domains = <&pd_sor>;
 		status = "disabled";
 	};
 


