Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B466A0959
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232985AbjBWNFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234279AbjBWNFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:05:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5F3524107
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:05:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B134616DD
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:05:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525F1C433A0;
        Thu, 23 Feb 2023 13:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157500;
        bh=EXp/nxujebN4Xh6ToDp1WrhshsqfAsVb8nQqspT5HX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RuuFAsRc9cSvFSYHm47tIXr8ILXrqNdA5UqiGfwxa23s9onYlWJr3FaGjxLMWXAsT
         pDpaYKTPx+cEReKddZsQo/1RwGKpfLCABYJ07vblseCN3z6O7jNcYVTXXXVhJJNSJD
         IVsZ81cu5HB1hasBv4HQZsvUoCup9X8ETA0LNqtw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 4/7] powerpc: dts: t208x: Disable 10G on MAC1 and MAC2
Date:   Thu, 23 Feb 2023 14:04:41 +0100
Message-Id: <20230223130423.580312841@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130423.369876969@linuxfoundation.org>
References: <20230223130423.369876969@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index a3cee1acd7abd..fda6c9213d9eb 100644
--- a/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t2081si-post.dtsi
@@ -681,3 +681,19 @@
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



