Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7550610BA1C
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728417AbfK0VAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:00:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:51808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731517AbfK0VAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:00:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6060921582;
        Wed, 27 Nov 2019 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888404;
        bh=TA8Ib/PAXrfuG0ERBmHA7nW7Qdqb2UTASotXuegXicU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIXVxAte9CumNMV+A5tLhWZ4rSmkdyildFNTn19JPkfK/q1OG21itBV8iGik8IekJ
         AcAJXDTxeGpNQ1FCk2MPzgcw/GheQOJKMQKpo+hh60tpgWPbS4Ib/byar1ZyDh70HA
         gV41ZSfayXMAgpA3d60RY+kFqhH+eHdNrP2QmfjU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Eduardo Valentin <edubezval@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 121/306] thermal: armada: fix a test in probe()
Date:   Wed, 27 Nov 2019 21:29:31 +0100
Message-Id: <20191127203123.980490599@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d1d2c290b3c04b65fa6132eeebe50a070746d8f6 ]

The platform_get_resource() function doesn't return error pointers, it
returns NULL on error.

Fixes: 3d4e51844a4e ("thermal: armada: convert driver to syscon register accesses")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Eduardo Valentin <edubezval@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thermal/armada_thermal.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/thermal/armada_thermal.c b/drivers/thermal/armada_thermal.c
index e16b3cb1808c5..1c9830b2c84da 100644
--- a/drivers/thermal/armada_thermal.c
+++ b/drivers/thermal/armada_thermal.c
@@ -526,8 +526,8 @@ static int armada_thermal_probe_legacy(struct platform_device *pdev,
 
 	/* First memory region points towards the status register */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (IS_ERR(res))
-		return PTR_ERR(res);
+	if (!res)
+		return -EIO;
 
 	/*
 	 * Edit the resource start address and length to map over all the
-- 
2.20.1



