Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3624594581
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351495AbiHOWwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352208AbiHOWvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:51:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD7C4137927;
        Mon, 15 Aug 2022 12:54:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4015B8114A;
        Mon, 15 Aug 2022 19:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20844C433D6;
        Mon, 15 Aug 2022 19:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593243;
        bh=LxLBhQg37nYyCKF7FOM1vntAWlZt+MmydoeTWUDvHYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sTM+3xNotAVv0jf00RtMCC+BZqpSrHiwcHnKylKVdXeCfbtVMQ8HMdJFZsHLA8ZU8
         jYHf8DlKivt3taDQGI20bHRLY1M7wV7hlWFnZggxExZBJYLRJD3vvb7m6qnem6DYZk
         tbw1aq4O35RhPI2DHlRjv+gTWHPt/XWD4IbAUiiw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0235/1157] arm64: dts: renesas: r8a779m8: Drop operating points above 1.5 GHz
Date:   Mon, 15 Aug 2022 19:53:11 +0200
Message-Id: <20220815180448.971064403@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f48cb21a28c07d0754d5f2f85444cfb0e7b1fd05 ]

The highest-performance mode for the Cortex-A57 CPU cores supported on
R-Car H3Ne (R8A779M8) is the Power Optimized (1.5 GHz) mode.  The Normal
(1.6 GHz) and High Performance (1.7 GHz) modes are not supported.

Hence drop the "turbo-mode" entries from the operating points table
inherited from r8a77951.dtsi.

Fixes: 6e87525d751fac57 ("arm64: dts: renesas: Add Renesas R8A779M8 SoC support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/aeb4530f7fbac8329b334dcb169382c836a5f32d.1655458564.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779m8.dtsi | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a779m8.dtsi b/arch/arm64/boot/dts/renesas/r8a779m8.dtsi
index 752440b0c40f..750bd8ccdb7f 100644
--- a/arch/arm64/boot/dts/renesas/r8a779m8.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a779m8.dtsi
@@ -10,3 +10,8 @@
 / {
 	compatible = "renesas,r8a779m8", "renesas,r8a7795";
 };
+
+&cluster0_opp {
+	/delete-node/ opp-1600000000;
+	/delete-node/ opp-1700000000;
+};
-- 
2.35.1



