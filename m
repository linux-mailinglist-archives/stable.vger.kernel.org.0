Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 021C832861B
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236439AbhCARDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:03:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:59154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236130AbhCAQ6K (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:58:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D44364F65;
        Mon,  1 Mar 2021 16:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616588;
        bh=xHIS3f7IVQbX/I+qb3d7v0ky17cFljNRsAtv1yNGOoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ccrvyguqgK9HPHHBu5kHKyiBdT7u2kpjGa9OPFBoaApDGW62PY1gVSV8ZoTIpTxHv
         lfOvR8AZlo4m7v8yI2IXBNov3zhYvN7Voa++ZAsrBCB1ksrNqfdcZKINQa99hbGjDZ
         DK1dEhPcoOF24WQvPsSAkupN6w6ps07Xs/SGXvgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameer Pujar <spujar@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 4.19 005/247] arm64: tegra: Add power-domain for Tegra210 HDA
Date:   Mon,  1 Mar 2021 17:10:25 +0100
Message-Id: <20210301161031.956200446@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
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
@@ -826,6 +826,7 @@
 			 <&tegra_car 128>, /* hda2hdmi */
 			 <&tegra_car 111>; /* hda2codec_2x */
 		reset-names = "hda", "hda2hdmi", "hda2codec_2x";
+		power-domains = <&pd_sor>;
 		status = "disabled";
 	};
 


