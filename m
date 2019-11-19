Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C807B101794
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730325AbfKSFmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:42:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:37026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730614AbfKSFmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:42:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02C1D222F2;
        Tue, 19 Nov 2019 05:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142138;
        bh=ul0/bGo88jsuhWbKBfwSPapUDoW1WVyc6cHpoRR2Asw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DgKcEZUp+OV3jUEegQwuffMER/iP77TsjQo3uxBmyB/pDOd2R0/8vkxiKeOl01n90
         B0xq8LWBmaxpu7lF56JvVUYUi/yD0e12gHTdlPWgEYgLpZdHaAuYd0VtMgRwx//sjp
         kFz3+49NWDJNhaDpyInJ4/jVX7MSrzsLx5dhVNnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Yan <yanaijie@huawei.com>,
        chenxiang <chenxiang66@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Ewan Milne <emilne@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Tomas Henzl <thenzl@redhat.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 361/422] scsi: libsas: always unregister the old device if going to discover new
Date:   Tue, 19 Nov 2019 06:19:18 +0100
Message-Id: <20191119051422.407996701@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



