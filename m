Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A207E658444
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:57:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234853AbiL1Q4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:56:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233733AbiL1Qzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:55:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEEF01F601
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:50:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82D73B8188B
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA53CC433D2;
        Wed, 28 Dec 2022 16:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246225;
        bh=RbUHbXr2zOkHNSqMvO3GxW0qUW9ezzq7ASTx6yz0MbY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xm6pJAxrE6GWub3N8enM8oOYsmMDBs9Jc6D7LXawNxXlIGBEyoArB+0MjDt8DbDBN
         0P9DcOyyZKQ1lAuFNxovC9f1fjVORz0jXX8zRGyb5ZavZT3D+DeiEFt1oo1yPCm1v5
         OzHaOd8oQ9yNhqxL0pauDUvl916f8tG+U1lFsfWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.0 1034/1073] arm64: dts: qcom: sm6350: fix USB-DP PHY registers
Date:   Wed, 28 Dec 2022 15:43:42 +0100
Message-Id: <20221228144356.277765750@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

commit 347b9491c595d5091bfabe65cad2fd6eee786153 upstream.

When adding support for the DisplayPort part of the QMP PHY the binding
(and devicetree parser) for the (USB) child node was simply reused and
this has lead to some confusion.

The third DP register region is really the DP_PHY region, not "PCS" as
the binding claims, and lie at offset 0x2a00 (not 0x2c00).

Similarly, there likely are no "RX", "RX2" or "PCS_MISC" regions as
there are for the USB part of the PHY (and in any case the Linux driver
does not use them).

Note that the sixth "PCS_MISC" region is not even in the binding.

Fixes: 23737b9557fe ("arm64: dts: qcom: sm6350: Add USB1 nodes")
Cc: stable@vger.kernel.org      # 5.16
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221111094729.11842-2-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm6350.dtsi |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm6350.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6350.dtsi
@@ -1007,10 +1007,9 @@
 			dp_phy: dp-phy@88ea200 {
 				reg = <0 0x088ea200 0 0x200>,
 				      <0 0x088ea400 0 0x200>,
-				      <0 0x088eac00 0 0x400>,
+				      <0 0x088eaa00 0 0x200>,
 				      <0 0x088ea600 0 0x200>,
-				      <0 0x088ea800 0 0x200>,
-				      <0 0x088eaa00 0 0x100>;
+				      <0 0x088ea800 0 0x200>;
 				#phy-cells = <0>;
 				#clock-cells = <1>;
 			};


