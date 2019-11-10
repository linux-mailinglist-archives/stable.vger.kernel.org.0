Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43140F65FF
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728743AbfKJDKc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 22:10:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:42754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728458AbfKJCn6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:43:58 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CAEF7214E0;
        Sun, 10 Nov 2019 02:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353838;
        bh=ul0/bGo88jsuhWbKBfwSPapUDoW1WVyc6cHpoRR2Asw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PNlOIDX0nyCs0CNv6ptsVQHXdoRY5jmT35wQmD8MQwcDB1rJ5wPQieOs81SMWl4ih
         gLqpqtQKz/L69DcZYgEOpESOP6TMAXmD3pjQtDFbT5btDWzgHJ87pVMlGRN3JYCgSu
         aZf4s8DIuX3IgemVLJsmdr0YN/93udgnyQPfCQvw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Yan <yanaijie@huawei.com>,
        chenxiang <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Tomas Henzl <thenzl@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 127/191] scsi: libsas: always unregister the old device if going to discover new
Date:   Sat,  9 Nov 2019 21:39:09 -0500
Message-Id: <20191110024013.29782-127-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>

[ Upstream commit 32c850bf587f993b2620b91e5af8a64a7813f504 ]

If we went into sas_rediscover_dev() the attached_sas_addr was already insured
not to be zero. So it's unnecessary to check if the attached_sas_addr is zero.

And although if the sas address is not changed, we always have to unregister
the old device when we are going to register a new one. We cannot just leave
the device there and bring up the new.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: chenxiang <chenxiang66@hisilicon.com>
CC: John Garry <john.garry@huawei.com>
CC: Johannes Thumshirn <jthumshirn@suse.de>
CC: Ewan Milne <emilne@redhat.com>
CC: Christoph Hellwig <hch@lst.de>
CC: Tomas Henzl <thenzl@redhat.com>
CC: Dan Williams <dan.j.williams@intel.com>
CC: Hannes Reinecke <hare@suse.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_expander.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index b141d1061f38e..2ee9c4ec7a541 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -2062,14 +2062,11 @@ static int sas_rediscover_dev(struct domain_device *dev, int phy_id, bool last)
 		return res;
 	}
 
-	/* delete the old link */
-	if (SAS_ADDR(phy->attached_sas_addr) &&
-	    SAS_ADDR(sas_addr) != SAS_ADDR(phy->attached_sas_addr)) {
-		SAS_DPRINTK("ex %016llx phy 0x%x replace %016llx\n",
-			    SAS_ADDR(dev->sas_addr), phy_id,
-			    SAS_ADDR(phy->attached_sas_addr));
-		sas_unregister_devs_sas_addr(dev, phy_id, last);
-	}
+	/* we always have to delete the old device when we went here */
+	SAS_DPRINTK("ex %016llx phy 0x%x replace %016llx\n",
+		    SAS_ADDR(dev->sas_addr), phy_id,
+		    SAS_ADDR(phy->attached_sas_addr));
+	sas_unregister_devs_sas_addr(dev, phy_id, last);
 
 	return sas_discover_new(dev, phy_id);
 }
-- 
2.20.1

