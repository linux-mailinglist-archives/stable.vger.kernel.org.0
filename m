Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A39D32879E
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238393AbhCARZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:25:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:37356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238000AbhCARVT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:21:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5736B65069;
        Mon,  1 Mar 2021 16:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617300;
        bh=b/INvTkZ1GG3fLwl6/UxsJPlcQxRl0AY/NIWi+CBkks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WdjcVf2OWx2ouKEnp4hTKiDraBW5gUMO1tmFRkBXA2ppSSjCB2OkWVE3DFg9Oip/o
         Mv/61e9qhIk9gPxWcYwn0VR02tc+rZWnWMAH6mh+2qODmbocBY3Lbb1crdUMKRI1o9
         vj+0b9bWapudEqxGCsNB/F6JWwWwSqEuBALVswZk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 025/340] memory: mtk-smi: Fix PM usage counter unbalance in mtk_smi ops
Date:   Mon,  1 Mar 2021 17:09:29 +0100
Message-Id: <20210301161049.561996111@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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
index a113e811faabe..da1ce7fd4cf5c 100644
--- a/drivers/memory/mtk-smi.c
+++ b/drivers/memory/mtk-smi.c
@@ -127,7 +127,7 @@ static void mtk_smi_clk_disable(const struct mtk_smi *smi)
 
 int mtk_smi_larb_get(struct device *larbdev)
 {
-	int ret = pm_runtime_get_sync(larbdev);
+	int ret = pm_runtime_resume_and_get(larbdev);
 
 	return (ret < 0) ? ret : 0;
 }
@@ -336,7 +336,7 @@ static int __maybe_unused mtk_smi_larb_resume(struct device *dev)
 	int ret;
 
 	/* Power on smi-common. */
-	ret = pm_runtime_get_sync(larb->smi_common_dev);
+	ret = pm_runtime_resume_and_get(larb->smi_common_dev);
 	if (ret < 0) {
 		dev_err(dev, "Failed to pm get for smi-common(%d).\n", ret);
 		return ret;
-- 
2.27.0



