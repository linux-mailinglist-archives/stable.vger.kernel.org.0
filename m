Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A71856584DE
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:03:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235145AbiL1RDb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235253AbiL1RDK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 12:03:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141971CB3E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:57:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B49A6B8171E
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7051C433D2;
        Wed, 28 Dec 2022 16:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246629;
        bh=V+pvIg6dk3hOE9dMwmVtetdhuPODH9BSm+bY0BukB6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zMH6dQy39eDBZYzfLI6l9H78/AxtxWKhb/ZMJhyVCFdWCHKq7ub76/TwBpKxXJJFv
         72pYgMqb/3a6IVHeKjrfNFPLcr+1YVAMfrYFNKW0PcZDXO+UaC1CdRdvhVVSaHPOOg
         Rr/Mtez1oEjvsO5xaFxaOt6uJLR46FwR8sXbLZ9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.1 1106/1146] arm64: dts: qcom: sm8250: fix USB-DP PHY registers
Date:   Wed, 28 Dec 2022 15:44:05 +0100
Message-Id: <20221228144400.199475923@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

commit f8d8840c72b3df61b5252052b79020dabec01ab5 upstream.

When adding support for the DisplayPort part of the QMP PHY the binding
(and devicetree parser) for the (USB) child node was simply reused and
this has lead to some confusion.

The third DP register region is really the DP_PHY region, not "PCS" as
the binding claims, and lie at offset 0x2a00 (not 0x2c00).

Similarly, there likely are no "RX", "RX2" or "PCS_MISC" regions as
there are for the USB part of the PHY (and in any case the Linux driver
does not use them).

Note that the sixth "PCS_MISC" region is not even in the binding.

Fixes: 5aa0d1becd5b ("arm64: dts: qcom: sm8250: switch usb1 qmp phy to USB3+DP mode")
Cc: stable@vger.kernel.org      # 5.13
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20221111094729.11842-3-johan+linaro@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/sm8250.dtsi |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/qcom/sm8250.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8250.dtsi
@@ -2892,10 +2892,9 @@
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


