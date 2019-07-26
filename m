Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D53FA76AD2
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 16:01:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387411AbfGZOBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 10:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727502AbfGZNjy (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:39:54 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E9BA22BEF;
        Fri, 26 Jul 2019 13:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148394;
        bh=zxNYHGwwvu6H+QM75SJ79CX5gCsXOWX7Z0mDThNWd7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cNndHS3gaAYFDGnHoF+Cx8GfVUsF1WAXhYnsZPPvYEk4dmWtDDQcAuhBhRs1mkqVN
         JVKvQsy+Fa5RirpYgXNWIsSQT9Ry+qJJyCid0LtSwKUfEL7CDpHSWsSunr0Wfmmw3l
         gPFJ5fHSaJDEXyR/DFVjd5muhcB0BpOwBd7tuSOc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anson Huang <Anson.Huang@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.2 10/85] soc: imx: soc-imx8: Correct return value of error handle
Date:   Fri, 26 Jul 2019 09:38:20 -0400
Message-Id: <20190726133936.11177-10-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726133936.11177-1-sashal@kernel.org>
References: <20190726133936.11177-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit 4c396a604a57da8f883a8b3368d83181680d6907 ]

Current implementation of i.MX8 SoC driver returns -ENODEV
for all cases of error during initialization, this is incorrect.
This patch fixes them using correct return value according
to different errors.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Reviewed-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/soc-imx8.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/soc/imx/soc-imx8.c b/drivers/soc/imx/soc-imx8.c
index fc6429f9170a..e567d866a9d3 100644
--- a/drivers/soc/imx/soc-imx8.c
+++ b/drivers/soc/imx/soc-imx8.c
@@ -73,7 +73,7 @@ static int __init imx8_soc_init(void)
 
 	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
 	if (!soc_dev_attr)
-		return -ENODEV;
+		return -ENOMEM;
 
 	soc_dev_attr->family = "Freescale i.MX";
 
@@ -83,8 +83,10 @@ static int __init imx8_soc_init(void)
 		goto free_soc;
 
 	id = of_match_node(imx8_soc_match, root);
-	if (!id)
+	if (!id) {
+		ret = -ENODEV;
 		goto free_soc;
+	}
 
 	of_node_put(root);
 
@@ -96,12 +98,16 @@ static int __init imx8_soc_init(void)
 	}
 
 	soc_dev_attr->revision = imx8_revision(soc_rev);
-	if (!soc_dev_attr->revision)
+	if (!soc_dev_attr->revision) {
+		ret = -ENOMEM;
 		goto free_soc;
+	}
 
 	soc_dev = soc_device_register(soc_dev_attr);
-	if (IS_ERR(soc_dev))
+	if (IS_ERR(soc_dev)) {
+		ret = PTR_ERR(soc_dev);
 		goto free_rev;
+	}
 
 	return 0;
 
@@ -110,6 +116,6 @@ static int __init imx8_soc_init(void)
 free_soc:
 	kfree(soc_dev_attr);
 	of_node_put(root);
-	return -ENODEV;
+	return ret;
 }
 device_initcall(imx8_soc_init);
-- 
2.20.1

