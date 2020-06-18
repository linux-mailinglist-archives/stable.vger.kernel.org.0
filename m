Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26481FE439
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387564AbgFRCQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:16:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729561AbgFRBUJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:20:09 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99D4D221F1;
        Thu, 18 Jun 2020 01:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592443209;
        bh=r9cAeOlq1yFQF0rprhLhPNc4ZUVGAgeDwB5qDxlMPy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pLLkRcG5wpUfVaVu5Yu7aS/Whpld9ldDsI3/FTsrTlcWkNzeh6yprKEg5iGiHIsdf
         W8+TopVJYLABVdWQrhesg1JCE60rUYwgT0j+EyJ6h15Yt4AytHX/el3fD+CbOr0LRw
         7jsF/ui5U9GT1p4XqVi/xOaVBHanCjqaJNbWMwRM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Dong Aisheng <aisheng.dong@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 166/266] firmware: imx: scu: Fix possible memory leak in imx_scu_probe()
Date:   Wed, 17 Jun 2020 21:14:51 -0400
Message-Id: <20200618011631.604574-166-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618011631.604574-1-sashal@kernel.org>
References: <20200618011631.604574-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 89f12d6509bff004852c51cb713a439a86816b24 ]

'chan_name' is malloced in imx_scu_probe() and should be freed
before leaving from the error handling cases, otherwise it will
cause memory leak.

Fixes: edbee095fafb ("firmware: imx: add SCU firmware driver support")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Dong Aisheng <aisheng.dong@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/imx-scu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/imx/imx-scu.c b/drivers/firmware/imx/imx-scu.c
index e48d971ffb61..a3b11bc71dcb 100644
--- a/drivers/firmware/imx/imx-scu.c
+++ b/drivers/firmware/imx/imx-scu.c
@@ -300,6 +300,7 @@ static int imx_scu_probe(struct platform_device *pdev)
 			if (ret != -EPROBE_DEFER)
 				dev_err(dev, "Failed to request mbox chan %s ret %d\n",
 					chan_name, ret);
+			kfree(chan_name);
 			return ret;
 		}
 
-- 
2.25.1

