Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1431829B7DE
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S368736AbgJ0P1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:27:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:40454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1797742AbgJ0PZO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:25:14 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 363EB2064B;
        Tue, 27 Oct 2020 15:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812313;
        bh=o79LusNjYGGfOPQ6/cjiDgL9YeffsVcz3R0f2qlyXwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DWVgXmkJb4wSltNugHqssBWeRh1zYmMoc3aT85fdy1zR5WJIIOHrjvgyLF5+RFKEN
         8/iauQ5s3cJo/5xLHWy5TMchpoxf5pZkFMhYX50JOeGoV+u2cK6SLFVQN21S0UoUis
         vHNl1pwJfl1SrJV4/uM6mmFnFtFaW0IrfzgfpP70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 165/757] nvme: fix error handling in nvme_ns_report_zones
Date:   Tue, 27 Oct 2020 14:46:55 +0100
Message-Id: <20201027135458.330779536@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 936fab503ff4af94f5f9c0b549f3ab4d435500ec ]

nvme_submit_sync_cmd can return positive NVMe error codes in addition to
the negative Linux error code, which are currently ignored.  Fix this
by removing __nvme_ns_report_zones and handling the errors from
nvme_submit_sync_cmd in the caller instead of multiplexing the return
value and the number of zones reported into a single return value.

Fixes: 240e6ee272c0 ("nvme: support for zoned namespaces")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/zns.c | 41 ++++++++++++++++-------------------------
 1 file changed, 16 insertions(+), 25 deletions(-)

diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 57cfd78731fbb..53efecb678983 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -133,28 +133,6 @@ static void *nvme_zns_alloc_report_buffer(struct nvme_ns *ns,
 	return NULL;
 }
 
-static int __nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
-				  struct nvme_zone_report *report,
-				  size_t buflen)
-{
-	struct nvme_command c = { };
-	int ret;
-
-	c.zmr.opcode = nvme_cmd_zone_mgmt_recv;
-	c.zmr.nsid = cpu_to_le32(ns->head->ns_id);
-	c.zmr.slba = cpu_to_le64(nvme_sect_to_lba(ns, sector));
-	c.zmr.numd = cpu_to_le32(nvme_bytes_to_numd(buflen));
-	c.zmr.zra = NVME_ZRA_ZONE_REPORT;
-	c.zmr.zrasf = NVME_ZRASF_ZONE_REPORT_ALL;
-	c.zmr.pr = NVME_REPORT_ZONE_PARTIAL;
-
-	ret = nvme_submit_sync_cmd(ns->queue, &c, report, buflen);
-	if (ret)
-		return ret;
-
-	return le64_to_cpu(report->nr_zones);
-}
-
 static int nvme_zone_parse_entry(struct nvme_ns *ns,
 				 struct nvme_zone_descriptor *entry,
 				 unsigned int idx, report_zones_cb cb,
@@ -182,6 +160,7 @@ static int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 			unsigned int nr_zones, report_zones_cb cb, void *data)
 {
 	struct nvme_zone_report *report;
+	struct nvme_command c = { };
 	int ret, zone_idx = 0;
 	unsigned int nz, i;
 	size_t buflen;
@@ -190,14 +169,26 @@ static int nvme_ns_report_zones(struct nvme_ns *ns, sector_t sector,
 	if (!report)
 		return -ENOMEM;
 
+	c.zmr.opcode = nvme_cmd_zone_mgmt_recv;
+	c.zmr.nsid = cpu_to_le32(ns->head->ns_id);
+	c.zmr.numd = cpu_to_le32(nvme_bytes_to_numd(buflen));
+	c.zmr.zra = NVME_ZRA_ZONE_REPORT;
+	c.zmr.zrasf = NVME_ZRASF_ZONE_REPORT_ALL;
+	c.zmr.pr = NVME_REPORT_ZONE_PARTIAL;
+
 	sector &= ~(ns->zsze - 1);
 	while (zone_idx < nr_zones && sector < get_capacity(ns->disk)) {
 		memset(report, 0, buflen);
-		ret = __nvme_ns_report_zones(ns, sector, report, buflen);
-		if (ret < 0)
+
+		c.zmr.slba = cpu_to_le64(nvme_sect_to_lba(ns, sector));
+		ret = nvme_submit_sync_cmd(ns->queue, &c, report, buflen);
+		if (ret) {
+			if (ret > 0)
+				ret = -EIO;
 			goto out_free;
+		}
 
-		nz = min_t(unsigned int, ret, nr_zones);
+		nz = min((unsigned int)le64_to_cpu(report->nr_zones), nr_zones);
 		if (!nz)
 			break;
 
-- 
2.25.1



