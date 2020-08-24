Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8BE624FA9C
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 11:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgHXIeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:34:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:43312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727942AbgHXIef (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:34:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CAC72087D;
        Mon, 24 Aug 2020 08:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258074;
        bh=YyAY6cc7QTViLWyp9xxjMzcu4icKEU23qQoNGK7Dd/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AztTB+xg82Q6UVRF0yJQUDARNt5fKAgKsY84C2hR0kIjhji5XT3a6We9CTDqwDlzx
         R+HZRb913audQXqZFj2B+hJljKwAvLAfJmYdSypDKJ2hRTzmo4PcPQ+awGVwLtNsqs
         jNcetMYPD9TTCUEemP1iqci7ceC8HS/7G6v1EXJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Anton Vasilyev <vasilyev@ispras.ru>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 066/148] media: camss: fix memory leaks on error handling paths in probe
Date:   Mon, 24 Aug 2020 10:29:24 +0200
Message-Id: <20200824082417.236636968@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082413.900489417@linuxfoundation.org>
References: <20200824082413.900489417@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit f45882cfb152f5d3a421fd58f177f227e44843b9 ]

camss_probe() does not free camss on error handling paths. The patch
introduces an additional error label for this purpose. Besides, it
removes call of v4l2_async_notifier_cleanup() from
camss_of_parse_ports() since its caller, camss_probe(), cleans up all
its resources itself.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Co-developed-by: Anton Vasilyev <vasilyev@ispras.ru>
Signed-off-by: Anton Vasilyev <vasilyev@ispras.ru>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/camss/camss.c | 30 +++++++++++++++--------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss.c b/drivers/media/platform/qcom/camss/camss.c
index 3fdc9f964a3c6..2483641799dfb 100644
--- a/drivers/media/platform/qcom/camss/camss.c
+++ b/drivers/media/platform/qcom/camss/camss.c
@@ -504,7 +504,6 @@ static int camss_of_parse_ports(struct camss *camss)
 	return num_subdevs;
 
 err_cleanup:
-	v4l2_async_notifier_cleanup(&camss->notifier);
 	of_node_put(node);
 	return ret;
 }
@@ -835,29 +834,38 @@ static int camss_probe(struct platform_device *pdev)
 		camss->csid_num = 4;
 		camss->vfe_num = 2;
 	} else {
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err_free;
 	}
 
 	camss->csiphy = devm_kcalloc(dev, camss->csiphy_num,
 				     sizeof(*camss->csiphy), GFP_KERNEL);
-	if (!camss->csiphy)
-		return -ENOMEM;
+	if (!camss->csiphy) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
 
 	camss->csid = devm_kcalloc(dev, camss->csid_num, sizeof(*camss->csid),
 				   GFP_KERNEL);
-	if (!camss->csid)
-		return -ENOMEM;
+	if (!camss->csid) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
 
 	camss->vfe = devm_kcalloc(dev, camss->vfe_num, sizeof(*camss->vfe),
 				  GFP_KERNEL);
-	if (!camss->vfe)
-		return -ENOMEM;
+	if (!camss->vfe) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
 
 	v4l2_async_notifier_init(&camss->notifier);
 
 	num_subdevs = camss_of_parse_ports(camss);
-	if (num_subdevs < 0)
-		return num_subdevs;
+	if (num_subdevs < 0) {
+		ret = num_subdevs;
+		goto err_cleanup;
+	}
 
 	ret = camss_init_subdevices(camss);
 	if (ret < 0)
@@ -936,6 +944,8 @@ err_register_entities:
 	v4l2_device_unregister(&camss->v4l2_dev);
 err_cleanup:
 	v4l2_async_notifier_cleanup(&camss->notifier);
+err_free:
+	kfree(camss);
 
 	return ret;
 }
-- 
2.25.1



