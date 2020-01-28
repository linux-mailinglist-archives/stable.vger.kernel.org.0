Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47F5314BA7F
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:39:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgA1Oja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:39:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:40774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728212AbgA1ORH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:17:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFFA82071E;
        Tue, 28 Jan 2020 14:17:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221027;
        bh=pddlwd+yZz8Np8BgmC0uvxaGjvNjT0t57Be+WRiok4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RUW9582OrkGpEUzLz3kDRLCg8aCg21AgxqUh6YlEP8GWZND5UW4x/bLLT/hRHRejB
         G1F7vA2nXDA9V9nGimXXTqpmbrCVDdOjGPGQFoEKN2+xPAl/MPYCX0AO/d7mkR4mlp
         N35lpVEEV4THRjOWZTMuih2g4h8UVDLVj/EsQOX0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 058/271] staging: most: cdev: add missing check for cdev_add failure
Date:   Tue, 28 Jan 2020 15:03:27 +0100
Message-Id: <20200128135856.957905403@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 5ae890780e1b4d08f2c0c5d4ea96fc3928fc0ee9 ]

Currently the call to cdev_add is missing a check for failure. Fix this by
checking for failure and exiting via a new error path that ensures the
allocated comp_channel struct is kfree'd.

Detected by CoverityScan, CID#1462359 ("Unchecked return value")

Fixes: 9bc79bbcd0c5 ("Staging: most: add MOST driver's aim-cdev module")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/most/aim-cdev/cdev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/most/aim-cdev/cdev.c b/drivers/staging/most/aim-cdev/cdev.c
index 7f51024dc5ebb..e87b9ed4f37de 100644
--- a/drivers/staging/most/aim-cdev/cdev.c
+++ b/drivers/staging/most/aim-cdev/cdev.c
@@ -451,7 +451,9 @@ static int aim_probe(struct most_interface *iface, int channel_id,
 	c->devno = MKDEV(major, current_minor);
 	cdev_init(&c->cdev, &channel_fops);
 	c->cdev.owner = THIS_MODULE;
-	cdev_add(&c->cdev, c->devno, 1);
+	retval = cdev_add(&c->cdev, c->devno, 1);
+	if (retval < 0)
+		goto err_free_c;
 	c->iface = iface;
 	c->cfg = cfg;
 	c->channel_id = channel_id;
@@ -487,6 +489,7 @@ error_create_device:
 	list_del(&c->list);
 error_alloc_kfifo:
 	cdev_del(&c->cdev);
+err_free_c:
 	kfree(c);
 error_alloc_channel:
 	ida_simple_remove(&minor_id, current_minor);
-- 
2.20.1



