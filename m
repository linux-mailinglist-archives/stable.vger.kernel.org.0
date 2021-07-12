Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0B83C4A18
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238296AbhGLGsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:48:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:41504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234434AbhGLGrh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:47:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A381E60FD8;
        Mon, 12 Jul 2021 06:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072201;
        bh=Zo2SC+5Tg+B8mdzN8PtzRgas9TX29Y8shY2nFICaqfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yOpi0iSCJE2G2i64DaFWNz/il5qq7/ki6MQ3Ey7KSYr8585KBwBWMvSuRaRL1JCpX
         Zj5dKSZGpKhhsoD1t2j9LmTnvGRlc2TlxEAdQd3yVzSfe8KBo1CrAW3+z4DuYsX6i9
         dtHbRnJEdQAXNTf165YDDs0GtDgnvL8efLSyAymI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Sokolowski <jan.sokolowski@intel.com>,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 398/593] i40e: Fix missing rtnl locking when setting up pf switch
Date:   Mon, 12 Jul 2021 08:09:18 +0200
Message-Id: <20210712060931.309956982@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski@intel.com>

[ Upstream commit 956e759d5f8e0859e86b951a8779c60af633aafd ]

A recent change that made i40e use new udp_tunnel infrastructure
uses a method that expects to be called under rtnl lock.

However, not all codepaths do the lock prior to calling
i40e_setup_pf_switch.

Fix that by adding additional rtnl locking and unlocking.

Fixes: 40a98cb6f01f ("i40e: convert to new udp_tunnel infrastructure")
Signed-off-by: Jan Sokolowski <jan.sokolowski@intel.com>
Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index f2ba8ad9b6aa..52e31f712a54 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -31,7 +31,7 @@ static void i40e_vsi_reinit_locked(struct i40e_vsi *vsi);
 static void i40e_handle_reset_warning(struct i40e_pf *pf, bool lock_acquired);
 static int i40e_add_vsi(struct i40e_vsi *vsi);
 static int i40e_add_veb(struct i40e_veb *veb, struct i40e_vsi *vsi);
-static int i40e_setup_pf_switch(struct i40e_pf *pf, bool reinit);
+static int i40e_setup_pf_switch(struct i40e_pf *pf, bool reinit, bool lock_acquired);
 static int i40e_setup_misc_vector(struct i40e_pf *pf);
 static void i40e_determine_queue_usage(struct i40e_pf *pf);
 static int i40e_setup_pf_filter_control(struct i40e_pf *pf);
@@ -10114,7 +10114,7 @@ static void i40e_rebuild(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 	/* do basic switch setup */
 	if (!lock_acquired)
 		rtnl_lock();
-	ret = i40e_setup_pf_switch(pf, reinit);
+	ret = i40e_setup_pf_switch(pf, reinit, true);
 	if (ret)
 		goto end_unlock;
 
@@ -14169,10 +14169,11 @@ int i40e_fetch_switch_configuration(struct i40e_pf *pf, bool printconfig)
  * i40e_setup_pf_switch - Setup the HW switch on startup or after reset
  * @pf: board private structure
  * @reinit: if the Main VSI needs to re-initialized.
+ * @lock_acquired: indicates whether or not the lock has been acquired
  *
  * Returns 0 on success, negative value on failure
  **/
-static int i40e_setup_pf_switch(struct i40e_pf *pf, bool reinit)
+static int i40e_setup_pf_switch(struct i40e_pf *pf, bool reinit, bool lock_acquired)
 {
 	u16 flags = 0;
 	int ret;
@@ -14274,9 +14275,15 @@ static int i40e_setup_pf_switch(struct i40e_pf *pf, bool reinit)
 
 	i40e_ptp_init(pf);
 
+	if (!lock_acquired)
+		rtnl_lock();
+
 	/* repopulate tunnel port filters */
 	udp_tunnel_nic_reset_ntf(pf->vsi[pf->lan_vsi]->netdev);
 
+	if (!lock_acquired)
+		rtnl_unlock();
+
 	return ret;
 }
 
@@ -15048,7 +15055,7 @@ static int i40e_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			pf->flags |= I40E_FLAG_VEB_MODE_ENABLED;
 	}
 #endif
-	err = i40e_setup_pf_switch(pf, false);
+	err = i40e_setup_pf_switch(pf, false, false);
 	if (err) {
 		dev_info(&pdev->dev, "setup_pf_switch failed: %d\n", err);
 		goto err_vsis;
-- 
2.30.2



