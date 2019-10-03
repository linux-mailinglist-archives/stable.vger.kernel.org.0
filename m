Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86CE4C9DEB
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 14:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726364AbfJCMAe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 08:00:34 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:48023 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbfJCMAe (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 08:00:34 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E99B921C29;
        Thu,  3 Oct 2019 08:00:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 08:00:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=o50GAM
        3IWLWM9LHvUqGsZK4D5cdX5V6TeliV/cAOekA=; b=Hm41pfVDbVPUo7xuaeyQX9
        4JmozMX+fO7ZAOB5HxLo9n4UqpYUiNVC6LFBBZEt2bF/nMq0sZu8BRjOBrAc92U0
        jJJLi38WYJqIoFb5BcGV0LdHztzNa4Ya3v6b1jQG0940NffLGvjLH0E83QX8ux3O
        X5X8r9w3nDt0DRGQDHtKz0z69y+2JTYA6Xb5c1FJdrboHyuV+4xK163xGb1aUent
        oKbXbhov9Ukp1SRvo7I7m2RI9JiaeHPZC+44Vki6qryA5QeqHoospPvr/4Yygcte
        zQ8wP25j1O+JKVzMhAOFBoQVqTpw1wRO9E56Fkk3KlCwL1rED7bONMezMsauEHRw
        ==
X-ME-Sender: <xms:4OKVXVcK6rvzDycKGnes6e6N8B_0pva3G8SNwxvl7jIBEnHcpSEU0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:4OKVXbGr-ZTxKCKCgDMzxOTX0ZRc8FvjOxbxgLZ1eThFTl12BamHjg>
    <xmx:4OKVXdWK0FBMl5c7wPCb25Un-MINP99cGVKbFSDUiZZbnE7UkxO81w>
    <xmx:4OKVXVDIuLQdjPD8vhjksK-JLD8-Nv3Bs_pEfePWO6tmxt23dISMFA>
    <xmx:4OKVXflzBxKmFM4FDBXExSCZfpZT-_Sj8eFNjaY5CocDLNTf7PAG9Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2F5A18005A;
        Thu,  3 Oct 2019 08:00:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] i40e: check __I40E_VF_DISABLE bit in" failed to apply to 4.4-stable tree
To:     sassmann@kpanic.de, andrewx.bowers@intel.com,
        jeffrey.t.kirsher@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 13:59:34 +0200
Message-ID: <1570103974104219@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From a7542b87607560d0b89e7ff81d870bd6ff8835cb Mon Sep 17 00:00:00 2001
From: Stefan Assmann <sassmann@kpanic.de>
Date: Wed, 21 Aug 2019 16:09:29 +0200
Subject: [PATCH] i40e: check __I40E_VF_DISABLE bit in
 i40e_sync_filters_subtask

While testing VF spawn/destroy the following panic occurred.

BUG: unable to handle kernel NULL pointer dereference at 0000000000000029
[...]
Workqueue: i40e i40e_service_task [i40e]
RIP: 0010:i40e_sync_vsi_filters+0x6fd/0xc60 [i40e]
[...]
Call Trace:
 ? __switch_to_asm+0x35/0x70
 ? __switch_to_asm+0x41/0x70
 ? __switch_to_asm+0x35/0x70
 ? _cond_resched+0x15/0x30
 i40e_sync_filters_subtask+0x56/0x70 [i40e]
 i40e_service_task+0x382/0x11b0 [i40e]
 ? __switch_to_asm+0x41/0x70
 ? __switch_to_asm+0x41/0x70
 process_one_work+0x1a7/0x3b0
 worker_thread+0x30/0x390
 ? create_worker+0x1a0/0x1a0
 kthread+0x112/0x130
 ? kthread_bind+0x30/0x30
 ret_from_fork+0x35/0x40

Investigation revealed a race where pf->vf[vsi->vf_id].trusted may get
accessed by the watchdog via i40e_sync_filters_subtask() although
i40e_free_vfs() already free'd pf->vf.
To avoid this the call to i40e_sync_vsi_filters() in
i40e_sync_filters_subtask() needs to be guarded by __I40E_VF_DISABLE,
which is also used by i40e_free_vfs().

Note: put the __I40E_VF_DISABLE check after the
__I40E_MACVLAN_SYNC_PENDING check as the latter is more likely to
trigger.

CC: stable@vger.kernel.org
Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index e9f2f276bf27..3e2e465f43f9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2592,6 +2592,10 @@ static void i40e_sync_filters_subtask(struct i40e_pf *pf)
 		return;
 	if (!test_and_clear_bit(__I40E_MACVLAN_SYNC_PENDING, pf->state))
 		return;
+	if (test_and_set_bit(__I40E_VF_DISABLE, pf->state)) {
+		set_bit(__I40E_MACVLAN_SYNC_PENDING, pf->state);
+		return;
+	}
 
 	for (v = 0; v < pf->num_alloc_vsi; v++) {
 		if (pf->vsi[v] &&
@@ -2606,6 +2610,7 @@ static void i40e_sync_filters_subtask(struct i40e_pf *pf)
 			}
 		}
 	}
+	clear_bit(__I40E_VF_DISABLE, pf->state);
 }
 
 /**

