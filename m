Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1221E328DCB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241322AbhCATRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:17:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:39784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241111AbhCATMh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:12:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF899652C3;
        Mon,  1 Mar 2021 17:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620194;
        bh=2BQQzjgS50g5SgUKnLbNGYkIUUqmPpOJ+5r1kWXA1NI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tA2+YegV/ijtNejeJg6lxLDFyGwlC50AnJZEHQ3pFjtgTFr55LObf3LRxT7qyiBEb
         ySM974IbVGGz16tUTpaA42bZkU2Z+B9GS5ZqmITqIh00EAdsuiaxRtv4TML6L5TNF+
         FMjtOMiLm8yAzjdZmebBfX2CA2fioHm1orYMJCOY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 037/775] memory: mtk-smi: Fix PM usage counter unbalance in mtk_smi ops
Date:   Mon,  1 Mar 2021 17:03:25 +0100
Message-Id: <20210301161203.550314162@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit a2d522ff0f5cc26915c4ccee9457fd4b4e1edc48 ]

pm_runtime_get_sync will increment pm usage counter
even it failed. Forgetting to putting operation will
result in reference leak here. We fix it by replacing
it with pm_runtime_resume_and_get to keep usage counter
balanced.

Fixes: 4f0a1a1ae3519 ("memory: mtk-smi: Invoke pm runtime_callback to enable clocks")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201123102118.3866195-1-zhangqilong3@huawei.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/mtk-smi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/mtk-smi.c b/drivers/memory/mtk-smi.c
index ac350f8d1e20f..82d09b88240e1 100644
--- a/drivers/memory/mtk-smi.c
+++ b/drivers/memory/mtk-smi.c
@@ -130,7 +130,7 @@ static void mtk_smi_clk_disable(const struct mtk_smi *smi)
 
 int mtk_smi_larb_get(struct device *larbdev)
 {
-	int ret = pm_runtime_get_sync(larbdev);
+	int ret = pm_runtime_resume_and_get(larbdev);
 
 	return (ret < 0) ? ret : 0;
 }
@@ -374,7 +374,7 @@ static int __maybe_unused mtk_smi_larb_resume(struct device *dev)
 	int ret;
 
 	/* Power on smi-common. */
-	ret = pm_runtime_get_sync(larb->smi_common_dev);
+	ret = pm_runtime_resume_and_get(larb->smi_common_dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to pm get for smi-common(%d).\n", ret);
 		return ret;
-- 
2.27.0



