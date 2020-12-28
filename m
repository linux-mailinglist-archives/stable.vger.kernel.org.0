Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 513A82E62D7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406312AbgL1NuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:50:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:52056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406304AbgL1NuT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:50:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A10621D94;
        Mon, 28 Dec 2020 13:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163376;
        bh=wfWmJwIcagNOP+TzL0YlxWBANRomuDPMe3CYOCoBz/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QWJV6pLFg1+LI2/wB/vZ4f3BaRI/fulmFlUfxhh6pdeK2gQNftIKdi4OODP/NITK0
         kAgLJjKD95vHCtZUK+p0I+P+rP59psAsiybXmmXIYzKuEAMD4n7m/bQB01vLjnii53
         34b3bngQL8Fr6XFY0Q05ybq9i6VlpbX4/TaMQ07E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 264/453] remoteproc: qcom: fix reference leak in adsp_start
Date:   Mon, 28 Dec 2020 13:48:20 +0100
Message-Id: <20201228124949.928324778@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit aa37448f597c09844942da87d042fc6793f989c2 ]

pm_runtime_get_sync will increment pm usage counter even it
failed. Forgetting to pm_runtime_put_noidle will result in
reference leak in adsp_start, so we should fix it.

Fixes: dc160e4491222 ("remoteproc: qcom: Introduce Non-PAS ADSP PIL driver")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201102143534.144484-1-zhangqilong3@huawei.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_adsp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/qcom_q6v5_adsp.c b/drivers/remoteproc/qcom_q6v5_adsp.c
index e953886b2eb77..cd88ceabf03e9 100644
--- a/drivers/remoteproc/qcom_q6v5_adsp.c
+++ b/drivers/remoteproc/qcom_q6v5_adsp.c
@@ -184,8 +184,10 @@ static int adsp_start(struct rproc *rproc)
 
 	dev_pm_genpd_set_performance_state(adsp->dev, INT_MAX);
 	ret = pm_runtime_get_sync(adsp->dev);
-	if (ret)
+	if (ret) {
+		pm_runtime_put_noidle(adsp->dev);
 		goto disable_xo_clk;
+	}
 
 	ret = clk_bulk_prepare_enable(adsp->num_clks, adsp->clks);
 	if (ret) {
-- 
2.27.0



