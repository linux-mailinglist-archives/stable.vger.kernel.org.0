Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8B055E2BB
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238861AbiF0Lyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:54:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238724AbiF0Lwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:52:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE2E9B861;
        Mon, 27 Jun 2022 04:45:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BB72B80DFB;
        Mon, 27 Jun 2022 11:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5236C3411D;
        Mon, 27 Jun 2022 11:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656330315;
        bh=aZ0O5akKHbX55ZjLw6xNMWNs4NL+9/Yl+dEshmlvhnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fYQRIN/W0Nwllt3dNlC67fmZEWFcek2vwWqFfoaTmG6j8bJUJFgvCsK92R5BmN0vF
         H6D3mLy/snLrIByA952Kc4XOqn88pxT7GcvISV6RIkd3mPKVgHWfDR72TakDHeyage
         VZEuywiXJTy3Hsx+NbGPwtKw9ibF9+UM7kNx3CqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-stable@vger.kernel.org,
        Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Nishanth Menon <nm@ti.com>, Matt Ranostay <mranostay@ti.com>
Subject: [PATCH 5.18 156/181] arm64: dts: ti: k3-j721s2: Fix overlapping GICD memory region
Date:   Mon, 27 Jun 2022 13:22:09 +0200
Message-Id: <20220627111949.208954690@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matt Ranostay <mranostay@ti.com>

commit 856216b70a41ff3f8c866b627546afa01567b389 upstream.

GICD region was overlapping with GICR causing the latter to not map
successfully, and in turn the gic-v3 driver would fail to initialize.

This issue was hidden till commit 2b2cd74a06c3 ("irqchip/gic-v3: Claim
iomem resources") replaced of_iomap() calls with of_io_request_and_map()
that internally called request_mem_region().

Respective console output before this patchset:

[    0.000000] GICv3: /bus@100000/interrupt-controller@1800000: couldn't map region 0

Fixes: b8545f9d3a54 ("arm64: dts: ti: Add initial support for J721S2 SoC")
Cc: linux-stable@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Nishanth Menon <nm@ti.com>
Signed-off-by: Matt Ranostay <mranostay@ti.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20220617151304.446607-1-mranostay@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j721s2-main.dtsi
@@ -33,7 +33,7 @@
 		ranges;
 		#interrupt-cells = <3>;
 		interrupt-controller;
-		reg = <0x00 0x01800000 0x00 0x200000>, /* GICD */
+		reg = <0x00 0x01800000 0x00 0x100000>, /* GICD */
 		      <0x00 0x01900000 0x00 0x100000>, /* GICR */
 		      <0x00 0x6f000000 0x00 0x2000>,   /* GICC */
 		      <0x00 0x6f010000 0x00 0x1000>,   /* GICH */


