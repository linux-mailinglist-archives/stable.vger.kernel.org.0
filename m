Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 814AA6A09F9
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234463AbjBWNMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbjBWNL7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:11:59 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3BC56792
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:11:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AEDFDCE1FEE
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2D8C4339B;
        Thu, 23 Feb 2023 13:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157877;
        bh=Xb9zjsWuD2iVWJym7BTZ016iPYFtkt2DOwnW1iLojmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cELaG9eD/FOyr+6GOZPi0ZrMnbuv1w0nLjUKDm9tg+29niTxczcAPVn4t7jgFEoK9
         9He0kwPpITrnM6eVlCsptFti96CJMTmbrRrt0c8bRSgiJ3wAigbq0nz/qixJI7frQW
         9hRT+Uao2EYA0RRs2BpM7xZS/W+vRQzj48KerQTo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 11/18] powerpc: dts: t208x: Disable 10G on MAC1 and MAC2
Date:   Thu, 23 Feb 2023 14:06:56 +0100
Message-Id: <20230223130426.111635226@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130425.680784802@linuxfoundation.org>
References: <20230223130425.680784802@linuxfoundation.org>
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

From: Sean Anderson <sean.anderson@seco.com>

[ Upstream commit 8d8bee13ae9e316443c6666286360126a19c8d94 ]

There aren't enough resources to run these ports at 10G speeds. Disable
10G for these ports, reverting to the previous speed.

Fixes: 36926a7d70c2 ("powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G")
Reported-by: Camelia Alexandra Groza <camelia.groza@nxp.com>
Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Reviewed-by: Camelia Groza <camelia.groza@nxp.com>
Tested-by: Camelia Groza <camelia.groza@nxp.com>
Link: https://lore.kernel.org/r/20221216172937.2960054-1-sean.anderson@seco.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
index 74e17e134387d..27714dc2f04a5 100644
--- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
@@ -659,3 +659,19 @@
 		interrupts = <16 2 1 9>;
 	};
 };
+
+&fman0_rx_0x08 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_tx_0x28 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_rx_0x09 {
+	/delete-property/ fsl,fman-10g-port;
+};
+
+&fman0_tx_0x29 {
+	/delete-property/ fsl,fman-10g-port;
+};
-- 
2.39.0



