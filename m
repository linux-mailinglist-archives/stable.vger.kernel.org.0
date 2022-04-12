Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B91224FD435
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353018AbiDLHhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:37:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351981AbiDLHdY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:33:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 104A6506C4;
        Tue, 12 Apr 2022 00:08:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42C0FB81B50;
        Tue, 12 Apr 2022 07:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC346C385A6;
        Tue, 12 Apr 2022 07:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747320;
        bh=Y4PFYmdYR2WjNP0fkjHUgXF9wtFrae+g7GdxMfughyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BZq+KfL0wF8eemamMOkiiuToXGYGw+1E6QSrwcFTiNNqwe7K+hn40kXFG8H40Mlym
         oU7UjSobPJCwjd0AaNbqDnZ7TNPYOxvep0jqNiREru7hEIhE2vw9nme6C8bj1oNZOu
         nBZCFQDO/lo/FHXGNAep8lgPhIF4Oh3o1zlXHqL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Kiselev <bigunclemax@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 037/343] powerpc: dts: t104xrdb: fix phy type for FMAN 4/5
Date:   Tue, 12 Apr 2022 08:27:35 +0200
Message-Id: <20220412062952.177770405@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Maxim Kiselev <bigunclemax@gmail.com>

[ Upstream commit 17846485dff91acce1ad47b508b633dffc32e838 ]

T1040RDB has two RTL8211E-VB phys which requires setting
of internal delays for correct work.

Changing the phy-connection-type property to `rgmii-id`
will fix this issue.

Signed-off-by: Maxim Kiselev <bigunclemax@gmail.com>
Reviewed-by: Maxim Kochetkov <fido_max@inbox.ru>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211230151123.1258321-1-bigunclemax@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/fsl/t104xrdb.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/boot/dts/fsl/t104xrdb.dtsi b/arch/powerpc/boot/dts/fsl/t104xrdb.dtsi
index 099a598c74c0..bfe1ed5be337 100644
--- a/arch/powerpc/boot/dts/fsl/t104xrdb.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t104xrdb.dtsi
@@ -139,12 +139,12 @@
 		fman@400000 {
 			ethernet@e6000 {
 				phy-handle = <&phy_rgmii_0>;
-				phy-connection-type = "rgmii";
+				phy-connection-type = "rgmii-id";
 			};
 
 			ethernet@e8000 {
 				phy-handle = <&phy_rgmii_1>;
-				phy-connection-type = "rgmii";
+				phy-connection-type = "rgmii-id";
 			};
 
 			mdio0: mdio@fc000 {
-- 
2.35.1



