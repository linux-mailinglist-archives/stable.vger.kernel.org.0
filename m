Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1B354159C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376340AbiFGUiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377472AbiFGUdZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:33:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0B11E4B50;
        Tue,  7 Jun 2022 11:35:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD88BB8237B;
        Tue,  7 Jun 2022 18:35:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B410C385A2;
        Tue,  7 Jun 2022 18:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626909;
        bh=W+FTR3kkajvWd2nZMl638Zr2vjMDmiXlj6AHR6X5zLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBPSEqmBUZKD7bR8VO+5mKhV/MSK+ZWJOLgq4Dyw+0jaRBFeok5jbqJwKd/YCXS1q
         4jbi5nnvJa8At6DXWtbLbmkaj6kXx+BRpKRYgOPxk+y8Tiso6wt+7Vjxd6VBAdJ9qY
         8qZA2VggSH63JvVYod5oDSv/3rZbSYOpBaKt9J4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Russell Currey <ruscur@russell.cc>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 547/772] powerpc/powernv: Get STF barrier requirements from device-tree
Date:   Tue,  7 Jun 2022 19:02:19 +0200
Message-Id: <20220607165005.082331213@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

[ Upstream commit d2a3c131981d4498571908df95c3c9393a00adf5 ]

The device-tree property no-need-store-drain-on-priv-state-switch is
equivalent to H_CPU_BEHAV_NO_STF_BARRIER from the
H_CPU_GET_CHARACTERISTICS hcall on pseries.

Since commit 84ed26fd00c5 ("powerpc/security: Add a security feature for
STF barrier") powernv systems with this device-tree property have been
enabling the STF barrier when they have no need for it.  This patch
fixes this by clearing the STF barrier feature on those systems.

Fixes: 84ed26fd00c5 ("powerpc/security: Add a security feature for STF barrier")
Reported-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220404101536.104794-2-ruscur@russell.cc
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/setup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/powerpc/platforms/powernv/setup.c b/arch/powerpc/platforms/powernv/setup.c
index 378f7e5f18d2..824c3ad7a0fa 100644
--- a/arch/powerpc/platforms/powernv/setup.c
+++ b/arch/powerpc/platforms/powernv/setup.c
@@ -102,6 +102,9 @@ static void __init init_fw_feat_flags(struct device_node *np)
 
 	if (fw_feature_is("enabled", "no-need-l1d-flush-kernel-on-user-access", np))
 		security_ftr_clear(SEC_FTR_L1D_FLUSH_UACCESS);
+
+	if (fw_feature_is("enabled", "no-need-store-drain-on-priv-state-switch", np))
+		security_ftr_clear(SEC_FTR_STF_BARRIER);
 }
 
 static void __init pnv_setup_security_mitigations(void)
-- 
2.35.1



