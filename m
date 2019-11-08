Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E81CCF56A5
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391453AbfKHTKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:10:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391078AbfKHTKF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:10:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 384C920673;
        Fri,  8 Nov 2019 19:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240203;
        bh=/nY28j1nOrFMxjV93GGSo3Ontn0HA7+C5X1rIXcde9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ol2czC28vTyPkOrZ+BXcArfuufVxZ0j6H/p4vAb3aen6E5LvLEg9HGBiOeatCUbZA
         8mPjo45Vc5piXpHtuB7sHafL3JiUGqqqkYGJ6HsMJq1kcVFqj0JW+ys9NAJee+Ckik
         s+pmrrNqlmSHD33g7F+T2HAiIH4bSj7ILtlW+8zE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonglong Liu <liuyonglong@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 125/140] net: hns3: fix mis-counting IRQ vector numbers issue
Date:   Fri,  8 Nov 2019 19:50:53 +0100
Message-Id: <20191108174912.580652914@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonglong Liu <liuyonglong@huawei.com>

[ Upstream commit 580a05f9d4ada3bfb689140d0efec1efdb8a48da ]

Currently, the num_msi_left means the vector numbers of NIC,
but if the PF supported RoCE, it contains the vector numbers
of NIC and RoCE(Not expected).

This may cause interrupts lost in some case, because of the
NIC module used the vector resources which belongs to RoCE.

This patch adds a new variable num_nic_msi to store the vector
numbers of NIC, and adjust the default TQP numbers and rss_size
according to the value of num_nic_msi.

Fixes: 46a3df9f9718 ("net: hns3: Add HNS3 Acceleration Engine & Compatibility Layer Support")
Signed-off-by: Yonglong Liu <liuyonglong@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h               |    2 +
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   |   21 ++++++++++
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h   |    1 
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c     |   11 ++++-
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c |   28 ++++++++++++--
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h |    1 
 6 files changed, 58 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -32,6 +32,8 @@
 
 #define HNAE3_MOD_VERSION "1.0"
 
+#define HNAE3_MIN_VECTOR_NUM	2 /* first one for misc, another for IO */
+
 /* Device IDs */
 #define HNAE3_DEV_ID_GE				0xA220
 #define HNAE3_DEV_ID_25GE			0xA221
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -800,6 +800,9 @@ static int hclge_query_pf_resource(struc
 		hnae3_get_field(__le16_to_cpu(req->pf_intr_vector_number),
 				HCLGE_PF_VEC_NUM_M, HCLGE_PF_VEC_NUM_S);
 
+		/* nic's msix numbers is always equals to the roce's. */
+		hdev->num_nic_msi = hdev->num_roce_msi;
+
 		/* PF should have NIC vectors and Roce vectors,
 		 * NIC vectors are queued before Roce vectors.
 		 */
@@ -809,6 +812,15 @@ static int hclge_query_pf_resource(struc
 		hdev->num_msi =
 		hnae3_get_field(__le16_to_cpu(req->pf_intr_vector_number),
 				HCLGE_PF_VEC_NUM_M, HCLGE_PF_VEC_NUM_S);
+
+		hdev->num_nic_msi = hdev->num_msi;
+	}
+
+	if (hdev->num_nic_msi < HNAE3_MIN_VECTOR_NUM) {
+		dev_err(&hdev->pdev->dev,
+			"Just %u msi resources, not enough for pf(min:2).\n",
+			hdev->num_nic_msi);
+		return -EINVAL;
 	}
 
 	return 0;
@@ -1394,6 +1406,10 @@ static int  hclge_assign_tqp(struct hclg
 	kinfo->rss_size = min_t(u16, hdev->rss_size_max,
 				vport->alloc_tqps / hdev->tm_info.num_tc);
 
+	/* ensure one to one mapping between irq and queue at default */
+	kinfo->rss_size = min_t(u16, kinfo->rss_size,
+				(hdev->num_nic_msi - 1) / hdev->tm_info.num_tc);
+
 	return 0;
 }
 
@@ -2172,7 +2188,8 @@ static int hclge_init_msi(struct hclge_d
 	int vectors;
 	int i;
 
-	vectors = pci_alloc_irq_vectors(pdev, 1, hdev->num_msi,
+	vectors = pci_alloc_irq_vectors(pdev, HNAE3_MIN_VECTOR_NUM,
+					hdev->num_msi,
 					PCI_IRQ_MSI | PCI_IRQ_MSIX);
 	if (vectors < 0) {
 		dev_err(&pdev->dev,
@@ -2187,6 +2204,7 @@ static int hclge_init_msi(struct hclge_d
 
 	hdev->num_msi = vectors;
 	hdev->num_msi_left = vectors;
+
 	hdev->base_msi_vector = pdev->irq;
 	hdev->roce_base_vector = hdev->base_msi_vector +
 				hdev->roce_base_msix_offset;
@@ -3644,6 +3662,7 @@ static int hclge_get_vector(struct hnae3
 	int alloc = 0;
 	int i, j;
 
+	vector_num = min_t(u16, hdev->num_nic_msi - 1, vector_num);
 	vector_num = min(hdev->num_msi_left, vector_num);
 
 	for (j = 0; j < vector_num; j++) {
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -795,6 +795,7 @@ struct hclge_dev {
 	u32 base_msi_vector;
 	u16 *vector_status;
 	int *vector_irq;
+	u16 num_nic_msi;	/* Num of nic vectors for this PF */
 	u16 num_roce_msi;	/* Num of roce vectors for this PF */
 	int roce_base_vector;
 
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.c
@@ -540,9 +540,16 @@ static void hclge_tm_vport_tc_info_updat
 		kinfo->rss_size = kinfo->req_rss_size;
 	} else if (kinfo->rss_size > max_rss_size ||
 		   (!kinfo->req_rss_size && kinfo->rss_size < max_rss_size)) {
+		/* if user not set rss, the rss_size should compare with the
+		 * valid msi numbers to ensure one to one map between tqp and
+		 * irq as default.
+		 */
+		if (!kinfo->req_rss_size)
+			max_rss_size = min_t(u16, max_rss_size,
+					     (hdev->num_nic_msi - 1) /
+					     kinfo->num_tc);
+
 		/* Set to the maximum specification value (max_rss_size). */
-		dev_info(&hdev->pdev->dev, "rss changes from %d to %d\n",
-			 kinfo->rss_size, max_rss_size);
 		kinfo->rss_size = max_rss_size;
 	}
 
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -411,6 +411,13 @@ static int hclgevf_knic_setup(struct hcl
 		kinfo->tqp[i] = &hdev->htqp[i].q;
 	}
 
+	/* after init the max rss_size and tqps, adjust the default tqp numbers
+	 * and rss size with the actual vector numbers
+	 */
+	kinfo->num_tqps = min_t(u16, hdev->num_nic_msix - 1, kinfo->num_tqps);
+	kinfo->rss_size = min_t(u16, kinfo->num_tqps / kinfo->num_tc,
+				kinfo->rss_size);
+
 	return 0;
 }
 
@@ -502,6 +509,7 @@ static int hclgevf_get_vector(struct hna
 	int alloc = 0;
 	int i, j;
 
+	vector_num = min_t(u16, hdev->num_nic_msix - 1, vector_num);
 	vector_num = min(hdev->num_msi_left, vector_num);
 
 	for (j = 0; j < vector_num; j++) {
@@ -2208,13 +2216,14 @@ static int hclgevf_init_msi(struct hclge
 	int vectors;
 	int i;
 
-	if (hnae3_get_bit(hdev->ae_dev->flag, HNAE3_DEV_SUPPORT_ROCE_B))
+	if (hnae3_dev_roce_supported(hdev))
 		vectors = pci_alloc_irq_vectors(pdev,
 						hdev->roce_base_msix_offset + 1,
 						hdev->num_msi,
 						PCI_IRQ_MSIX);
 	else
-		vectors = pci_alloc_irq_vectors(pdev, 1, hdev->num_msi,
+		vectors = pci_alloc_irq_vectors(pdev, HNAE3_MIN_VECTOR_NUM,
+						hdev->num_msi,
 						PCI_IRQ_MSI | PCI_IRQ_MSIX);
 
 	if (vectors < 0) {
@@ -2230,6 +2239,7 @@ static int hclgevf_init_msi(struct hclge
 
 	hdev->num_msi = vectors;
 	hdev->num_msi_left = vectors;
+
 	hdev->base_msi_vector = pdev->irq;
 	hdev->roce_base_vector = pdev->irq + hdev->roce_base_msix_offset;
 
@@ -2495,7 +2505,7 @@ static int hclgevf_query_vf_resource(str
 
 	req = (struct hclgevf_query_res_cmd *)desc.data;
 
-	if (hnae3_get_bit(hdev->ae_dev->flag, HNAE3_DEV_SUPPORT_ROCE_B)) {
+	if (hnae3_dev_roce_supported(hdev)) {
 		hdev->roce_base_msix_offset =
 		hnae3_get_field(__le16_to_cpu(req->msixcap_localid_ba_rocee),
 				HCLGEVF_MSIX_OFT_ROCEE_M,
@@ -2504,6 +2514,9 @@ static int hclgevf_query_vf_resource(str
 		hnae3_get_field(__le16_to_cpu(req->vf_intr_vector_number),
 				HCLGEVF_VEC_NUM_M, HCLGEVF_VEC_NUM_S);
 
+		/* nic's msix numbers is always equals to the roce's. */
+		hdev->num_nic_msix = hdev->num_roce_msix;
+
 		/* VF should have NIC vectors and Roce vectors, NIC vectors
 		 * are queued before Roce vectors. The offset is fixed to 64.
 		 */
@@ -2513,6 +2526,15 @@ static int hclgevf_query_vf_resource(str
 		hdev->num_msi =
 		hnae3_get_field(__le16_to_cpu(req->vf_intr_vector_number),
 				HCLGEVF_VEC_NUM_M, HCLGEVF_VEC_NUM_S);
+
+		hdev->num_nic_msix = hdev->num_msi;
+	}
+
+	if (hdev->num_nic_msix < HNAE3_MIN_VECTOR_NUM) {
+		dev_err(&hdev->pdev->dev,
+			"Just %u msi resources, not enough for vf(min:2).\n",
+			hdev->num_nic_msix);
+		return -EINVAL;
 	}
 
 	return 0;
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.h
@@ -265,6 +265,7 @@ struct hclgevf_dev {
 	u16 num_msi;
 	u16 num_msi_left;
 	u16 num_msi_used;
+	u16 num_nic_msix;	/* Num of nic vectors for this VF */
 	u16 num_roce_msix;	/* Num of roce vectors for this VF */
 	u16 roce_base_msix_offset;
 	int roce_base_vector;


