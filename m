Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23AB411D85
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 17:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728954AbfEBPbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 11:31:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:50396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728368AbfEBPbU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 11:31:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DF8E20C01;
        Thu,  2 May 2019 15:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556811080;
        bh=B39WFc4UtL0We2F9vDpBLkB2vEj16RsrUNBC/m+lI5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dby1G8w31VmmeAcLUDnJyBKP/Y4K44tMZy1pQGdukJrlYAmcshKfzRYV7v8g21xSo
         K/vl/PdMu1VFAaUBR2w9Qv5K/ygFVcEnNQrYPARooh3lYq98jdTYDv3cUt5xTo/8NF
         XNVG4MA63f7lIHUUcRdaRhERHgn37odgUd2fBAfA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 065/101] staging: vc04_services: Fix an error code in vchiq_probe()
Date:   Thu,  2 May 2019 17:21:07 +0200
Message-Id: <20190502143344.215736031@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190502143339.434882399@linuxfoundation.org>
References: <20190502143339.434882399@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 9b9c87cf51783cbe7140c51472762094033cfeab ]

We need to set "err" on this error path.

Fixes: 187ac53e590c ("staging: vchiq_arm: rework probe and init functions")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 .../staging/vc04_services/interface/vchiq_arm/vchiq_arm.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index 804daf83be35..064d0db4c51e 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -3513,6 +3513,7 @@ static int vchiq_probe(struct platform_device *pdev)
 	struct device_node *fw_node;
 	const struct of_device_id *of_id;
 	struct vchiq_drvdata *drvdata;
+	struct device *vchiq_dev;
 	int err;
 
 	of_id = of_match_node(vchiq_of_match, pdev->dev.of_node);
@@ -3547,9 +3548,12 @@ static int vchiq_probe(struct platform_device *pdev)
 		goto failed_platform_init;
 	}
 
-	if (IS_ERR(device_create(vchiq_class, &pdev->dev, vchiq_devid,
-				 NULL, "vchiq")))
+	vchiq_dev = device_create(vchiq_class, &pdev->dev, vchiq_devid, NULL,
+				  "vchiq");
+	if (IS_ERR(vchiq_dev)) {
+		err = PTR_ERR(vchiq_dev);
 		goto failed_device_create;
+	}
 
 	vchiq_debugfs_init();
 
-- 
2.19.1



