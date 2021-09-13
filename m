Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A8040949C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:32:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346412AbhIMOct (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:32:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245472AbhIMOaz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:30:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DB0C60E08;
        Mon, 13 Sep 2021 13:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631541100;
        bh=U/V0Muk/z2AxBNZ6AZLVKCfwt65va+Gefob8QAAvJRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X6ZkhZfQZLLULbCcsHYj8q8R0k/PpVIryfEmzOW1fmGOF/Rs4T6Kv6RFxtAvSZKU8
         5y6vW/dPAaYIOUPUgNVvlQ2arnZ2xkmjzszLaRmxpdFdau8+6zUjlfwi96AbFAF9tN
         rFj1l3gj3G8T47ap1si/OyFOKw9Ff1aNJyISnXT8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 161/334] media: venus: hfi: fix return value check in sys_get_prop_image_version()
Date:   Mon, 13 Sep 2021 15:13:35 +0200
Message-Id: <20210913131118.792169763@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131113.390368911@linuxfoundation.org>
References: <20210913131113.390368911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 331e06bbde5856059b7a6bb183f12878ed4decb1 ]

In case of error, the function qcom_smem_get() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Fixes: d566e78dd6af ("media: venus : hfi: add venus image info into smem")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/hfi_msgs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/hfi_msgs.c b/drivers/media/platform/qcom/venus/hfi_msgs.c
index d9fde66f6fa8..9a2bdb002edc 100644
--- a/drivers/media/platform/qcom/venus/hfi_msgs.c
+++ b/drivers/media/platform/qcom/venus/hfi_msgs.c
@@ -261,7 +261,7 @@ sys_get_prop_image_version(struct device *dev,
 
 	smem_tbl_ptr = qcom_smem_get(QCOM_SMEM_HOST_ANY,
 		SMEM_IMG_VER_TBL, &smem_blk_sz);
-	if (smem_tbl_ptr && smem_blk_sz >= SMEM_IMG_OFFSET_VENUS + VER_STR_SZ)
+	if (!IS_ERR(smem_tbl_ptr) && smem_blk_sz >= SMEM_IMG_OFFSET_VENUS + VER_STR_SZ)
 		memcpy(smem_tbl_ptr + SMEM_IMG_OFFSET_VENUS,
 		       img_ver, VER_STR_SZ);
 }
-- 
2.30.2



