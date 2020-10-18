Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF27A291AB2
	for <lists+stable@lfdr.de>; Sun, 18 Oct 2020 21:26:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731468AbgJRTZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Oct 2020 15:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:40826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731376AbgJRTZy (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 18 Oct 2020 15:25:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21A25207DE;
        Sun, 18 Oct 2020 19:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603049153;
        bh=nzyNKnlvQUFwa97D46h/9JH6DNevRH/OniOTgNqcPjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2yEovwPVbkCbW+/j2IFifIKTvtV0ltCUtQpHrP2Bv6lznuSPiDWuR0xFYB3V4fb9
         z0GO5aCChoP0cIdaU9KeCCwDRy/OiLOeScPqRQ3YTruehaantKcJvALi44h2HEMuuD
         Jkfzkxo7Jqh9Ueh3ul77/4fcFUKLsJ2Y9e+OH1fw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dinghao Liu <dinghao.liu@zju.edu.cn>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 19/52] media: venus: core: Fix runtime PM imbalance in venus_probe
Date:   Sun, 18 Oct 2020 15:24:56 -0400
Message-Id: <20201018192530.4055730-19-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201018192530.4055730-1-sashal@kernel.org>
References: <20201018192530.4055730-1-sashal@kernel.org>
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
index 9360b36b82cd8..0a011b117a6db 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -236,8 +236,10 @@ static int venus_probe(struct platform_device *pdev)
 		goto err_dev_unregister;
 
 	ret = pm_runtime_put_sync(dev);
-	if (ret)
+	if (ret) {
+		pm_runtime_get_noresume(dev);
 		goto err_dev_unregister;
+	}
 
 	return 0;
 
@@ -248,6 +250,7 @@ static int venus_probe(struct platform_device *pdev)
 err_venus_shutdown:
 	venus_shutdown(dev);
 err_runtime_disable:
+	pm_runtime_put_noidle(dev);
 	pm_runtime_set_suspended(dev);
 	pm_runtime_disable(dev);
 	hfi_destroy(core);
-- 
2.25.1

