Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21054F28E3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240123AbiDEIXl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237133AbiDEIRn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:17:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9421F689A6;
        Tue,  5 Apr 2022 01:05:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A519617ED;
        Tue,  5 Apr 2022 08:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F96C385A0;
        Tue,  5 Apr 2022 08:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145922;
        bh=JtOMfaEbVXd2i/CdfdprYFI1BoQI8cBSV7rn34byu2U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQBnMmkyEHa4EQyd2Z+0Vv59TERPYjrAyyI2XuwWSnCr8qDkgatJL/PXBhgxD+Ei+
         GxHgNDYUbnHOgF+hgPm3thdkEERuh8HqZaTKjhrKmeGguoZesaW4EuoniQGKTdDRhP
         kGJfy74sUB/LNrHzIXVcsjmiSYHaX86vSQIdQjjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rameshkumar Sundaram <quic_ramess@quicinc.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0577/1126] ath11k: Invalidate cached reo ring entry before accessing it
Date:   Tue,  5 Apr 2022 09:22:04 +0200
Message-Id: <20220405070424.568803354@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Rameshkumar Sundaram <quic_ramess@quicinc.com>

[ Upstream commit f2180ccb52b5fd0876291ad2df37e2898cac18cf ]

REO2SW ring descriptor is currently allocated in cacheable memory.
While reaping reo ring entries on second trial after updating head
pointer, first entry is not invalidated before accessing it.

This results in host reaping and using cached descriptor which is
already overwritten in memory by DMA device (HW).
Since the contents of descriptor(buffer id, peer info and other information
bits) are outdated host throws errors like below while parsing corresponding
MSDU's and drops them.

[347712.048904] ath11k_pci 0004:01:00.0: msdu_done bit in attention is not set
[349173.355503] ath11k_pci 0004:01:00.0: frame rx with invalid buf_id 962

Move the try_again: label above  ath11k_hal_srng_access_begin()
so that first entry will be invalidated and prefetched.

Tested-on: QCN9074 hw1.0 PCI WLAN.HK.2.5.0.1-01100-QCAHKSWPL_SILICONZ-1

Fixes: 6452f0a3d565 ("ath11k: allocate dst ring descriptors from cacheable memory")
Signed-off-by: Rameshkumar Sundaram <quic_ramess@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/1645000354-32558-1-git-send-email-quic_ramess@quicinc.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index c212a789421e..e432f8dc05d6 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -2642,9 +2642,9 @@ int ath11k_dp_process_rx(struct ath11k_base *ab, int ring_id,
 
 	spin_lock_bh(&srng->lock);
 
+try_again:
 	ath11k_hal_srng_access_begin(ab, srng);
 
-try_again:
 	while (likely(desc =
 	      (struct hal_reo_dest_ring *)ath11k_hal_srng_dst_get_next_entry(ab,
 									     srng))) {
-- 
2.34.1



