Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F02364FD079
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350552AbiDLGqC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351127AbiDLGoE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:44:04 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3549B393FF;
        Mon, 11 Apr 2022 23:37:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9A489CE1C02;
        Tue, 12 Apr 2022 06:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B59DDC385A1;
        Tue, 12 Apr 2022 06:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745445;
        bh=c30THK1jG9CR3xxTFUPoeLCfFlpYUDCfDmADL1yvwqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kd0g7mEDFUDEhxyED1lK1k5JE2qtp99Q1sby6P/O9D1zJcYSTHPP/aAXp07Bn1piF
         pHhTtNYyfTSJoabW8xM5fLNLLBZJ4qZrB8w+smuU9E/dqj0K41x0BDvqU6Vfd7+Aam
         9pBLi5YZ2i93Aj6fRPsiiIqKcuLtu+gwjfPZgj/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/171] drm/amdgpu: fix off by one in amdgpu_gfx_kiq_acquire()
Date:   Tue, 12 Apr 2022 08:29:49 +0200
Message-Id: <20220412062930.720158031@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 1647b54ed55d4d48c7199d439f8834626576cbe9 ]

This post-op should be a pre-op so that we do not pass -1 as the bit
number to test_bit().  The current code will loop downwards from 63 to
-1.  After changing to a pre-op, it loops from 63 to 0.

Fixes: 71c37505e7ea ("drm/amdgpu/gfx: move more common KIQ code to amdgpu_gfx.c")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index 9f9f55a2b257..f84582b70d0e 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -263,7 +263,7 @@ static int amdgpu_gfx_kiq_acquire(struct amdgpu_device *adev,
 		    * adev->gfx.mec.num_pipe_per_mec
 		    * adev->gfx.mec.num_queue_per_pipe;
 
-	while (queue_bit-- >= 0) {
+	while (--queue_bit >= 0) {
 		if (test_bit(queue_bit, adev->gfx.mec.queue_bitmap))
 			continue;
 
-- 
2.35.1



