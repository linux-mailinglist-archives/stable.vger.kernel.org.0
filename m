Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D64D1272E6E
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728040AbgIUQtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:49:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729873AbgIUQtA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:49:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B05020874;
        Mon, 21 Sep 2020 16:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706938;
        bh=qBNl/QUOKi0B8d+5vgZfkrOX0EUopQZnPLXPYGFUmcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KuzwW6BUd90pF8k68a2evaPdEFcZck+TxX16JX1/QRZPx5AgunM9RKEa0XE8QZUyn
         ru3HnFluYtpFhkHSnLuh/qpxja5/qdHyd9/73PBhCHiaPlFdZXodZyDb4J0XQ4y02C
         QFw1CoYyqXAEugtDP9aKzNrzRviJcxXICtgU7KZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Yan <yanaijie@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 35/72] scsi: libsas: Fix error path in sas_notify_lldd_dev_found()
Date:   Mon, 21 Sep 2020 18:31:14 +0200
Message-Id: <20200921163123.540159197@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921163121.870386357@linuxfoundation.org>
References: <20200921163121.870386357@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 244359c99fd90f1c61c3944f93250f8219435c75 ]

In sas_notify_lldd_dev_found(), if we can't allocate the necessary
resources, then it seems like the wrong thing to mark the device as found
and to increment the reference count.  None of the callers ever drop the
reference in that situation.

[mkp: tweaked commit desc based on feedback from John]

Link: https://lore.kernel.org/r/20200905125836.GF183976@mwanda
Fixes: 735f7d2fedf5 ("[SCSI] libsas: fix domain_device leak")
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Acked-by: John Garry <john.garry@huawei.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_discover.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index d7302c2052f91..10975f3f7ff65 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -182,10 +182,11 @@ int sas_notify_lldd_dev_found(struct domain_device *dev)
 		pr_warn("driver on host %s cannot handle device %llx, error:%d\n",
 			dev_name(sas_ha->dev),
 			SAS_ADDR(dev->sas_addr), res);
+		return res;
 	}
 	set_bit(SAS_DEV_FOUND, &dev->state);
 	kref_get(&dev->kref);
-	return res;
+	return 0;
 }
 
 
-- 
2.25.1



