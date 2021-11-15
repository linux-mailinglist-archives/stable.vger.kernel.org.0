Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A995451ECD
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343687AbhKPAhd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:37:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344753AbhKOTZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 942EF60ED3;
        Mon, 15 Nov 2021 19:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003029;
        bh=vIc+lZBCnHovu4k3sg3oxOLOzpfZdl+l3cAUUTA8ZhM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ySbllx+32+9xNg3+gikrGQivTCYRw9/0D5OpEVgLz9ad2GltD/LKL/F2Shy5BTO0g
         9G4+HwQKCuAbBdePmb8sHoAVG4AWIxU/DOI/6HX2FAwgtAmNcvLO4xFKdK3v6yk8Za
         s6C+J0oo7AIX8flKTTi2DU5+G7IsfNfRC9lLqDLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 785/917] nvdimm/pmem: cleanup the disk if pmem_release_disk() is yet assigned
Date:   Mon, 15 Nov 2021 18:04:40 +0100
Message-Id: <20211115165455.570840542@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit accf58afb689f81daadde24080ea1164ad2db75f ]

Prior to devm being able to use pmem_release_disk() there are other
failure which can occur for which we must account for and release the
disk for. Address those few cases.

Fixes: 3dd60fb9d95d ("nvdimm/pmem: stop using q_usage_count as external pgmap refcount")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20211103230437.1639990-6-mcgrof@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/pmem.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 054154c22899a..2721dd2ead0a7 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -429,8 +429,10 @@ static int pmem_attach_disk(struct device *dev,
 		bb_range.end = res->end;
 	}
 
-	if (IS_ERR(addr))
-		return PTR_ERR(addr);
+	if (IS_ERR(addr)) {
+		rc = PTR_ERR(addr);
+		goto out;
+	}
 	pmem->virt_addr = addr;
 
 	blk_queue_write_cache(q, true, fua);
@@ -455,7 +457,8 @@ static int pmem_attach_disk(struct device *dev,
 		flags = DAXDEV_F_SYNC;
 	dax_dev = alloc_dax(pmem, disk->disk_name, &pmem_dax_ops, flags);
 	if (IS_ERR(dax_dev)) {
-		return PTR_ERR(dax_dev);
+		rc = PTR_ERR(dax_dev);
+		goto out;
 	}
 	dax_write_cache(dax_dev, nvdimm_has_cache(nd_region));
 	pmem->dax_dev = dax_dev;
@@ -470,8 +473,10 @@ static int pmem_attach_disk(struct device *dev,
 					  "badblocks");
 	if (!pmem->bb_state)
 		dev_warn(dev, "'badblocks' notification disabled\n");
-
 	return 0;
+out:
+	blk_cleanup_disk(pmem->disk);
+	return rc;
 }
 
 static int nd_pmem_probe(struct device *dev)
-- 
2.33.0



