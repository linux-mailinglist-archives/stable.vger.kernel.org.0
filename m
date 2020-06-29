Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E8F20E56C
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391354AbgF2Vgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:36:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728418AbgF2Skj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:39 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D946624057;
        Mon, 29 Jun 2020 15:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443927;
        bh=t/b9Yy4wxmxMTwaghNoK/5iWjs02b9iKY57KwWekuGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IWlQJfL6rgDvCe9lU66GlNY3t9grfLU16gWAagS2wZE3nPqwxFbh+Aj9ncwbskY6Y
         tVOMFn81Zn7NYIb+PXMHp4PDJak5fUB5CWE/hO2DQt18gBsvBzB1vn3LHBFmfGjfYA
         362dQIfZhpTHUPLo9sV4iZ7hbnWnfzgZ9nK6wLS8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 028/265] bnxt_en: Store the running firmware version code.
Date:   Mon, 29 Jun 2020 11:14:21 -0400
Message-Id: <20200629151818.2493727-29-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit d0ad2ea2bc185835f8a749302ad07b70528d2a09 ]

We currently only store the firmware version as a string for ethtool
and devlink info.  Store it also as a version code.  The next 2
patches will need to check the firmware major version to determine
some workarounds.

We also use the 16-bit firmware version fields if the firmware is newer
and provides the 16-bit fields.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 22 ++++++++++++++++++----
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |  4 ++++
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 19c4a0a5727a4..83ed6f31a1fae 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7217,8 +7217,9 @@ static int __bnxt_hwrm_ver_get(struct bnxt *bp, bool silent)
 static int bnxt_hwrm_ver_get(struct bnxt *bp)
 {
 	struct hwrm_ver_get_output *resp = bp->hwrm_cmd_resp_addr;
+	u16 fw_maj, fw_min, fw_bld, fw_rsv;
 	u32 dev_caps_cfg, hwrm_ver;
-	int rc;
+	int rc, len;
 
 	bp->hwrm_max_req_len = HWRM_MAX_REQ_LEN;
 	mutex_lock(&bp->hwrm_cmd_lock);
@@ -7250,9 +7251,22 @@ static int bnxt_hwrm_ver_get(struct bnxt *bp)
 			 resp->hwrm_intf_maj_8b, resp->hwrm_intf_min_8b,
 			 resp->hwrm_intf_upd_8b);
 
-	snprintf(bp->fw_ver_str, BC_HWRM_STR_LEN, "%d.%d.%d.%d",
-		 resp->hwrm_fw_maj_8b, resp->hwrm_fw_min_8b,
-		 resp->hwrm_fw_bld_8b, resp->hwrm_fw_rsvd_8b);
+	fw_maj = le16_to_cpu(resp->hwrm_fw_major);
+	if (bp->hwrm_spec_code > 0x10803 && fw_maj) {
+		fw_min = le16_to_cpu(resp->hwrm_fw_minor);
+		fw_bld = le16_to_cpu(resp->hwrm_fw_build);
+		fw_rsv = le16_to_cpu(resp->hwrm_fw_patch);
+		len = FW_VER_STR_LEN;
+	} else {
+		fw_maj = resp->hwrm_fw_maj_8b;
+		fw_min = resp->hwrm_fw_min_8b;
+		fw_bld = resp->hwrm_fw_bld_8b;
+		fw_rsv = resp->hwrm_fw_rsvd_8b;
+		len = BC_HWRM_STR_LEN;
+	}
+	bp->fw_ver_code = BNXT_FW_VER_CODE(fw_maj, fw_min, fw_bld, fw_rsv);
+	snprintf(bp->fw_ver_str, len, "%d.%d.%d.%d", fw_maj, fw_min, fw_bld,
+		 fw_rsv);
 
 	if (strlen(resp->active_pkg_name)) {
 		int fw_ver_len = strlen(bp->fw_ver_str);
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 3d39638521d6c..a880aea0c20b5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1729,6 +1729,10 @@ struct bnxt {
 #define PHY_VER_STR_LEN         (FW_VER_STR_LEN - BC_HWRM_STR_LEN)
 	char			fw_ver_str[FW_VER_STR_LEN];
 	char			hwrm_ver_supp[FW_VER_STR_LEN];
+	u64			fw_ver_code;
+#define BNXT_FW_VER_CODE(maj, min, bld, rsv)			\
+	((u64)(maj) << 48 | (u64)(min) << 32 | (u64)(bld) << 16 | (rsv))
+
 	__be16			vxlan_port;
 	u8			vxlan_port_cnt;
 	__le16			vxlan_fw_dst_port_id;
-- 
2.25.1

