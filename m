Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357C347FF4D
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238190AbhL0Pgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:36:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238410AbhL0Pem (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:34:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34C36C06175B;
        Mon, 27 Dec 2021 07:34:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C8D2C6104C;
        Mon, 27 Dec 2021 15:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22C0C36AE7;
        Mon, 27 Dec 2021 15:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619281;
        bh=Q800pA2ijMpWrEzTsGFf1zltMLsWTysoy+gaAGZ/moI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wWj2bjANrRNqcqUgeTGBEwnhVQkimP7LZLJVacXEmSCNt1IB0NdtVZH0E5iFT/Ona
         +1S8cmsofYiwArvSjPzveK4GcIQwu57dbRYeg/hkaPr+MzZ48uCDF/SU5gt4eH77Dm
         TH80KBOWoWbOaiSZyzUaPVCoGJO07jLnE9K4yVyI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/47] qlcnic: potential dereference null pointer of rx_queue->page_ring
Date:   Mon, 27 Dec 2021 16:30:44 +0100
Message-Id: <20211227151321.068728382@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151320.801714429@linuxfoundation.org>
References: <20211227151320.801714429@linuxfoundation.org>
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
index 5f327659efa7a..85b688f60b876 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov.h
@@ -202,7 +202,7 @@ int qlcnic_sriov_get_vf_vport_info(struct qlcnic_adapter *,
 				   struct qlcnic_info *, u16);
 int qlcnic_sriov_cfg_vf_guest_vlan(struct qlcnic_adapter *, u16, u8);
 void qlcnic_sriov_free_vlans(struct qlcnic_adapter *);
-void qlcnic_sriov_alloc_vlans(struct qlcnic_adapter *);
+int qlcnic_sriov_alloc_vlans(struct qlcnic_adapter *);
 bool qlcnic_sriov_check_any_vlan(struct qlcnic_vf_info *);
 void qlcnic_sriov_del_vlan_id(struct qlcnic_sriov *,
 			      struct qlcnic_vf_info *, u16);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
index f7c2f32237cb0..400bc2c3f222e 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_sriov_common.c
@@ -433,7 +433,7 @@ static int qlcnic_sriov_set_guest_vlan_mode(struct qlcnic_adapter *adapter,
 					    struct qlcnic_cmd_args *cmd)
 {
 	struct qlcnic_sriov *sriov = adapter->ahw->sriov;
-	int i, num_vlans;
+	int i, num_vlans, ret;
 	u16 *vlans;
 
 	if (sriov->allowed_vlans)
@@ -444,7 +444,9 @@ static int qlcnic_sriov_set_guest_vlan_mode(struct qlcnic_adapter *adapter,
 	dev_info(&adapter->pdev->dev, "Number of allowed Guest VLANs = %d\n",
 		 sriov->num_allowed_vlans);
 
-	qlcnic_sriov_alloc_vlans(adapter);
+	ret = qlcnic_sriov_alloc_vlans(adapter);
+	if (ret)
+		return ret;
 
 	if (!sriov->any_vlan)
 		return 0;
@@ -2160,7 +2162,7 @@ static int qlcnic_sriov_vf_resume(struct qlcnic_adapter *adapter)
 	return err;
 }
 
-void qlcnic_sriov_alloc_vlans(struct qlcnic_adapter *adapter)
+int qlcnic_sriov_alloc_vlans(struct qlcnic_adapter *adapter)
 {
 	struct qlcnic_sriov *sriov = adapter->ahw->sriov;
 	struct qlcnic_vf_info *vf;
@@ -2170,7 +2172,11 @@ void qlcnic_sriov_alloc_vlans(struct qlcnic_adapter *adapter)
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
index 5632da05145a5..ed218ed2f466d 100644
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



