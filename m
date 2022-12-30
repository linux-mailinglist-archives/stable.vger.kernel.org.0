Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE4FC657FA6
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:07:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbiL1QHb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:07:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiL1QHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:07:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4108A18E16
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:07:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B311E60D41
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:06:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CCEC433EF;
        Wed, 28 Dec 2022 16:06:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243619;
        bh=t0h4UaI+zYqqw51lWQ5WiVblmXz5jitTT8TquXMxQd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qDqHLOXRHJm7cR7QEW1HRfUwSokDgc8a7CyHgCgKr/vte9cNWPXVicRSSCAvtUzfY
         VjnJSFbyoaDzYMx6eUwDnj3viLh5vPvM/s7IDdjwI3Huh7CgQN2aGwpqfxix4eI4Ad
         SqrtV1Y3XGrAg8VdX6kqwkVVej28d/jnxNlLcWpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Weili Qian <qianweili@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0558/1073] crypto: hisilicon/qm - get hardware features from hardware registers
Date:   Wed, 28 Dec 2022 15:35:46 +0100
Message-Id: <20221228144343.211613172@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit 82f00b24f532557fb0e15a6a2747859e4b70c4bd ]

Before hardware V3, hardwares do not provide the feature registers,
driver resolves hardware differences based on the hardware version.
As a result, the driver does not support the new hardware.

Hardware V3 and later versions support to obtain hardware features,
such as power-gating management and doorbell isolation, through
the hardware registers. To be compatible with later hardware versions,
the features of the current device is obtained by reading the
hardware registers instead of the hardware version.

Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Stable-dep-of: ee1537fe3dd8 ("crypto: hisilicon/qm - re-enable communicate interrupt before notifying PF")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/hpre/hpre_main.c |   4 +-
 drivers/crypto/hisilicon/qm.c             | 196 +++++++++++++++-------
 drivers/crypto/hisilicon/sec2/sec_main.c  |   4 +-
 drivers/crypto/hisilicon/zip/zip_main.c   |   4 +-
 include/linux/hisi_acc_qm.h               |  31 +++-
 5 files changed, 170 insertions(+), 69 deletions(-)

diff --git a/drivers/crypto/hisilicon/hpre/hpre_main.c b/drivers/crypto/hisilicon/hpre/hpre_main.c
index 9d529df0eab9..fd55c6ff13ba 100644
--- a/drivers/crypto/hisilicon/hpre/hpre_main.c
+++ b/drivers/crypto/hisilicon/hpre/hpre_main.c
@@ -457,7 +457,7 @@ static void hpre_open_sva_prefetch(struct hisi_qm *qm)
 	u32 val;
 	int ret;
 
-	if (qm->ver < QM_HW_V3)
+	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
 		return;
 
 	/* Enable prefetch */
@@ -478,7 +478,7 @@ static void hpre_close_sva_prefetch(struct hisi_qm *qm)
 	u32 val;
 	int ret;
 
-	if (qm->ver < QM_HW_V3)
+	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
 		return;
 
 	val = readl_relaxed(qm->io_base + HPRE_PREFETCH_CFG);
diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index bdb7d5ba23b8..2cfb072a218f 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -86,9 +86,7 @@
 #define QM_DB_CMD_SHIFT_V1		16
 #define QM_DB_INDEX_SHIFT_V1		32
 #define QM_DB_PRIORITY_SHIFT_V1		48
-#define QM_QUE_ISO_CFG_V		0x0030
 #define QM_PAGE_SIZE			0x0034
-#define QM_QUE_ISO_EN			0x100154
 #define QM_CAPBILITY			0x100158
 #define QM_QP_NUN_MASK			GENMASK(10, 0)
 #define QM_QP_DB_INTERVAL		0x10000
@@ -205,6 +203,8 @@
 #define MAX_WAIT_COUNTS			1000
 #define QM_CACHE_WB_START		0x204
 #define QM_CACHE_WB_DONE		0x208
+#define QM_FUNC_CAPS_REG		0x3100
+#define QM_CAPBILITY_VERSION		GENMASK(7, 0)
 
 #define PCI_BAR_2			2
 #define PCI_BAR_4			4
@@ -329,6 +329,22 @@ enum qm_mb_cmd {
 	QM_VF_GET_QOS,
 };
 
+static const struct hisi_qm_cap_info qm_cap_info_comm[] = {
+	{QM_SUPPORT_DB_ISOLATION, 0x30,   0, BIT(0),  0x0, 0x0, 0x0},
+	{QM_SUPPORT_FUNC_QOS,     0x3100, 0, BIT(8),  0x0, 0x0, 0x1},
+	{QM_SUPPORT_STOP_QP,      0x3100, 0, BIT(9),  0x0, 0x0, 0x1},
+	{QM_SUPPORT_MB_COMMAND,   0x3100, 0, BIT(11), 0x0, 0x0, 0x1},
+	{QM_SUPPORT_SVA_PREFETCH, 0x3100, 0, BIT(14), 0x0, 0x0, 0x1},
+};
+
+static const struct hisi_qm_cap_info qm_cap_info_pf[] = {
+	{QM_SUPPORT_RPM, 0x3100, 0, BIT(13), 0x0, 0x0, 0x1},
+};
+
+static const struct hisi_qm_cap_info qm_cap_info_vf[] = {
+	{QM_SUPPORT_RPM, 0x3100, 0, BIT(12), 0x0, 0x0, 0x0},
+};
+
 struct qm_cqe {
 	__le32 rsvd0;
 	__le16 cmd_id;
@@ -426,10 +442,7 @@ struct hisi_qm_hw_ops {
 	void (*hw_error_init)(struct hisi_qm *qm, u32 ce, u32 nfe, u32 fe);
 	void (*hw_error_uninit)(struct hisi_qm *qm);
 	enum acc_err_result (*hw_error_handle)(struct hisi_qm *qm);
-	int (*stop_qp)(struct hisi_qp *qp);
 	int (*set_msi)(struct hisi_qm *qm, bool set);
-	int (*ping_all_vfs)(struct hisi_qm *qm, u64 cmd);
-	int (*ping_pf)(struct hisi_qm *qm, u64 cmd);
 };
 
 struct qm_dfx_item {
@@ -828,6 +841,36 @@ static int qm_dev_mem_reset(struct hisi_qm *qm)
 					  POLL_TIMEOUT);
 }
 
+/**
+ * hisi_qm_get_hw_info() - Get device information.
+ * @qm: The qm which want to get information.
+ * @info_table: Array for storing device information.
+ * @index: Index in info_table.
+ * @is_read: Whether read from reg, 0: not support read from reg.
+ *
+ * This function returns device information the caller needs.
+ */
+u32 hisi_qm_get_hw_info(struct hisi_qm *qm,
+			const struct hisi_qm_cap_info *info_table,
+			u32 index, bool is_read)
+{
+	u32 val;
+
+	switch (qm->ver) {
+	case QM_HW_V1:
+		return info_table[index].v1_val;
+	case QM_HW_V2:
+		return info_table[index].v2_val;
+	default:
+		if (!is_read)
+			return info_table[index].v3_val;
+
+		val = readl(qm->io_base + info_table[index].offset);
+		return (val >> info_table[index].shift) & info_table[index].mask;
+	}
+}
+EXPORT_SYMBOL_GPL(hisi_qm_get_hw_info);
+
 static u32 qm_get_irq_num_v1(struct hisi_qm *qm)
 {
 	return QM_IRQ_NUM_V1;
@@ -854,7 +897,7 @@ static int qm_pm_get_sync(struct hisi_qm *qm)
 	struct device *dev = &qm->pdev->dev;
 	int ret;
 
-	if (qm->fun_type == QM_HW_VF || qm->ver < QM_HW_V3)
+	if (!test_bit(QM_SUPPORT_RPM, &qm->caps))
 		return 0;
 
 	ret = pm_runtime_resume_and_get(dev);
@@ -870,7 +913,7 @@ static void qm_pm_put_sync(struct hisi_qm *qm)
 {
 	struct device *dev = &qm->pdev->dev;
 
-	if (qm->fun_type == QM_HW_VF || qm->ver < QM_HW_V3)
+	if (!test_bit(QM_SUPPORT_RPM, &qm->caps))
 		return;
 
 	pm_runtime_mark_last_busy(dev);
@@ -1151,7 +1194,7 @@ static void qm_init_prefetch(struct hisi_qm *qm)
 	struct device *dev = &qm->pdev->dev;
 	u32 page_type = 0x0;
 
-	if (qm->ver < QM_HW_V3)
+	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
 		return;
 
 	switch (PAGE_SIZE) {
@@ -1270,7 +1313,7 @@ static void qm_vft_data_cfg(struct hisi_qm *qm, enum vft_type type, u32 base,
 			}
 			break;
 		case SHAPER_VFT:
-			if (qm->ver >= QM_HW_V3) {
+			if (factor) {
 				tmp = factor->cir_b |
 				(factor->cir_u << QM_SHAPER_FACTOR_CIR_U_SHIFT) |
 				(factor->cir_s << QM_SHAPER_FACTOR_CIR_S_SHIFT) |
@@ -1288,10 +1331,13 @@ static void qm_vft_data_cfg(struct hisi_qm *qm, enum vft_type type, u32 base,
 static int qm_set_vft_common(struct hisi_qm *qm, enum vft_type type,
 			     u32 fun_num, u32 base, u32 number)
 {
-	struct qm_shaper_factor *factor = &qm->factor[fun_num];
+	struct qm_shaper_factor *factor = NULL;
 	unsigned int val;
 	int ret;
 
+	if (type == SHAPER_VFT && test_bit(QM_SUPPORT_FUNC_QOS, &qm->caps))
+		factor = &qm->factor[fun_num];
+
 	ret = readl_relaxed_poll_timeout(qm->io_base + QM_VFT_CFG_RDY, val,
 					 val & BIT(0), POLL_PERIOD,
 					 POLL_TIMEOUT);
@@ -1349,7 +1395,7 @@ static int qm_set_sqc_cqc_vft(struct hisi_qm *qm, u32 fun_num, u32 base,
 	}
 
 	/* init default shaper qos val */
-	if (qm->ver >= QM_HW_V3) {
+	if (test_bit(QM_SUPPORT_FUNC_QOS, &qm->caps)) {
 		ret = qm_shaper_init_vft(qm, fun_num);
 		if (ret)
 			goto back_sqc_cqc;
@@ -2495,7 +2541,7 @@ static int qm_wait_vf_prepare_finish(struct hisi_qm *qm)
 	u64 val;
 	u32 i;
 
-	if (!qm->vfs_num || qm->ver < QM_HW_V3)
+	if (!qm->vfs_num || !test_bit(QM_SUPPORT_MB_COMMAND, &qm->caps))
 		return 0;
 
 	while (true) {
@@ -2780,10 +2826,7 @@ static const struct hisi_qm_hw_ops qm_hw_ops_v3 = {
 	.hw_error_init = qm_hw_error_init_v3,
 	.hw_error_uninit = qm_hw_error_uninit_v3,
 	.hw_error_handle = qm_hw_error_handle_v2,
-	.stop_qp = qm_stop_qp,
 	.set_msi = qm_set_msi_v3,
-	.ping_all_vfs = qm_ping_all_vfs,
-	.ping_pf = qm_ping_pf,
 };
 
 static void *qm_get_avail_sqe(struct hisi_qp *qp)
@@ -3080,8 +3123,8 @@ static int qm_drain_qp(struct hisi_qp *qp)
 		return 0;
 
 	/* Kunpeng930 supports drain qp by device */
-	if (qm->ops->stop_qp) {
-		ret = qm->ops->stop_qp(qp);
+	if (test_bit(QM_SUPPORT_STOP_QP, &qm->caps)) {
+		ret = qm_stop_qp(qp);
 		if (ret)
 			dev_err(dev, "Failed to stop qp(%u)!\n", qp->qp_id);
 		return ret;
@@ -3312,7 +3355,7 @@ static int hisi_qm_uacce_mmap(struct uacce_queue *q,
 		if (qm->ver == QM_HW_V1) {
 			if (sz > PAGE_SIZE * QM_DOORBELL_PAGE_NR)
 				return -EINVAL;
-		} else if (qm->ver == QM_HW_V2 || !qm->use_db_isolation) {
+		} else if (!test_bit(QM_SUPPORT_DB_ISOLATION, &qm->caps)) {
 			if (sz > PAGE_SIZE * (QM_DOORBELL_PAGE_NR +
 			    QM_DOORBELL_SQ_CQ_BASE_V2 / PAGE_SIZE))
 				return -EINVAL;
@@ -3466,7 +3509,7 @@ static int qm_alloc_uacce(struct hisi_qm *qm)
 
 	if (qm->ver == QM_HW_V1)
 		mmio_page_nr = QM_DOORBELL_PAGE_NR;
-	else if (qm->ver == QM_HW_V2 || !qm->use_db_isolation)
+	else if (!test_bit(QM_SUPPORT_DB_ISOLATION, &qm->caps))
 		mmio_page_nr = QM_DOORBELL_PAGE_NR +
 			QM_DOORBELL_SQ_CQ_BASE_V2 / PAGE_SIZE;
 	else
@@ -3628,7 +3671,7 @@ static void hisi_qm_pre_init(struct hisi_qm *qm)
 	init_rwsem(&qm->qps_lock);
 	qm->qp_in_used = 0;
 	qm->misc_ctl = false;
-	if (qm->fun_type == QM_HW_PF && qm->ver > QM_HW_V2) {
+	if (test_bit(QM_SUPPORT_RPM, &qm->caps)) {
 		if (!acpi_device_power_manageable(ACPI_COMPANION(&pdev->dev)))
 			dev_info(&pdev->dev, "_PS0 and _PR0 are not defined");
 	}
@@ -3638,7 +3681,7 @@ static void qm_cmd_uninit(struct hisi_qm *qm)
 {
 	u32 val;
 
-	if (qm->ver < QM_HW_V3)
+	if (!test_bit(QM_SUPPORT_MB_COMMAND, &qm->caps))
 		return;
 
 	val = readl(qm->io_base + QM_IFC_INT_MASK);
@@ -3650,7 +3693,7 @@ static void qm_cmd_init(struct hisi_qm *qm)
 {
 	u32 val;
 
-	if (qm->ver < QM_HW_V3)
+	if (!test_bit(QM_SUPPORT_MB_COMMAND, &qm->caps))
 		return;
 
 	/* Clear communication interrupt source */
@@ -3666,7 +3709,7 @@ static void qm_put_pci_res(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
 
-	if (qm->use_db_isolation)
+	if (test_bit(QM_SUPPORT_DB_ISOLATION, &qm->caps))
 		iounmap(qm->db_io_base);
 
 	iounmap(qm->io_base);
@@ -3716,7 +3759,9 @@ static void hisi_qm_memory_uninit(struct hisi_qm *qm)
 	}
 
 	idr_destroy(&qm->qp_idr);
-	kfree(qm->factor);
+
+	if (test_bit(QM_SUPPORT_FUNC_QOS, &qm->caps))
+		kfree(qm->factor);
 }
 
 /**
@@ -4499,12 +4544,10 @@ static int qm_vf_read_qos(struct hisi_qm *qm)
 	qm->mb_qos = 0;
 
 	/* vf ping pf to get function qos */
-	if (qm->ops->ping_pf) {
-		ret = qm->ops->ping_pf(qm, QM_VF_GET_QOS);
-		if (ret) {
-			pci_err(qm->pdev, "failed to send cmd to PF to get qos!\n");
-			return ret;
-		}
+	ret = qm_ping_pf(qm, QM_VF_GET_QOS);
+	if (ret) {
+		pci_err(qm->pdev, "failed to send cmd to PF to get qos!\n");
+		return ret;
 	}
 
 	while (true) {
@@ -4676,14 +4719,14 @@ static const struct file_operations qm_algqos_fops = {
  * hisi_qm_set_algqos_init() - Initialize function qos debugfs files.
  * @qm: The qm for which we want to add debugfs files.
  *
- * Create function qos debugfs files.
+ * Create function qos debugfs files, VF ping PF to get function qos.
  */
 static void hisi_qm_set_algqos_init(struct hisi_qm *qm)
 {
 	if (qm->fun_type == QM_HW_PF)
 		debugfs_create_file("alg_qos", 0644, qm->debug.debug_root,
 				    qm, &qm_algqos_fops);
-	else
+	else if (test_bit(QM_SUPPORT_MB_COMMAND, &qm->caps))
 		debugfs_create_file("alg_qos", 0444, qm->debug.debug_root,
 				    qm, &qm_algqos_fops);
 }
@@ -4731,7 +4774,7 @@ void hisi_qm_debug_init(struct hisi_qm *qm)
 			&qm_atomic64_ops);
 	}
 
-	if (qm->ver >= QM_HW_V3)
+	if (test_bit(QM_SUPPORT_FUNC_QOS, &qm->caps))
 		hisi_qm_set_algqos_init(qm);
 }
 EXPORT_SYMBOL_GPL(hisi_qm_debug_init);
@@ -4848,7 +4891,9 @@ int hisi_qm_sriov_disable(struct pci_dev *pdev, bool is_frozen)
 
 	pci_disable_sriov(pdev);
 	/* clear vf function shaper configure array */
-	memset(qm->factor + 1, 0, sizeof(struct qm_shaper_factor) * total_vfs);
+	if (test_bit(QM_SUPPORT_FUNC_QOS, &qm->caps))
+		memset(qm->factor + 1, 0, sizeof(struct qm_shaper_factor) * total_vfs);
+
 	ret = qm_clear_vft_config(qm);
 	if (ret)
 		return ret;
@@ -5072,8 +5117,8 @@ static int qm_try_stop_vfs(struct hisi_qm *qm, u64 cmd,
 		return 0;
 
 	/* Kunpeng930 supports to notify VFs to stop before PF reset */
-	if (qm->ops->ping_all_vfs) {
-		ret = qm->ops->ping_all_vfs(qm, cmd);
+	if (test_bit(QM_SUPPORT_MB_COMMAND, &qm->caps)) {
+		ret = qm_ping_all_vfs(qm, cmd);
 		if (ret)
 			pci_err(pdev, "failed to send cmd to all VFs before PF reset!\n");
 	} else {
@@ -5264,8 +5309,8 @@ static int qm_try_start_vfs(struct hisi_qm *qm, enum qm_mb_cmd cmd)
 	}
 
 	/* Kunpeng930 supports to notify VFs to start after PF reset. */
-	if (qm->ops->ping_all_vfs) {
-		ret = qm->ops->ping_all_vfs(qm, cmd);
+	if (test_bit(QM_SUPPORT_MB_COMMAND, &qm->caps)) {
+		ret = qm_ping_all_vfs(qm, cmd);
 		if (ret)
 			pci_warn(pdev, "failed to send cmd to all VFs after PF reset!\n");
 	} else {
@@ -5713,7 +5758,7 @@ static void qm_pf_reset_vf_prepare(struct hisi_qm *qm,
 	hisi_qm_set_hw_reset(qm, QM_RESET_STOP_RX_OFFSET);
 out:
 	pci_save_state(pdev);
-	ret = qm->ops->ping_pf(qm, cmd);
+	ret = qm_ping_pf(qm, cmd);
 	if (ret)
 		dev_warn(&pdev->dev, "PF responds timeout in reset prepare!\n");
 }
@@ -5731,7 +5776,7 @@ static void qm_pf_reset_vf_done(struct hisi_qm *qm)
 		cmd = QM_VF_START_FAIL;
 	}
 
-	ret = qm->ops->ping_pf(qm, cmd);
+	ret = qm_ping_pf(qm, cmd);
 	if (ret)
 		dev_warn(&pdev->dev, "PF responds timeout in reset done!\n");
 
@@ -5936,7 +5981,7 @@ static int qm_get_qp_num(struct hisi_qm *qm)
 		qm->ctrl_qp_num = readl(qm->io_base + QM_CAPBILITY) &
 					QM_QP_NUN_MASK;
 
-	if (qm->use_db_isolation)
+	if (test_bit(QM_SUPPORT_DB_ISOLATION, &qm->caps))
 		qm->max_qp_num = (readl(qm->io_base + QM_CAPBILITY) >>
 				  QM_QP_MAX_NUM_SHIFT) & QM_QP_NUN_MASK;
 	else
@@ -5952,6 +5997,39 @@ static int qm_get_qp_num(struct hisi_qm *qm)
 	return 0;
 }
 
+static void qm_get_hw_caps(struct hisi_qm *qm)
+{
+	const struct hisi_qm_cap_info *cap_info = qm->fun_type == QM_HW_PF ?
+						  qm_cap_info_pf : qm_cap_info_vf;
+	u32 size = qm->fun_type == QM_HW_PF ? ARRAY_SIZE(qm_cap_info_pf) :
+				   ARRAY_SIZE(qm_cap_info_vf);
+	u32 val, i;
+
+	/* Doorbell isolate register is a independent register. */
+	val = hisi_qm_get_hw_info(qm, qm_cap_info_comm, QM_SUPPORT_DB_ISOLATION, true);
+	if (val)
+		set_bit(QM_SUPPORT_DB_ISOLATION, &qm->caps);
+
+	if (qm->ver >= QM_HW_V3) {
+		val = readl(qm->io_base + QM_FUNC_CAPS_REG);
+		qm->cap_ver = val & QM_CAPBILITY_VERSION;
+	}
+
+	/* Get PF/VF common capbility */
+	for (i = 1; i < ARRAY_SIZE(qm_cap_info_comm); i++) {
+		val = hisi_qm_get_hw_info(qm, qm_cap_info_comm, i, qm->cap_ver);
+		if (val)
+			set_bit(qm_cap_info_comm[i].type, &qm->caps);
+	}
+
+	/* Get PF/VF different capbility */
+	for (i = 0; i < size; i++) {
+		val = hisi_qm_get_hw_info(qm, cap_info, i, qm->cap_ver);
+		if (val)
+			set_bit(cap_info[i].type, &qm->caps);
+	}
+}
+
 static int qm_get_pci_res(struct hisi_qm *qm)
 {
 	struct pci_dev *pdev = qm->pdev;
@@ -5971,16 +6049,8 @@ static int qm_get_pci_res(struct hisi_qm *qm)
 		goto err_request_mem_regions;
 	}
 
-	if (qm->ver > QM_HW_V2) {
-		if (qm->fun_type == QM_HW_PF)
-			qm->use_db_isolation = readl(qm->io_base +
-						     QM_QUE_ISO_EN) & BIT(0);
-		else
-			qm->use_db_isolation = readl(qm->io_base +
-						     QM_QUE_ISO_CFG_V) & BIT(0);
-	}
-
-	if (qm->use_db_isolation) {
+	qm_get_hw_caps(qm);
+	if (test_bit(QM_SUPPORT_DB_ISOLATION, &qm->caps)) {
 		qm->db_interval = QM_QP_DB_INTERVAL;
 		qm->db_phys_base = pci_resource_start(pdev, PCI_BAR_4);
 		qm->db_io_base = ioremap(qm->db_phys_base,
@@ -6004,7 +6074,7 @@ static int qm_get_pci_res(struct hisi_qm *qm)
 	return 0;
 
 err_db_ioremap:
-	if (qm->use_db_isolation)
+	if (test_bit(QM_SUPPORT_DB_ISOLATION, &qm->caps))
 		iounmap(qm->db_io_base);
 err_ioremap:
 	iounmap(qm->io_base);
@@ -6121,12 +6191,15 @@ static int hisi_qm_memory_init(struct hisi_qm *qm)
 	int ret, total_func, i;
 	size_t off = 0;
 
-	total_func = pci_sriov_get_totalvfs(qm->pdev) + 1;
-	qm->factor = kcalloc(total_func, sizeof(struct qm_shaper_factor), GFP_KERNEL);
-	if (!qm->factor)
-		return -ENOMEM;
-	for (i = 0; i < total_func; i++)
-		qm->factor[i].func_qos = QM_QOS_MAX_VAL;
+	if (test_bit(QM_SUPPORT_FUNC_QOS, &qm->caps)) {
+		total_func = pci_sriov_get_totalvfs(qm->pdev) + 1;
+		qm->factor = kcalloc(total_func, sizeof(struct qm_shaper_factor), GFP_KERNEL);
+		if (!qm->factor)
+			return -ENOMEM;
+
+		for (i = 0; i < total_func; i++)
+			qm->factor[i].func_qos = QM_QOS_MAX_VAL;
+	}
 
 #define QM_INIT_BUF(qm, type, num) do { \
 	(qm)->type = ((qm)->qdma.va + (off)); \
@@ -6162,7 +6235,8 @@ static int hisi_qm_memory_init(struct hisi_qm *qm)
 	dma_free_coherent(dev, qm->qdma.size, qm->qdma.va, qm->qdma.dma);
 err_destroy_idr:
 	idr_destroy(&qm->qp_idr);
-	kfree(qm->factor);
+	if (test_bit(QM_SUPPORT_FUNC_QOS, &qm->caps))
+		kfree(qm->factor);
 
 	return ret;
 }
@@ -6305,7 +6379,7 @@ void hisi_qm_pm_init(struct hisi_qm *qm)
 {
 	struct device *dev = &qm->pdev->dev;
 
-	if (qm->fun_type == QM_HW_VF || qm->ver < QM_HW_V3)
+	if (!test_bit(QM_SUPPORT_RPM, &qm->caps))
 		return;
 
 	pm_runtime_set_autosuspend_delay(dev, QM_AUTOSUSPEND_DELAY);
@@ -6324,7 +6398,7 @@ void hisi_qm_pm_uninit(struct hisi_qm *qm)
 {
 	struct device *dev = &qm->pdev->dev;
 
-	if (qm->fun_type == QM_HW_VF || qm->ver < QM_HW_V3)
+	if (!test_bit(QM_SUPPORT_RPM, &qm->caps))
 		return;
 
 	pm_runtime_get_noresume(dev);
diff --git a/drivers/crypto/hisilicon/sec2/sec_main.c b/drivers/crypto/hisilicon/sec2/sec_main.c
index 2c0be91c0b09..1ec3b06345fd 100644
--- a/drivers/crypto/hisilicon/sec2/sec_main.c
+++ b/drivers/crypto/hisilicon/sec2/sec_main.c
@@ -415,7 +415,7 @@ static void sec_open_sva_prefetch(struct hisi_qm *qm)
 	u32 val;
 	int ret;
 
-	if (qm->ver < QM_HW_V3)
+	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
 		return;
 
 	/* Enable prefetch */
@@ -435,7 +435,7 @@ static void sec_close_sva_prefetch(struct hisi_qm *qm)
 	u32 val;
 	int ret;
 
-	if (qm->ver < QM_HW_V3)
+	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
 		return;
 
 	val = readl_relaxed(qm->io_base + SEC_PREFETCH_CFG);
diff --git a/drivers/crypto/hisilicon/zip/zip_main.c b/drivers/crypto/hisilicon/zip/zip_main.c
index c3303d99acac..65ed2ae8e131 100644
--- a/drivers/crypto/hisilicon/zip/zip_main.c
+++ b/drivers/crypto/hisilicon/zip/zip_main.c
@@ -348,7 +348,7 @@ static void hisi_zip_open_sva_prefetch(struct hisi_qm *qm)
 	u32 val;
 	int ret;
 
-	if (qm->ver < QM_HW_V3)
+	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
 		return;
 
 	/* Enable prefetch */
@@ -368,7 +368,7 @@ static void hisi_zip_close_sva_prefetch(struct hisi_qm *qm)
 	u32 val;
 	int ret;
 
-	if (qm->ver < QM_HW_V3)
+	if (!test_bit(QM_SUPPORT_SVA_PREFETCH, &qm->caps))
 		return;
 
 	val = readl_relaxed(qm->io_base + HZIP_PREFETCH_CFG);
diff --git a/include/linux/hisi_acc_qm.h b/include/linux/hisi_acc_qm.h
index 116e8bd68c99..851c962ba473 100644
--- a/include/linux/hisi_acc_qm.h
+++ b/include/linux/hisi_acc_qm.h
@@ -168,6 +168,15 @@ enum qm_vf_state {
 	QM_NOT_READY,
 };
 
+enum qm_cap_bits {
+	QM_SUPPORT_DB_ISOLATION = 0x0,
+	QM_SUPPORT_FUNC_QOS,
+	QM_SUPPORT_STOP_QP,
+	QM_SUPPORT_MB_COMMAND,
+	QM_SUPPORT_SVA_PREFETCH,
+	QM_SUPPORT_RPM,
+};
+
 struct dfx_diff_registers {
 	u32 *regs;
 	u32 reg_offset;
@@ -258,6 +267,18 @@ struct hisi_qm_err_ini {
 	void (*err_info_init)(struct hisi_qm *qm);
 };
 
+struct hisi_qm_cap_info {
+	u32 type;
+	/* Register offset */
+	u32 offset;
+	/* Bit offset in register */
+	u32 shift;
+	u32 mask;
+	u32 v1_val;
+	u32 v2_val;
+	u32 v3_val;
+};
+
 struct hisi_qm_list {
 	struct mutex lock;
 	struct list_head list;
@@ -278,6 +299,9 @@ struct hisi_qm {
 	struct pci_dev *pdev;
 	void __iomem *io_base;
 	void __iomem *db_io_base;
+
+	/* Capbility version, 0: not supports */
+	u32 cap_ver;
 	u32 sqe_size;
 	u32 qp_base;
 	u32 qp_num;
@@ -304,6 +328,8 @@ struct hisi_qm {
 	struct hisi_qm_err_info err_info;
 	struct hisi_qm_err_status err_status;
 	unsigned long misc_ctl; /* driver removing and reset sched */
+	/* Device capability bit */
+	unsigned long caps;
 
 	struct rw_semaphore qps_lock;
 	struct idr qp_idr;
@@ -326,8 +352,6 @@ struct hisi_qm {
 	bool use_sva;
 	bool is_frozen;
 
-	/* doorbell isolation enable */
-	bool use_db_isolation;
 	resource_size_t phys_base;
 	resource_size_t db_phys_base;
 	struct uacce_device *uacce;
@@ -501,6 +525,9 @@ void hisi_qm_pm_init(struct hisi_qm *qm);
 int hisi_qm_get_dfx_access(struct hisi_qm *qm);
 void hisi_qm_put_dfx_access(struct hisi_qm *qm);
 void hisi_qm_regs_dump(struct seq_file *s, struct debugfs_regset32 *regset);
+u32 hisi_qm_get_hw_info(struct hisi_qm *qm,
+			const struct hisi_qm_cap_info *info_table,
+			u32 index, bool is_read);
 
 /* Used by VFIO ACC live migration driver */
 struct pci_driver *hisi_sec_get_pf_driver(void);
-- 
2.35.1



