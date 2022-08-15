Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E16825947F7
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232573AbiHOXRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344623AbiHOXOp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:14:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2729C7C1AE;
        Mon, 15 Aug 2022 13:02:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8D1C612D1;
        Mon, 15 Aug 2022 20:02:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA18CC433C1;
        Mon, 15 Aug 2022 20:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593734;
        bh=eZjv2QW3Wa6lxZ0ISVmk17zgCgTv5Ti9ykhWuduw3qk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQ9mACCm6tAmcmbkWvNysgGUi6qvikmJBNjrEM/iBaMrbV0RgOhVem0FcXZ6AxQc9
         v3wlHBPqfx1Pg3xCn2oxkHBZCuHP6V4HiZntO61xHEcfcYCG67iEha+fL6FOw8jSUy
         rhwx6EesN94asRwK5DiUB6X32C2LDbanHKq8jTrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manikanta Pubbisetty <quic_mpubbise@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0317/1157] ath11k: Init hw_params before setting up AHB resources
Date:   Mon, 15 Aug 2022 19:54:33 +0200
Message-Id: <20220815180452.334381459@linuxfoundation.org>
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

From: Manikanta Pubbisetty <quic_mpubbise@quicinc.com>

[ Upstream commit bebcfd2534a63ab7e7325f5337662bc84ca038b6 ]

As part of adding the support of WCN6750 to ath11k, bus_params
were moved to hw_params and this regressed the initialization
of WCN6750. By the time AHB resources are setup for WCN6750,
hw_params will not be initialized and therefore initialization
for WCN6750 will fail. This is applicable only for WCN6750,
no other device is impacted.

Fix this by moving the initialization of hw_params before
setting up AHB resources.

Tested-on: WCN6750 hw1.0 AHB WLAN.MSL.1.0.1-00887-QCAMSLSWPLZ-1

Fixes: 00402f49d26f ("ath11k: Add support for WCN6750 device")
Signed-off-by: Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220517055241.15885-1-quic_mpubbise@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index fa11807f48a9..d7d33d5cdfc5 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -976,11 +976,11 @@ static int ath11k_ahb_probe(struct platform_device *pdev)
 	ab->hw_rev = hw_rev;
 	platform_set_drvdata(pdev, ab);
 
-	ret = ath11k_ahb_setup_resources(ab);
+	ret = ath11k_core_pre_init(ab);
 	if (ret)
 		goto err_core_free;
 
-	ret = ath11k_core_pre_init(ab);
+	ret = ath11k_ahb_setup_resources(ab);
 	if (ret)
 		goto err_core_free;
 
-- 
2.35.1



