Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B65C6AE884
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:16:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjCGRQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbjCGRQ2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:16:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6709C9A5
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:11:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E732B819A3
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:11:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E911C433D2;
        Tue,  7 Mar 2023 17:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209116;
        bh=AcaZN3PJWo2mW0t14uGE94Qpyaekgs6FxGaBD6J+Wjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qkkpg9NHn28pkAhjYhhG7amyKoWPddRsPF4rvIG/udklSJVsrVZYJAvDgdVVQT5rp
         0HEPdOeTdh/Z/yQ14o+Nfm2DmJ+DKYRIEDs9yKSm9gjyX18XF1cCqDWw/Zy4xeFc6R
         WKGHtI7KWQ1JMiJQhBuYOVeoJFRS4vBQwtSh5GUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jamie Douglass <jamiemdouglass@gmail.com>,
        Petr Vorel <pvorel@suse.cz>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0115/1001] arm64: dts: qcom: msm8992-lg-bullhead: Correct memory overlaps with the SMEM and MPSS memory regions
Date:   Tue,  7 Mar 2023 17:48:07 +0100
Message-Id: <20230307170027.111090736@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jamie Douglass <jamiemdouglass@gmail.com>

[ Upstream commit d44106883d74992343710f18c4aaae937c7cefab ]

The memory region reserved by a previous commit (see fixes tag below)
overlaps with the SMEM and MPSS memory regions, causing error messages in
dmesg:
	OF: reserved mem: OVERLAP DETECTED!
	reserved@5000000 (0x0000000005000000--0x0000000007200000)
	overlaps with smem_region@6a00000
	(0x0000000006a00000--0x0000000006c00000)

	OF: reserved mem: OVERLAP DETECTED!
	reserved@6c00000 (0x0000000006c00000--0x0000000007200000)
	overlaps with memory@7000000
	(0x0000000007000000--0x000000000ca00000)

This patch resolves both of these by splitting the previously reserved
memory region into two sections either side of the SMEM region and by
cutting off the second memory region to 0x7000000.

Fixes: 22c7e1a0fa45 ("arm64: dts: msm8992-bullhead: add memory hole region")
Signed-off-by: Jamie Douglass <jamiemdouglass@gmail.com>
Reviewed-by: Petr Vorel <pvorel@suse.cz>
Tested-by: Petr Vorel <pvorel@suse.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230202054819.16079-1-jamiemdouglass@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
index 4bceb362a5c02..cdd796040703c 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8992-lg-bullhead.dtsi
@@ -56,8 +56,13 @@ cont_splash_mem: memory@3400000 {
 			no-map;
 		};
 
-		removed_region: reserved@5000000 {
-			reg = <0 0x05000000 0 0x2200000>;
+		reserved@5000000 {
+			reg = <0x0 0x05000000 0x0 0x1a00000>;
+			no-map;
+		};
+
+		reserved@6c00000 {
+			reg = <0x0 0x06c00000 0x0 0x400000>;
 			no-map;
 		};
 	};
-- 
2.39.2



