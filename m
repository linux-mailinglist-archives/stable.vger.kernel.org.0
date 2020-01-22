Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73FC814500D
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733174AbgAVJn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:43:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:35974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387715AbgAVJn1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:43:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 745D12468C;
        Wed, 22 Jan 2020 09:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579686206;
        bh=2tlsQcBQTsqZUcrgW4yjKs3w3iSmEgYakIwCnX2Xn44=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g7M9DRka/lkUHsgAraFrSBGfYZXOk6V2RDwyqRAYmoQI6Qo5WUsp2VpLf6ZumlFML
         +qm9DzhVbe1yMTosbbL2CcDiQCG9GkQrsxqS1HvvCdKQNo81noX6cR9WFnOa+J7Fse
         /Y5VEhIOlHnik7emm06PhN/qysKoxDq+DzaUVUvo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 4.19 087/103] Revert "arm64: dts: juno: add dma-ranges property"
Date:   Wed, 22 Jan 2020 10:29:43 +0100
Message-Id: <20200122092815.449037179@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092803.587683021@linuxfoundation.org>
References: <20200122092803.587683021@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

commit 54fb3fe0f211d4729a2551cf9497bd612189af9d upstream.

This reverts commit 193d00a2b35ee3353813b4006a18131122087205.

Commit 951d48855d86 ("of: Make of_dma_get_range() work on bus nodes")
reworked the logic such that of_dma_get_range() works correctly
starting from a bus node containing "dma-ranges".

Since on Juno we don't have a SoC level bus node and "dma-ranges" is
present only in the root node, we get the following error:

OF: translation of DMA address(0) to CPU address failed node(/sram@2e000000)
OF: translation of DMA address(0) to CPU address failed node(/uart@7ff80000)
...
OF: translation of DMA address(0) to CPU address failed node(/mhu@2b1f0000)
OF: translation of DMA address(0) to CPU address failed node(/iommu@2b600000)
OF: translation of DMA address(0) to CPU address failed node(/iommu@2b600000)
OF: translation of DMA address(0) to CPU address failed node(/iommu@2b600000)

So let's fix it by dropping the "dma-ranges" property for now. This
should be fine since it doesn't represent any kind of device-visible
restriction; it was only there for completeness, and we've since given
in to the assumption that missing "dma-ranges" implies a 1:1 mapping
anyway.

We can add it later with a proper SoC bus node and moving all the
devices that belong there along with the "dma-ranges" if required.

Fixes: 193d00a2b35e ("arm64: dts: juno: add dma-ranges property")
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Liviu Dudau <liviu.dudau@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/boot/dts/arm/juno-base.dtsi |    1 -
 1 file changed, 1 deletion(-)

--- a/arch/arm64/boot/dts/arm/juno-base.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
@@ -6,7 +6,6 @@
 	/*
 	 *  Devices shared by all Juno boards
 	 */
-	dma-ranges = <0 0 0 0 0x100 0>;
 
 	memtimer: timer@2a810000 {
 		compatible = "arm,armv7-timer-mem";


