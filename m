Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 518DC6AF34C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbjCGTDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:03:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231503AbjCGTCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:02:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8EBC48B7
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:48:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BB0161531
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13455C433D2;
        Tue,  7 Mar 2023 18:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678214904;
        bh=uYkOMHi0eqFSkhlHeL/TM7QsZ1IhpShGF8Xj+RTepc8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FW4EKgCI7iIm3QyisS8WMx8vg+2JJ815hIxd+qn6mu3mDZqd4GXAEN4nBMzXDT3vx
         ZUfG15AMRIYq/wJsp/Vhg1Avg723GBFkJenBGNNDJhzYqtm4KcHJI+640Y++vJihjY
         vT4i4niaY/T2hC/4hY1DhMwwgjQY87mSnXKUjHwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jamie Douglass <jamiemdouglass@gmail.com>,
        Petr Vorel <pvorel@suse.cz>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 057/567] arm64: dts: qcom: msm8992-lg-bullhead: Correct memory overlaps with the SMEM and MPSS memory regions
Date:   Tue,  7 Mar 2023 17:56:33 +0100
Message-Id: <20230307165908.374036727@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
 arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
index 84ba740cb957b..60fcb024c8879 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
@@ -55,8 +55,13 @@ cont_splash_mem: memory@3400000 {
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



