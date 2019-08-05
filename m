Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C040281D12
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729780AbfHEN3W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:29:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:58028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729429AbfHENVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:21:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B02D2147A;
        Mon,  5 Aug 2019 13:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011306;
        bh=sfgv1YlKYs8U5wCzWy0rcS718/zQIJ0vqqxrCHmH5Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NaV+KbsQefke2HvG4AkHJEPoRLDVOdR2yQV8uKgVXPz0s/Ls7APsY0b7dhc+lid7y
         BJkc+jCKoD2HUjQuOfd+IlM/ahzMxWg+Xo7yQOl7+vbQXwOf2Cw+X8j9aacos2KCYe
         l4nvBn1sGVjf4pi5kjc0h74r8h0OoEJgFxnZLFl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anson Huang <Anson.Huang@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 010/131] soc: imx: soc-imx8: Correct return value of error handle
Date:   Mon,  5 Aug 2019 15:01:37 +0200
Message-Id: <20190805124952.117799984@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index fc6429f9170a6..e567d866a9d31 100644
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
 
@@ -110,6 +116,6 @@ free_rev:
 free_soc:
 	kfree(soc_dev_attr);
 	of_node_put(root);
-	return -ENODEV;
+	return ret;
 }
 device_initcall(imx8_soc_init);
-- 
2.20.1



