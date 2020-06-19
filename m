Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05BEB200F37
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392490AbgFSPQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:16:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392487AbgFSPQm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:16:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 448A421582;
        Fri, 19 Jun 2020 15:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579801;
        bh=RfN7e+IqfNDAX+YUtjar6zUcVJXwkRCwxqE082RR7Yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xDY/lyRjtksbVwbc90wEEhcT6UZ9WT49SqcmqNMZVD3bk7zrNH6Oa30Lxe8GCwYb5
         7Z72KrfCWjds5J28YePtqf/FIAVBst4ft6NlXpwoEyKfK858VhsyMxZnXD0vYwnmWT
         s2jedBXnejHgKqHc1n+Ppbn4xmVnvgL6gIc9BmIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 010/376] media: vicodec: Fix error codes in probe function
Date:   Fri, 19 Jun 2020 16:28:48 +0200
Message-Id: <20200619141710.849391628@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f36592e7b343d853edf44d3545bb68961c0949a4 ]

If these functions fail then we return success, but we should instead
preserve negative error code and return that.

Fixes: fde649b418d1 ("media: vicodec: Register another node for stateless decoder")
Fixes: c022a4a95722 ("media: vicodec: add struct for encoder/decoder instance")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vicodec/vicodec-core.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/media/platform/vicodec/vicodec-core.c b/drivers/media/platform/vicodec/vicodec-core.c
index 30ced1c21387..e879290727ef 100644
--- a/drivers/media/platform/vicodec/vicodec-core.c
+++ b/drivers/media/platform/vicodec/vicodec-core.c
@@ -2114,16 +2114,19 @@ static int vicodec_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, dev);
 
-	if (register_instance(dev, &dev->stateful_enc,
-			      "stateful-encoder", true))
+	ret = register_instance(dev, &dev->stateful_enc, "stateful-encoder",
+				true);
+	if (ret)
 		goto unreg_dev;
 
-	if (register_instance(dev, &dev->stateful_dec,
-			      "stateful-decoder", false))
+	ret = register_instance(dev, &dev->stateful_dec, "stateful-decoder",
+				false);
+	if (ret)
 		goto unreg_sf_enc;
 
-	if (register_instance(dev, &dev->stateless_dec,
-			      "stateless-decoder", false))
+	ret = register_instance(dev, &dev->stateless_dec, "stateless-decoder",
+				false);
+	if (ret)
 		goto unreg_sf_dec;
 
 #ifdef CONFIG_MEDIA_CONTROLLER
-- 
2.25.1



