Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC10514802A
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389638AbgAXLIP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:08:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388307AbgAXLIN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:08:13 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53A562071A;
        Fri, 24 Jan 2020 11:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864093;
        bh=TbX/g3TRx4bJG873l4a2SrwZW/uSYJYFyVsM4FDf9Ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLNc7R+hXMiZIE/La0rR3IZuPWJRcaA4XG/SQk3LkPzXBq4765SnH00rJpUCBXy1d
         uPqsNJg5AbjpGtIsy8UStTn1BmQsQqiZb69xqo/In0dmuzKsyazXO6tSOLPqUkVVqm
         mibsg1vl4429C9XrThjMZuedRcmeq1wqjmTP5YTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 170/639] staging: most: cdev: add missing check for cdev_add failure
Date:   Fri, 24 Jan 2020 10:25:40 +0100
Message-Id: <20200124093108.445964162@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
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
 drivers/staging/most/cdev/cdev.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/most/cdev/cdev.c b/drivers/staging/most/cdev/cdev.c
index 0b48677fa958a..27d58b55b8108 100644
--- a/drivers/staging/most/cdev/cdev.c
+++ b/drivers/staging/most/cdev/cdev.c
@@ -453,7 +453,9 @@ static int comp_probe(struct most_interface *iface, int channel_id,
 	c->devno = MKDEV(comp.major, current_minor);
 	cdev_init(&c->cdev, &channel_fops);
 	c->cdev.owner = THIS_MODULE;
-	cdev_add(&c->cdev, c->devno, 1);
+	retval = cdev_add(&c->cdev, c->devno, 1);
+	if (retval < 0)
+		goto err_free_c;
 	c->iface = iface;
 	c->cfg = cfg;
 	c->channel_id = channel_id;
@@ -485,6 +487,7 @@ error_create_device:
 	list_del(&c->list);
 error_alloc_kfifo:
 	cdev_del(&c->cdev);
+err_free_c:
 	kfree(c);
 error_alloc_channel:
 	ida_simple_remove(&comp.minor_id, current_minor);
-- 
2.20.1



