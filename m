Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58B73499896
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378186AbiAXV1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:27:48 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:38478 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449358AbiAXVP3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:15:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A0D96148F;
        Mon, 24 Jan 2022 21:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F1AEC340E4;
        Mon, 24 Jan 2022 21:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058926;
        bh=MLNAbOa1lCHdxJ+UNfUyao4m/T1WwTpsj8tHSXjqPBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QxtBznQIEH0rqBnGvBypqAJeSCMLX5gMR7tp6dJ0z1OTc18VqT0yRGps1/ObsqKq3
         etZFXmduSCtMGPsaCuvW+JSIULccOhGv+Amk86y42154W755T9Emufwr/7xiGZ3Ig4
         4sILO2jiOC3yYYMPaYGRdlO9Hdm0ly4A6kItOiKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0440/1039] bnxt_en: use firmware provided max timeout for messages
Date:   Mon, 24 Jan 2022 19:37:09 +0100
Message-Id: <20220124184140.083005088@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

[ Upstream commit bce9a0b7900836df223ab638090df0cb8430d9e8 ]

Some older devices cannot accommodate the 40 seconds timeout
cap for long running commands (such as NVRAM commands) due to
hardware limitations. Allow these devices to request more time for
these long running commands, but print a warning, since the longer
timeout may cause the hung task watchdog to trigger. In the case of a
firmware update operation, this is preferable to failing outright.

v2: Use bp->hwrm_cmd_max_timeout directly without the constants.

Fixes: 881d8353b05e ("bnxt_en: Add an upper bound for all firmware command timeouts.")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          | 6 ++++++
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          | 3 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c | 4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c  | 9 +++------
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c     | 2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h     | 3 +--
 6 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c04ea83188e22..7eaf74e5b2929 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8008,6 +8008,12 @@ static int bnxt_hwrm_ver_get(struct bnxt *bp)
 	bp->hwrm_cmd_timeout = le16_to_cpu(resp->def_req_timeout);
 	if (!bp->hwrm_cmd_timeout)
 		bp->hwrm_cmd_timeout = DFLT_HWRM_CMD_TIMEOUT;
+	bp->hwrm_cmd_max_timeout = le16_to_cpu(resp->max_req_timeout) * 1000;
+	if (!bp->hwrm_cmd_max_timeout)
+		bp->hwrm_cmd_max_timeout = HWRM_CMD_MAX_TIMEOUT;
+	else if (bp->hwrm_cmd_max_timeout > HWRM_CMD_MAX_TIMEOUT)
+		netdev_warn(bp->dev, "Device requests max timeout of %d seconds, may trigger hung task watchdog\n",
+			    bp->hwrm_cmd_max_timeout / 1000);
 
 	if (resp->hwrm_intf_maj_8b >= 1) {
 		bp->hwrm_max_req_len = le16_to_cpu(resp->max_req_win_len);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 4c9507d82fd0d..6bacd5fae6ba5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1985,7 +1985,8 @@ struct bnxt {
 
 	u16			hwrm_max_req_len;
 	u16			hwrm_max_ext_req_len;
-	int			hwrm_cmd_timeout;
+	unsigned int		hwrm_cmd_timeout;
+	unsigned int		hwrm_cmd_max_timeout;
 	struct mutex		hwrm_cmd_lock;	/* serialize hwrm messages */
 	struct hwrm_ver_get_output	ver_resp;
 #define FW_VER_STR_LEN		32
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
index d3cb2f21946da..c067898820360 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_coredump.c
@@ -32,7 +32,7 @@ static int bnxt_hwrm_dbg_dma_data(struct bnxt *bp, void *msg,
 		return -ENOMEM;
 	}
 
-	hwrm_req_timeout(bp, msg, HWRM_COREDUMP_TIMEOUT);
+	hwrm_req_timeout(bp, msg, bp->hwrm_cmd_max_timeout);
 	cmn_resp = hwrm_req_hold(bp, msg);
 	resp = cmn_resp;
 
@@ -125,7 +125,7 @@ static int bnxt_hwrm_dbg_coredump_initiate(struct bnxt *bp, u16 component_id,
 	if (rc)
 		return rc;
 
-	hwrm_req_timeout(bp, req, HWRM_COREDUMP_TIMEOUT);
+	hwrm_req_timeout(bp, req, bp->hwrm_cmd_max_timeout);
 	req->component_id = cpu_to_le16(component_id);
 	req->segment_id = cpu_to_le16(segment_id);
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 8188d55722e4b..7307df49c1313 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -31,9 +31,6 @@
 #include "bnxt_nvm_defs.h"	/* NVRAM content constant and structure defs */
 #include "bnxt_fw_hdr.h"	/* Firmware hdr constant and structure defs */
 #include "bnxt_coredump.h"
-#define FLASH_NVRAM_TIMEOUT	((HWRM_CMD_TIMEOUT) * 100)
-#define FLASH_PACKAGE_TIMEOUT	((HWRM_CMD_TIMEOUT) * 200)
-#define INSTALL_PACKAGE_TIMEOUT	((HWRM_CMD_TIMEOUT) * 200)
 
 static u32 bnxt_get_msglevel(struct net_device *dev)
 {
@@ -2169,7 +2166,7 @@ static int bnxt_flash_nvram(struct net_device *dev, u16 dir_type,
 		req->host_src_addr = cpu_to_le64(dma_handle);
 	}
 
-	hwrm_req_timeout(bp, req, FLASH_NVRAM_TIMEOUT);
+	hwrm_req_timeout(bp, req, bp->hwrm_cmd_max_timeout);
 	req->dir_type = cpu_to_le16(dir_type);
 	req->dir_ordinal = cpu_to_le16(dir_ordinal);
 	req->dir_ext = cpu_to_le16(dir_ext);
@@ -2515,8 +2512,8 @@ int bnxt_flash_package_from_fw_obj(struct net_device *dev, const struct firmware
 		return rc;
 	}
 
-	hwrm_req_timeout(bp, modify, FLASH_PACKAGE_TIMEOUT);
-	hwrm_req_timeout(bp, install, INSTALL_PACKAGE_TIMEOUT);
+	hwrm_req_timeout(bp, modify, bp->hwrm_cmd_max_timeout);
+	hwrm_req_timeout(bp, install, bp->hwrm_cmd_max_timeout);
 
 	hwrm_req_hold(bp, modify);
 	modify->host_src_addr = cpu_to_le64(dma_handle);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
index bb7327b82d0b2..8171f4912fa01 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c
@@ -496,7 +496,7 @@ static int __hwrm_send(struct bnxt *bp, struct bnxt_hwrm_ctx *ctx)
 	}
 
 	/* Limit timeout to an upper limit */
-	timeout = min_t(uint, ctx->timeout, HWRM_CMD_MAX_TIMEOUT);
+	timeout = min(ctx->timeout, bp->hwrm_cmd_max_timeout ?: HWRM_CMD_MAX_TIMEOUT);
 	/* convert timeout to usec */
 	timeout *= 1000;
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
index 4d17f0d5363bb..9a9fc4e8041b6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.h
@@ -58,11 +58,10 @@ void hwrm_update_token(struct bnxt *bp, u16 seq, enum bnxt_hwrm_wait_state s);
 
 #define BNXT_HWRM_MAX_REQ_LEN		(bp->hwrm_max_req_len)
 #define BNXT_HWRM_SHORT_REQ_LEN		sizeof(struct hwrm_short_input)
-#define HWRM_CMD_MAX_TIMEOUT		40000
+#define HWRM_CMD_MAX_TIMEOUT		40000U
 #define SHORT_HWRM_CMD_TIMEOUT		20
 #define HWRM_CMD_TIMEOUT		(bp->hwrm_cmd_timeout)
 #define HWRM_RESET_TIMEOUT		((HWRM_CMD_TIMEOUT) * 4)
-#define HWRM_COREDUMP_TIMEOUT		((HWRM_CMD_TIMEOUT) * 12)
 #define BNXT_HWRM_TARGET		0xffff
 #define BNXT_HWRM_NO_CMPL_RING		-1
 #define BNXT_HWRM_REQ_MAX_SIZE		128
-- 
2.34.1



