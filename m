Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F18BA541D22
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379550AbiFGWIa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379863AbiFGWG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:06:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABC4E2534C7;
        Tue,  7 Jun 2022 12:16:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4697961922;
        Tue,  7 Jun 2022 19:16:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B733C385A2;
        Tue,  7 Jun 2022 19:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629405;
        bh=90hcqqTDbuainC8u75Jns7z4qyyeclpWRSFDaglmv18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sw5SAKsAMQQlmiIFtn/PojJkkR9aK8Mnc5+Xf4W3ZpstcoYRJK9B1J/8qqj24xF5a
         JWS/V6/IRGVjufXL68f03mS6G3pv/8Z22g+bS1G7rzOC3187tIk1kdUOgmlxrsJ4dr
         kkZvsJBCghbT/PH4iG/JbittfecUdjow25TbFWNs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Russell Currey <ruscur@russell.cc>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 639/879] powerpc/powernv: Get L1D flush requirements from device-tree
Date:   Tue,  7 Jun 2022 19:02:37 +0200
Message-Id: <20220607165021.395499836@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Russell Currey <ruscur@russell.cc>

[ Upstream commit 2efee6adb56159288bce9d1ab51fc9056d7007d4 ]

The device-tree properties no-need-l1d-flush-msr-pr-1-to-0 and
no-need-l1d-flush-kernel-on-user-access are the equivalents of
H_CPU_BEHAV_NO_L1D_FLUSH_ENTRY and H_CPU_BEHAV_NO_L1D_FLUSH_UACCESS
from the H_GET_CPU_CHARACTERISTICS hcall on pseries respectively.

In commit d02fa40d759f ("powerpc/powernv: Remove POWER9 PVR version
check for entry and uaccess flushes") the condition for disabling the
L1D flush on kernel entry and user access was changed from any non-P9
CPU to only checking P7 and P8.  Without the appropriate device-tree
checks for newer processors on powernv, these flushes are unnecessarily
enabled on those systems.  This patch corrects this.

Fixes: d02fa40d759f ("powerpc/powernv: Remove POWER9 PVR version check for entry and uaccess flushes")
Reported-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220404101536.104794-1-ruscur@russell.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/setup.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 105d889abd51..378f7e5f18d2 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -96,6 +96,12 @@ static void __init init_fw_feat_flags(struct device_node *np)
 
 	if (fw_feature_is("disabled", "needs-spec-barrier-for-bound-checks", np))
 		security_ftr_clear(SEC_FTR_BNDS_CHK_SPEC_BAR);
+
+	if (fw_feature_is("enabled", "no-need-l1d-flush-msr-pr-1-to-0", np))
+		security_ftr_clear(SEC_FTR_L1D_FLUSH_ENTRY);
+
+	if (fw_feature_is("enabled", "no-need-l1d-flush-kernel-on-user-access", np))
+		security_ftr_clear(SEC_FTR_L1D_FLUSH_UACCESS);
 }
 
 static void __init pnv_setup_security_mitigations(void)
-- 
2.35.1



