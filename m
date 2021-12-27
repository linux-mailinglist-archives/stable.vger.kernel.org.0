Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2A947FE50
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237463AbhL0P2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:28:06 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33430 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237466AbhL0P15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:27:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DDA6B810B9;
        Mon, 27 Dec 2021 15:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60F21C36AEA;
        Mon, 27 Dec 2021 15:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640618875;
        bh=NyeSG5tkne6j0YV86AG73j25lKYHz9GCKymuBln7Plg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPfylEtUk3xBbEAkIV4JIMcvLMinTK6JrAwxvkK1GpmL3JX1cuQoWmY1kuiSo/rnF
         UJtJNp0c9nMlLGeNbg3Te2rUrRi34/3UBK0BP88VnB3sm1CCNheiD+QvxLcshev96o
         mTsx7VEEU33kUhuGnMUBbZscvVW+U4LlS7TDtr9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 05/17] qlcnic: potential dereference null pointer of rx_queue->page_ring
Date:   Mon, 27 Dec 2021 16:27:00 +0100
Message-Id: <20211227151316.137168583@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151315.962187770@linuxfoundation.org>
References: <20211227151315.962187770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 60ec7fcfe76892a1479afab51ff17a4281923156 ]

The return value of kcalloc() needs to be checked.
To avoid dereference of null pointer in case of the failure of alloc.
Therefore, it might be better to change the return type of
qlcnic_sriov_alloc_vlans() and return -ENOMEM when alloc fails and
return 0 the others.
Also, qlcnic_sriov_set_guest_vlan_mode() and __qlcnic_pci_sriov_enable()
should deal with the return value of qlcnic_sriov_alloc_vlans().

Fixes: 154d0c810c53 ("qlcnic: VLAN enhancement for 84XX adapters")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h    |  2 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c | 12 +++++++++---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c |  4 +++-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h
index 017d8c2c8285a..aab2db76d9edc 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h
@@ -201,7 +201,7 @@ int qlcnic_sriov_get_vf_vport_info(struct qlcnic_adapter *,
 				   struct qlcnic_info *, u16);
 int qlcnic_sriov_cfg_vf_guest_vlan(struct qlcnic_adapter *, u16, u8);
 void qlcnic_sriov_free_vlans(struct qlcnic_adapter *);
-void qlcnic_sriov_alloc_vlans(struct qlcnic_adapter *);
+int qlcnic_sriov_alloc_vlans(struct qlcnic_adapter *);
 bool qlcnic_sriov_check_any_vlan(struct qlcnic_vf_info *);
 void qlcnic_sriov_del_vlan_id(struct qlcnic_sriov *,
 			      struct qlcnic_vf_info *, u16);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
index ffa6885acfc8f..03e24fcf87a8e 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
@@ -427,7 +427,7 @@ static int qlcnic_sriov_set_guest_vlan_mode(struct qlcnic_adapter *adapter,
 					    struct qlcnic_cmd_args *cmd)
 {
 	struct qlcnic_sriov *sriov = adapter->ahw->sriov;
-	int i, num_vlans;
+	int i, num_vlans, ret;
 	u16 *vlans;
 
 	if (sriov->allowed_vlans)
@@ -438,7 +438,9 @@ static int qlcnic_sriov_set_guest_vlan_mode(struct qlcnic_adapter *adapter,
 	dev_info(&adapter->pdev->dev, "Number of allowed Guest VLANs = %d\n",
 		 sriov->num_allowed_vlans);
 
-	qlcnic_sriov_alloc_vlans(adapter);
+	ret = qlcnic_sriov_alloc_vlans(adapter);
+	if (ret)
+		return ret;
 
 	if (!sriov->any_vlan)
 		return 0;
@@ -2147,7 +2149,7 @@ static int qlcnic_sriov_vf_resume(struct qlcnic_adapter *adapter)
 	return err;
 }
 
-void qlcnic_sriov_alloc_vlans(struct qlcnic_adapter *adapter)
+int qlcnic_sriov_alloc_vlans(struct qlcnic_adapter *adapter)
 {
 	struct qlcnic_sriov *sriov = adapter->ahw->sriov;
 	struct qlcnic_vf_info *vf;
@@ -2157,7 +2159,11 @@ void qlcnic_sriov_alloc_vlans(struct qlcnic_adapter *adapter)
 		vf = &sriov->vf_info[i];
 		vf->sriov_vlans = kcalloc(sriov->num_allowed_vlans,
 					  sizeof(*vf->sriov_vlans), GFP_KERNEL);
+		if (!vf->sriov_vlans)
+			return -ENOMEM;
 	}
+
+	return 0;
 }
 
 void qlcnic_sriov_free_vlans(struct qlcnic_adapter *adapter)
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c
index afd687e5e7790..238a0e58342fa 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_pf.c
@@ -598,7 +598,9 @@ static int __qlcnic_pci_sriov_enable(struct qlcnic_adapter *adapter,
 	if (err)
 		goto del_flr_queue;
 
-	qlcnic_sriov_alloc_vlans(adapter);
+	err = qlcnic_sriov_alloc_vlans(adapter);
+	if (err)
+		goto del_flr_queue;
 
 	return err;
 
-- 
2.34.1



