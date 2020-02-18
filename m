Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93D8B1631DD
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729082AbgBRUDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:03:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729075AbgBRUDK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:03:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8FD1424673;
        Tue, 18 Feb 2020 20:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056190;
        bh=vnKENgL2erzlXMxnhaMBf4SD/3+ntQcfdelWp6Lmqck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUAxgdGH/T18pTpSFOWb574lAhIMrIVY6YOgOOO2vBBGKrUWYPGqrJRQikNeCvk5U
         7ba4uaXQnrGX6Mu/gMJmhke8LwXdTeent5+TRbyH597bb1fAQ/27IBjsFTKlJ7/kFv
         qD9eS/ueQD7vbO9KuXGw44opJX1NCVZRLks1r4do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 5.5 68/80] arm64: dts: fast models: Fix FVP PCI interrupt-map property
Date:   Tue, 18 Feb 2020 20:55:29 +0100
Message-Id: <20200218190438.456542324@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Zyngier <maz@kernel.org>

commit 3543d7ddd55fe12c37e8a9db846216c51846015b upstream.

The interrupt map for the FVP's PCI node is missing the
parent-unit-address cells for each of the INTx entries, leading to the
kernel code failing to parse the entries correctly.

Add the missing zero cells, which are pretty useless as far as the GIC
is concerned, but that the spec requires. This allows INTx to be usable
on the model, and VFIO to work correctly.

Fixes: fa083b99eb28 ("arm64: dts: fast models: Add DTS fo Base RevC FVP")
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/arm/fvp-base-revc.dts |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/boot/dts/arm/fvp-base-revc.dts
+++ b/arch/arm64/boot/dts/arm/fvp-base-revc.dts
@@ -161,10 +161,10 @@
 		bus-range = <0x0 0x1>;
 		reg = <0x0 0x40000000 0x0 0x10000000>;
 		ranges = <0x2000000 0x0 0x50000000 0x0 0x50000000 0x0 0x10000000>;
-		interrupt-map = <0 0 0 1 &gic GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 0 2 &gic GIC_SPI 169 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 0 3 &gic GIC_SPI 170 IRQ_TYPE_LEVEL_HIGH>,
-				<0 0 0 4 &gic GIC_SPI 171 IRQ_TYPE_LEVEL_HIGH>;
+		interrupt-map = <0 0 0 1 &gic 0 0 GIC_SPI 168 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 0 2 &gic 0 0 GIC_SPI 169 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 0 3 &gic 0 0 GIC_SPI 170 IRQ_TYPE_LEVEL_HIGH>,
+				<0 0 0 4 &gic 0 0 GIC_SPI 171 IRQ_TYPE_LEVEL_HIGH>;
 		interrupt-map-mask = <0x0 0x0 0x0 0x7>;
 		msi-map = <0x0 &its 0x0 0x10000>;
 		iommu-map = <0x0 &smmu 0x0 0x10000>;


