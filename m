Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A355B702F
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233257AbiIMOUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiIMOTb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:19:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EAB65571;
        Tue, 13 Sep 2022 07:14:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D848DB80F4B;
        Tue, 13 Sep 2022 14:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35EA5C433D6;
        Tue, 13 Sep 2022 14:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078348;
        bh=XufkPb03Ew3QVVYzK6+sMc/4T34BYwP0B9psvQAbfv0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=naAAQ0e5a7/MgHIFSYpvTyRGDtuLuDsIntUBiD75mrEyMQsJ7jXE5QwzW+czM5XrY
         jkQ0/kenw/Dtm94yq1QlIeXM1WGX8JODSfgbCcLluwmlgrZAz8KuWF7e/ehzEXkPzL
         yXY/boQEo9fEg6PrnZ+JGb8wADL767I6svdhzjkU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 078/192] arm64: dts: ls1028a-qds-65bb: dont use in-band autoneg for 2500base-x
Date:   Tue, 13 Sep 2022 16:03:04 +0200
Message-Id: <20220913140413.848808600@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit e7406f864e765c564c5cf384464faff66114f97d ]

The Lynx PCS integrated with ENETC port 0 does not support in-band
autoneg for the 2500base-x SERDES protocol, and prints errors from its
phylink methods. Furthermore, the AQR112 card used for these boards does
not expect in-band autoneg either. So delete the extraneous property.

Fixes: e426d63e752b ("arm64: dts: ls1028a-qds: add overlays for various serdes protocols")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/fsl-ls1028a-qds-65bb.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds-65bb.dts b/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds-65bb.dts
index 40d34c8384a5e..b949cac037427 100644
--- a/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds-65bb.dts
+++ b/arch/arm64/boot/dts/freescale/fsl-ls1028a-qds-65bb.dts
@@ -25,7 +25,6 @@
 &enetc_port0 {
 	phy-handle = <&slot1_sgmii>;
 	phy-mode = "2500base-x";
-	managed = "in-band-status";
 	status = "okay";
 };
 
-- 
2.35.1



