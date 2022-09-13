Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16345B6FF2
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233185AbiIMOUV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233387AbiIMOSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:18:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA771422DB;
        Tue, 13 Sep 2022 07:13:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 23E0C614AD;
        Tue, 13 Sep 2022 14:13:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301D6C433C1;
        Tue, 13 Sep 2022 14:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078417;
        bh=7B95i/Mb08UkbcQ6VvPgvAfVgeCIGs4fxEhdVSLHigs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgvDnNFW6LXmidcmoUTqUgsBMibcedrhVNcOXXT8CR7DXSAWtFqioOGrcG+84REOv
         L+RPK1UZ3FqixQMB+M+R8pVmXgd1v0OEyRBl6EyEVtjdbKa8samC3vt/gFGB3gmEmZ
         mACuUTW1CkKmozevPE3CtRr6LkTXSquzwi6ukWsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heinrich Schuchardt <heinrich.schuchardt@canonical.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 105/192] riscv: dts: microchip: use an mpfs specific l2 compatible
Date:   Tue, 13 Sep 2022 16:03:31 +0200
Message-Id: <20220913140415.200343560@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 0dec364ffeb6149aae572ded1e34d4b444c23be6 ]

PolarFire SoC does not have the same l2 cache controller as the fu540,
featuring an extra interrupt. Appease the devicetree checker overlords
by adding a PolarFire SoC specific compatible to fix the below sort of
warnings:

mpfs-polarberry.dtb: cache-controller@2010000: interrupts: [[1], [3], [4], [2]] is too long

Fixes: 0fa6107eca41 ("RISC-V: Initial DTS for Microchip ICICLE board")
Fixes: 34fc9cc3aebe ("riscv: dts: microchip: correct L2 cache interrupts")
Reviewed-by: Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/microchip/mpfs.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/microchip/mpfs.dtsi b/arch/riscv/boot/dts/microchip/mpfs.dtsi
index 9f5bce1488d93..9bf37ef379509 100644
--- a/arch/riscv/boot/dts/microchip/mpfs.dtsi
+++ b/arch/riscv/boot/dts/microchip/mpfs.dtsi
@@ -161,7 +161,7 @@
 		ranges;
 
 		cctrllr: cache-controller@2010000 {
-			compatible = "sifive,fu540-c000-ccache", "cache";
+			compatible = "microchip,mpfs-ccache", "sifive,fu540-c000-ccache", "cache";
 			reg = <0x0 0x2010000 0x0 0x1000>;
 			cache-block-size = <64>;
 			cache-level = <2>;
-- 
2.35.1



