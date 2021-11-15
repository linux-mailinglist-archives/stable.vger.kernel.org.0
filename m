Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D0ED450E13
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240589AbhKOSKk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:10:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:45994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239940AbhKOSFF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:05:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8CC0C632ED;
        Mon, 15 Nov 2021 17:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998020;
        bh=+Ieg6c3hIgJ0lyTICqOdCMQN83KQ3PflYloijUHZXqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XcKhfeo++hf6qyGKb/RSeWjuyRwilJ8D77ciVwHC0kNtQ4a22kexrWCR1EHGUC8z0
         rCkFYD1Lf2wLC4dRUB27a6/YwC91JvO6Y30l+eHBYl+RxvsJaRLn3yowfTCKmcjxV+
         8GQHIYzGVoX2XSQmbBHBR/EtBJa76wRkBe9nE1dE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Abhinav Kumar <abhinavk@codeaurora.org>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Rob Clark <robdclark@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 325/575] drm/msm: potential error pointer dereference in init()
Date:   Mon, 15 Nov 2021 18:00:50 +0100
Message-Id: <20211115165355.045616927@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit b6816441a14bbe356ba8590de79cfea2de6a085c ]

The msm_iommu_new() returns error pointers on failure so check for that
to avoid an Oops.

Fixes: ccac7ce373c1 ("drm/msm: Refactor address space initialization")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Abhinav Kumar <abhinavk@codeaurora.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20211004103806.GD25015@kili
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
index c8217f4858a15..b4a2e8eb35dd2 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c
@@ -846,6 +846,10 @@ static int _dpu_kms_mmu_init(struct dpu_kms *dpu_kms)
 		return 0;
 
 	mmu = msm_iommu_new(dpu_kms->dev->dev, domain);
+	if (IS_ERR(mmu)) {
+		iommu_domain_free(domain);
+		return PTR_ERR(mmu);
+	}
 	aspace = msm_gem_address_space_create(mmu, "dpu1",
 		0x1000, 0x100000000 - 0x1000);
 
-- 
2.33.0



