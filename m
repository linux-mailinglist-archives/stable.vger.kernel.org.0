Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE5C2E3DA9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441569AbgL1OST (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:18:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:53122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441555AbgL1OSS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8A4B2242A;
        Mon, 28 Dec 2020 14:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165083;
        bh=TKJwtn2LXnMRBEQzWdyVJJO0i6/fXqvbYSbNQuC+hN8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQeF6UYmu8MtXQMlwqOmLc7+EYMxWhv8JjGcW/o1rNkqzzHiyWDnqKpLuFhgFYxZu
         gC+LIbju9OpHyNoSf0fQLfNTZU+VP5tApzWU8tDGuFigTjmNK7tDF7Fzxa/+SnbMge
         Z2qJILbbrWQatOqr9bsPjq00klD4UYM6l0Y0yNA8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 404/717] remoteproc: qcom: Fix potential NULL dereference in adsp_init_mmio()
Date:   Mon, 28 Dec 2020 13:46:42 +0100
Message-Id: <20201228125040.345458626@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit c3d4e5b12672bbdf63f4cc933e3169bc6bbec8da ]

platform_get_resource() may fail and in this case a NULL dereference
will occur.

Fix it to use devm_platform_ioremap_resource() instead of calling
platform_get_resource() and devm_ioremap().

This is detected by Coccinelle semantic patch.

@@
expression pdev, res, n, t, e, e1, e2;
@@

res = \(platform_get_resource\|platform_get_resource_byname\)(pdev, t,
n);
+ if (!res)
+   return -EINVAL;
... when != res == NULL
e = devm_ioremap(e1, res->start, e2);

Fixes: dc160e449122 ("remoteproc: qcom: Introduce Non-PAS ADSP PIL driver")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1607392460-20516-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/qcom_q6v5_adsp.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/remoteproc/qcom_q6v5_adsp.c b/drivers/remoteproc/qcom_q6v5_adsp.c
index f0b7363b5b268..9eb599701f9b0 100644
--- a/drivers/remoteproc/qcom_q6v5_adsp.c
+++ b/drivers/remoteproc/qcom_q6v5_adsp.c
@@ -364,15 +364,12 @@ static int adsp_init_mmio(struct qcom_adsp *adsp,
 				struct platform_device *pdev)
 {
 	struct device_node *syscon;
-	struct resource *res;
 	int ret;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	adsp->qdsp6ss_base = devm_ioremap(&pdev->dev, res->start,
-			resource_size(res));
-	if (!adsp->qdsp6ss_base) {
+	adsp->qdsp6ss_base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(adsp->qdsp6ss_base)) {
 		dev_err(adsp->dev, "failed to map QDSP6SS registers\n");
-		return -ENOMEM;
+		return PTR_ERR(adsp->qdsp6ss_base);
 	}
 
 	syscon = of_parse_phandle(pdev->dev.of_node, "qcom,halt-regs", 0);
-- 
2.27.0



