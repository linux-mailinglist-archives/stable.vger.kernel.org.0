Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D57C4993A8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386083AbiAXUfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:35:08 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34664 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384463AbiAXU3v (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:29:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 809E7B810BD;
        Mon, 24 Jan 2022 20:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3365C340E5;
        Mon, 24 Jan 2022 20:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056188;
        bh=/SUbhHhQrO39kbZ9cTdSArrIMeAS48tRAwkreXpJDdU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fYmdMN3nNM7MOGnJ3BUzJh1eLgSmaKkmZXK8jENjcbwGeFelvLxsAgINlOfekNtb
         P8CgutPh0JGc1qmcSmKVkjOgNyqvuBf1p95kbGBtgKyVVNNL5TtXFYmDMTxMiLgGfc
         otEYJ7zU92zeHfTj1HxrZEkrj6JhopBENl7vDLoM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 368/846] bnxt_en: Refactor coredump functions
Date:   Mon, 24 Jan 2022 19:38:05 +0100
Message-Id: <20220124184113.639255723@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

[ Upstream commit 9a575c8c25ae2372112db6d6b3e553cd90e9f02b ]

The coredump functionality will be used by devlink health. Refactor
these functions that get coredump and coredump length. There is no
functional change, but the following checkpatch warnings were
addressed:

  - strscpy is preferred over strlcpy.
  - sscanf results should be checked, with an additional warning.

Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 48 ++++++++++++-------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 7260910e75fb2..161c354ed4864 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -3803,7 +3803,7 @@ bnxt_fill_coredump_record(struct bnxt *bp, struct bnxt_coredump_record *record,
 	record->low_version = 0;
 	record->high_version = 1;
 	record->asic_state = 0;
-	strlcpy(record->system_name, utsname()->nodename,
+	strscpy(record->system_name, utsname()->nodename,
 		sizeof(record->system_name));
 	record->year = cpu_to_le16(tm.tm_year + 1900);
 	record->month = cpu_to_le16(tm.tm_mon + 1);
@@ -3815,11 +3815,12 @@ bnxt_fill_coredump_record(struct bnxt *bp, struct bnxt_coredump_record *record,
 	strcpy(record->commandline, "ethtool -w");
 	record->total_segments = cpu_to_le32(total_segs);
 
-	sscanf(utsname()->release, "%u.%u", &os_ver_major, &os_ver_minor);
+	if (sscanf(utsname()->release, "%u.%u", &os_ver_major, &os_ver_minor) != 2)
+		netdev_warn(bp->dev, "Unknown OS release in coredump\n");
 	record->os_ver_major = cpu_to_le32(os_ver_major);
 	record->os_ver_minor = cpu_to_le32(os_ver_minor);
 
-	strlcpy(record->os_name, utsname()->sysname, 32);
+	strscpy(record->os_name, utsname()->sysname, sizeof(record->os_name));
 	time64_to_tm(end, 0, &tm);
 	record->end_year = cpu_to_le16(tm.tm_year + 1900);
 	record->end_month = cpu_to_le16(tm.tm_mon + 1);
@@ -3837,7 +3838,7 @@ bnxt_fill_coredump_record(struct bnxt *bp, struct bnxt_coredump_record *record,
 	record->ioctl_high_version = 0;
 }
 
-static int bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
+static int __bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
 {
 	u32 ver_get_resp_len = sizeof(struct hwrm_ver_get_output);
 	u32 offset = 0, seg_hdr_len, seg_record_len, buf_len = 0;
@@ -3940,6 +3941,30 @@ err:
 	return rc;
 }
 
+static int bnxt_get_coredump(struct bnxt *bp, u16 dump_type, void *buf, u32 *dump_len)
+{
+	if (dump_type == BNXT_DUMP_CRASH) {
+#ifdef CONFIG_TEE_BNXT_FW
+		return tee_bnxt_copy_coredump(buf, 0, *dump_len);
+#else
+		return -EOPNOTSUPP;
+#endif
+	} else {
+		return __bnxt_get_coredump(bp, buf, dump_len);
+	}
+}
+
+static u32 bnxt_get_coredump_length(struct bnxt *bp, u16 dump_type)
+{
+	u32 len = 0;
+
+	if (dump_type == BNXT_DUMP_CRASH)
+		len = BNXT_CRASH_DUMP_LEN;
+	else
+		__bnxt_get_coredump(bp, NULL, &len);
+	return len;
+}
+
 static int bnxt_set_dump(struct net_device *dev, struct ethtool_dump *dump)
 {
 	struct bnxt *bp = netdev_priv(dev);
@@ -3971,10 +3996,7 @@ static int bnxt_get_dump_flag(struct net_device *dev, struct ethtool_dump *dump)
 			bp->ver_resp.hwrm_fw_rsvd_8b;
 
 	dump->flag = bp->dump_flag;
-	if (bp->dump_flag == BNXT_DUMP_CRASH)
-		dump->len = BNXT_CRASH_DUMP_LEN;
-	else
-		bnxt_get_coredump(bp, NULL, &dump->len);
+	dump->len = bnxt_get_coredump_length(bp, bp->dump_flag);
 	return 0;
 }
 
@@ -3989,15 +4011,7 @@ static int bnxt_get_dump_data(struct net_device *dev, struct ethtool_dump *dump,
 	memset(buf, 0, dump->len);
 
 	dump->flag = bp->dump_flag;
-	if (dump->flag == BNXT_DUMP_CRASH) {
-#ifdef CONFIG_TEE_BNXT_FW
-		return tee_bnxt_copy_coredump(buf, 0, dump->len);
-#endif
-	} else {
-		return bnxt_get_coredump(bp, buf, &dump->len);
-	}
-
-	return 0;
+	return bnxt_get_coredump(bp, dump->flag, buf, &dump->len);
 }
 
 static int bnxt_get_ts_info(struct net_device *dev,
-- 
2.34.1



