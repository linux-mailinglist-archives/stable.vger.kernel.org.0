Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BC421FAE7
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 20:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731026AbgGNS4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730217AbgGNS4r (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:56:47 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECAC7229CA;
        Tue, 14 Jul 2020 18:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753006;
        bh=fyIViGjnqT3Isc8lUNNxqQHXm6quHzb/i5mIuWINQ9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OVFtWbRHUm4Pj4kiwluSHPXCPV1PE05g2MceISX6+J5Jn7Y10dZnxz1aLoVKx+Hf8
         YWRf0hlY/hE3rpzTpypg3Hb3EczEg9H1k72CNq4rhYJxKIjF3j/pJVqDtMK4hMcxX0
         V+7TxzWEQ/eIWDdThz+pLLhdNCxzLByru89e1YvE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 083/166] net: qed: fix buffer overflow on ethtool -d
Date:   Tue, 14 Jul 2020 20:44:08 +0200
Message-Id: <20200714184119.826423080@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@marvell.com>

[ Upstream commit da3287111ab43b32cec54d7ca6b48640f210a196 ]

When generating debug dump, driver firstly collects all data in binary
form, and then performs per-feature formatting to human-readable if it
is supported.

For ethtool -d, this is roughly incorrect for two reasons. First of all,
drivers should always provide only original raw dumps to Ethtool without
any changes.
The second, and more critical, is that Ethtool's output buffer size is
strictly determined by ethtool_ops::get_regs_len(), and all data *must*
fit in it. The current version of driver always returns the size of raw
data, but the size of the formatted buffer exceeds it in most cases.
This leads to out-of-bound writes and memory corruption.

Address both issues by adding an option to return original, non-formatted
debug data, and using it for Ethtool case.

v2:
 - Expand commit message to make it more clear;
 - No functional changes.

Fixes: c965db444629 ("qed: Add support for debug data collection")
Signed-off-by: Alexander Lobakin <alobakin@marvell.com>
Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qed/qed.h       |  2 ++
 drivers/net/ethernet/qlogic/qed/qed_debug.c | 13 ++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed.h b/drivers/net/ethernet/qlogic/qed/qed.h
index fa41bf08a5895..58d6ef489d5bf 100644
--- a/drivers/net/ethernet/qlogic/qed/qed.h
+++ b/drivers/net/ethernet/qlogic/qed/qed.h
@@ -880,6 +880,8 @@ struct qed_dev {
 #endif
 	struct qed_dbg_feature dbg_features[DBG_FEATURE_NUM];
 	bool disable_ilt_dump;
+	bool				dbg_bin_dump;
+
 	DECLARE_HASHTABLE(connections, 10);
 	const struct firmware		*firmware;
 
diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index 3e56b6056b477..03ce18f653932 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -7506,6 +7506,12 @@ static enum dbg_status format_feature(struct qed_hwfn *p_hwfn,
 	if (p_hwfn->cdev->dbg_params.print_data)
 		qed_dbg_print_feature(text_buf, text_size_bytes);
 
+	/* Just return the original binary buffer if requested */
+	if (p_hwfn->cdev->dbg_bin_dump) {
+		vfree(text_buf);
+		return DBG_STATUS_OK;
+	}
+
 	/* Free the old dump_buf and point the dump_buf to the newly allocagted
 	 * and formatted text buffer.
 	 */
@@ -7733,7 +7739,9 @@ int qed_dbg_mcp_trace_size(struct qed_dev *cdev)
 #define REGDUMP_HEADER_SIZE_SHIFT		0
 #define REGDUMP_HEADER_SIZE_MASK		0xffffff
 #define REGDUMP_HEADER_FEATURE_SHIFT		24
-#define REGDUMP_HEADER_FEATURE_MASK		0x3f
+#define REGDUMP_HEADER_FEATURE_MASK		0x1f
+#define REGDUMP_HEADER_BIN_DUMP_SHIFT		29
+#define REGDUMP_HEADER_BIN_DUMP_MASK		0x1
 #define REGDUMP_HEADER_OMIT_ENGINE_SHIFT	30
 #define REGDUMP_HEADER_OMIT_ENGINE_MASK		0x1
 #define REGDUMP_HEADER_ENGINE_SHIFT		31
@@ -7771,6 +7779,7 @@ static u32 qed_calc_regdump_header(struct qed_dev *cdev,
 			  feature, feature_size);
 
 	SET_FIELD(res, REGDUMP_HEADER_FEATURE, feature);
+	SET_FIELD(res, REGDUMP_HEADER_BIN_DUMP, 1);
 	SET_FIELD(res, REGDUMP_HEADER_OMIT_ENGINE, omit_engine);
 	SET_FIELD(res, REGDUMP_HEADER_ENGINE, engine);
 
@@ -7794,6 +7803,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 		omit_engine = 1;
 
 	mutex_lock(&qed_dbg_lock);
+	cdev->dbg_bin_dump = true;
 
 	org_engine = qed_get_debug_engine(cdev);
 	for (cur_engine = 0; cur_engine < cdev->num_hwfns; cur_engine++) {
@@ -7993,6 +8003,7 @@ int qed_dbg_all_data(struct qed_dev *cdev, void *buffer)
 		       QED_NVM_IMAGE_MDUMP, "QED_NVM_IMAGE_MDUMP", rc);
 	}
 
+	cdev->dbg_bin_dump = false;
 	mutex_unlock(&qed_dbg_lock);
 
 	return 0;
-- 
2.25.1



