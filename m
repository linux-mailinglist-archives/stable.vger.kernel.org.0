Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7FC611340F
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729039AbfLDSVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:21:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:54958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729634AbfLDSGb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:06:31 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3DE7206DF;
        Wed,  4 Dec 2019 18:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482790;
        bh=sRG+9fKCS3DXqU/Po1FFA9lconLe0eam9JEYAbnx8JU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aBf5tdmlj5jlc4DyW98xGhOSi4G9ptFrRMR5D+7spj2yJpfUPxbCC0A5TtYBc0tyh
         Gnb3wc0ye3hsx1baIoHR6VzBwNxjtFnL6t/6JIr/qK0E9bXIYZpzpxcfnVu+uFNh+3
         cVJ3TaJQS1Z8uJPV1h3jSC/L5cJ9h4QjmO8/g6s8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edward Cree <ecree@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 133/209] sfc: suppress duplicate nvmem partition types in efx_ef10_mtd_probe
Date:   Wed,  4 Dec 2019 18:55:45 +0100
Message-Id: <20191204175332.357016852@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>

[ Upstream commit 3366463513f544c12c6b88c13da4462ee9e7a1a1 ]

Use a bitmap to keep track of which partition types we've already seen;
 for duplicates, return -EEXIST from efx_ef10_mtd_probe_partition() and
 thus skip adding that partition.
Duplicate partitions occur because of the A/B backup scheme used by newer
 sfc NICs.  Prior to this patch they cause sysfs_warn_dup errors because
 they have the same name, causing us not to expose any MTDs at all.

Signed-off-by: Edward Cree <ecree@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef10.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 09352ee43b55c..cc3be94d05622 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -5852,22 +5852,25 @@ static const struct efx_ef10_nvram_type_info efx_ef10_nvram_types[] = {
 	{ NVRAM_PARTITION_TYPE_LICENSE,		   0,    0, "sfc_license" },
 	{ NVRAM_PARTITION_TYPE_PHY_MIN,		   0xff, 0, "sfc_phy_fw" },
 };
+#define EF10_NVRAM_PARTITION_COUNT	ARRAY_SIZE(efx_ef10_nvram_types)
 
 static int efx_ef10_mtd_probe_partition(struct efx_nic *efx,
 					struct efx_mcdi_mtd_partition *part,
-					unsigned int type)
+					unsigned int type,
+					unsigned long *found)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_NVRAM_METADATA_IN_LEN);
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_NVRAM_METADATA_OUT_LENMAX);
 	const struct efx_ef10_nvram_type_info *info;
 	size_t size, erase_size, outlen;
+	int type_idx = 0;
 	bool protected;
 	int rc;
 
-	for (info = efx_ef10_nvram_types; ; info++) {
-		if (info ==
-		    efx_ef10_nvram_types + ARRAY_SIZE(efx_ef10_nvram_types))
+	for (type_idx = 0; ; type_idx++) {
+		if (type_idx == EF10_NVRAM_PARTITION_COUNT)
 			return -ENODEV;
+		info = efx_ef10_nvram_types + type_idx;
 		if ((type & ~info->type_mask) == info->type)
 			break;
 	}
@@ -5880,6 +5883,13 @@ static int efx_ef10_mtd_probe_partition(struct efx_nic *efx,
 	if (protected)
 		return -ENODEV; /* hide it */
 
+	/* If we've already exposed a partition of this type, hide this
+	 * duplicate.  All operations on MTDs are keyed by the type anyway,
+	 * so we can't act on the duplicate.
+	 */
+	if (__test_and_set_bit(type_idx, found))
+		return -EEXIST;
+
 	part->nvram_type = type;
 
 	MCDI_SET_DWORD(inbuf, NVRAM_METADATA_IN_TYPE, type);
@@ -5908,6 +5918,7 @@ static int efx_ef10_mtd_probe_partition(struct efx_nic *efx,
 static int efx_ef10_mtd_probe(struct efx_nic *efx)
 {
 	MCDI_DECLARE_BUF(outbuf, MC_CMD_NVRAM_PARTITIONS_OUT_LENMAX);
+	DECLARE_BITMAP(found, EF10_NVRAM_PARTITION_COUNT);
 	struct efx_mcdi_mtd_partition *parts;
 	size_t outlen, n_parts_total, i, n_parts;
 	unsigned int type;
@@ -5936,11 +5947,13 @@ static int efx_ef10_mtd_probe(struct efx_nic *efx)
 	for (i = 0; i < n_parts_total; i++) {
 		type = MCDI_ARRAY_DWORD(outbuf, NVRAM_PARTITIONS_OUT_TYPE_ID,
 					i);
-		rc = efx_ef10_mtd_probe_partition(efx, &parts[n_parts], type);
-		if (rc == 0)
-			n_parts++;
-		else if (rc != -ENODEV)
+		rc = efx_ef10_mtd_probe_partition(efx, &parts[n_parts], type,
+						  found);
+		if (rc == -EEXIST || rc == -ENODEV)
+			continue;
+		if (rc)
 			goto fail;
+		n_parts++;
 	}
 
 	rc = efx_mtd_add(efx, &parts[0].common, n_parts, sizeof(*parts));
-- 
2.20.1



