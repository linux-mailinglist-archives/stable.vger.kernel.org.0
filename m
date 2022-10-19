Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3DE603CB2
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiJSIvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:51:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbiJSItI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:49:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58FE79185F;
        Wed, 19 Oct 2022 01:47:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9FD061831;
        Wed, 19 Oct 2022 08:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C911C433C1;
        Wed, 19 Oct 2022 08:47:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169222;
        bh=IfWrrYSMy5ZOVDZlf3ehBiPo9AMi1p4jSVtv16gPtBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t1vo3Fbkc7RGb0PJYakkmzHPRtcqXFmiAqAeNIsJgJA3tBVSOsAps8Ox/tfkKyBx0
         n+4bo59DcxYoImVUpRcxQ0WPp2K0qpKriw7bHYIWdeN38rgiT4dciQMNyUs8FbcPBg
         JqEr1TxoD+Lo72E31BT2b4enhQDPmPtg0ZF1jY6o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ruili Ji <ruiliji2@amd.com>,
        Yifan Zhang <yifan1.zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 200/862] drm/amdgpu: Enable F32_WPTR_POLL_ENABLE in mqd
Date:   Wed, 19 Oct 2022 10:24:47 +0200
Message-Id: <20221019083258.845787699@linuxfoundation.org>
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

From: Ruili Ji <ruiliji2@amd.com>

commit 21a550de5faf9f54013334c9a6a7643b8fd80b36 upstream.

This patch is to fix the SDMA user queue doorbell missing issue on
SDMA 6.0. F32_WPTR_POLL_ENABLE has to be set if doorbell mode is
used. Otherwise ringing SDMA user queue doorbell can't wake up
system from gfxoff.

Signed-off-by: Ruili Ji <ruiliji2@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c           |    3 ++-
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v6_0.c
@@ -910,7 +910,8 @@ static int sdma_v6_0_mqd_init(struct amd
 	m->sdmax_rlcx_rb_cntl =
 		order_base_2(prop->queue_size / 4) << SDMA0_QUEUE0_RB_CNTL__RB_SIZE__SHIFT |
 		1 << SDMA0_QUEUE0_RB_CNTL__RPTR_WRITEBACK_ENABLE__SHIFT |
-		4 << SDMA0_QUEUE0_RB_CNTL__RPTR_WRITEBACK_TIMER__SHIFT;
+		4 << SDMA0_QUEUE0_RB_CNTL__RPTR_WRITEBACK_TIMER__SHIFT |
+		1 << SDMA0_QUEUE0_RB_CNTL__F32_WPTR_POLL_ENABLE__SHIFT;
 
 	m->sdmax_rlcx_rb_base = lower_32_bits(prop->hqd_base_gpu_addr >> 8);
 	m->sdmax_rlcx_rb_base_hi = upper_32_bits(prop->hqd_base_gpu_addr >> 8);
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v11.c
@@ -375,7 +375,8 @@ static void update_mqd_sdma(struct mqd_m
 		<< SDMA0_QUEUE0_RB_CNTL__RB_SIZE__SHIFT |
 		q->vmid << SDMA0_QUEUE0_RB_CNTL__RB_VMID__SHIFT |
 		1 << SDMA0_QUEUE0_RB_CNTL__RPTR_WRITEBACK_ENABLE__SHIFT |
-		6 << SDMA0_QUEUE0_RB_CNTL__RPTR_WRITEBACK_TIMER__SHIFT;
+		6 << SDMA0_QUEUE0_RB_CNTL__RPTR_WRITEBACK_TIMER__SHIFT |
+		1 << SDMA0_QUEUE0_RB_CNTL__F32_WPTR_POLL_ENABLE__SHIFT;
 
 	m->sdmax_rlcx_rb_base = lower_32_bits(q->queue_address >> 8);
 	m->sdmax_rlcx_rb_base_hi = upper_32_bits(q->queue_address >> 8);


