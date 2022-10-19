Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE176042DC
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiJSLKt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbiJSLJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:09:23 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E925917FD68;
        Wed, 19 Oct 2022 03:37:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 314E3CE2193;
        Wed, 19 Oct 2022 09:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0205C433D6;
        Wed, 19 Oct 2022 09:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170572;
        bh=KwB7yzHmIKvJrXcnQgncUVi1felkVMXMpemxmBu6DsM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cDTynyAKgDHr5rWF1WyloNQ8pl1QMj2G04eHzKXSBW8S4TbH4e2PYKt+g5XgCKQvm
         guT98zFdvzTwSsRvQbsjt2/XWWDrtkLbEPMBN2S/ASd1HO5PGX/E6ifhaLARiXsUfQ
         Gc+9HBDYryQSlGJmPb7YT2F9c8WTd51aiN521PWk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        Jeff Johnson <quic_jjohnson@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 704/862] wifi: ath11k: mhi: fix potential memory leak in ath11k_mhi_register()
Date:   Wed, 19 Oct 2022 10:33:11 +0200
Message-Id: <20221019083321.099861809@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit 43e7c3505ec70db3d3c6458824d5fa40f62e3e7b ]

mhi_alloc_controller() allocates a memory space for mhi_ctrl. When gets
some error, mhi_ctrl should be freed with mhi_free_controller(). But
when ath11k_mhi_read_addr_from_dt() fails, the function returns without
calling mhi_free_controller(), which will lead to a memory leak.

We can fix it by calling mhi_free_controller() when
ath11k_mhi_read_addr_from_dt() fails.

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20220907073704.58806-1-niejianglei2021@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/mhi.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index c44df17719f6..86995e8dc913 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -402,8 +402,7 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
 	ret = ath11k_mhi_get_msi(ab_pci);
 	if (ret) {
 		ath11k_err(ab, "failed to get msi for mhi\n");
-		mhi_free_controller(mhi_ctrl);
-		return ret;
+		goto free_controller;
 	}
 
 	if (!test_bit(ATH11K_FLAG_MULTI_MSI_VECTORS, &ab->dev_flags))
@@ -412,7 +411,7 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
 	if (test_bit(ATH11K_FLAG_FIXED_MEM_RGN, &ab->dev_flags)) {
 		ret = ath11k_mhi_read_addr_from_dt(mhi_ctrl);
 		if (ret < 0)
-			return ret;
+			goto free_controller;
 	} else {
 		mhi_ctrl->iova_start = 0;
 		mhi_ctrl->iova_stop = 0xFFFFFFFF;
@@ -440,18 +439,22 @@ int ath11k_mhi_register(struct ath11k_pci *ab_pci)
 	default:
 		ath11k_err(ab, "failed assign mhi_config for unknown hw rev %d\n",
 			   ab->hw_rev);
-		mhi_free_controller(mhi_ctrl);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto free_controller;
 	}
 
 	ret = mhi_register_controller(mhi_ctrl, ath11k_mhi_config);
 	if (ret) {
 		ath11k_err(ab, "failed to register to mhi bus, err = %d\n", ret);
-		mhi_free_controller(mhi_ctrl);
-		return ret;
+		goto free_controller;
 	}
 
 	return 0;
+
+free_controller:
+	mhi_free_controller(mhi_ctrl);
+	ab_pci->mhi_ctrl = NULL;
+	return ret;
 }
 
 void ath11k_mhi_unregister(struct ath11k_pci *ab_pci)
-- 
2.35.1



