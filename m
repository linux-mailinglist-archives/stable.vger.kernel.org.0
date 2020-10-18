Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74224291994
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgJRTSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:18:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727857AbgJRTSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:18:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1664222EB;
        Sun, 18 Oct 2020 19:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603048729;
        bh=uMiewmmEqIP9o+WBAyBsct7iMPd6w8XJY4CYwUbB3zc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wiZ0pskQTjxF3vNzqfGB/0ZxXdH2YFJC0O154vRR6D/j2f57tZr6FTGi/v3gV/dhA
         JBZdCvKw/jnPrPHcDgvBlo0a4H/dbXIZOnlVo8oRphGJJU9k1AqgoO2N3nH80s58oG
         VJfhYCAD5pC1o1kqj/wQCRp3Ja/E5lU4T0TD9T2o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 034/111] media: venus: core: Fix runtime PM imbalance in venus_probe
Date:   Sun, 18 Oct 2020 15:16:50 -0400
Message-Id: <20201018191807.4052726-34-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018191807.4052726-1-sashal@kernel.org>
References: <20201018191807.4052726-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit bbe516e976fce538db96bd2b7287df942faa14a3 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code. Thus a pairing decrement is needed on
the error handling path to keep the counter balanced. For other error
paths after this call, things are the same.

Fix this by adding pm_runtime_put_noidle() after 'err_runtime_disable'
label. But in this case, the error path after pm_runtime_put_sync()
will decrease PM usage counter twice. Thus add an extra
pm_runtime_get_noresume() in this path to balance PM counter.

Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index bfcaba37d60fe..321ad77cb6cf4 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -289,8 +289,10 @@ static int venus_probe(struct platform_device *pdev)
 		goto err_core_deinit;
 
 	ret = pm_runtime_put_sync(dev);
-	if (ret)
+	if (ret) {
+		pm_runtime_get_noresume(dev);
 		goto err_dev_unregister;
+	}
 
 	return 0;
 
@@ -301,6 +303,7 @@ static int venus_probe(struct platform_device *pdev)
 err_venus_shutdown:
 	venus_shutdown(core);
 err_runtime_disable:
+	pm_runtime_put_noidle(dev);
 	pm_runtime_set_suspended(dev);
 	pm_runtime_disable(dev);
 	hfi_destroy(core);
-- 
2.25.1

