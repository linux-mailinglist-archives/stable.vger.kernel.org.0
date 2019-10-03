Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02EE8C9DEC
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 14:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726523AbfJCMAf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 08:00:35 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45663 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbfJCMAf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 08:00:35 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 5F64421D2B;
        Thu,  3 Oct 2019 08:00:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 08:00:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=SQ1Pb2
        sMLH66brwagKXJs5X2mcboVsX7g2m/kOj+uIQ=; b=OGTzap3aKLfiVo66SV6fIt
        7N0FNcyqhpki4iTQVlAKPeR7njCvb22b2c4sNrXG4Le2ThOPIJRLHXrB8hNpoF1w
        oc7lMp6wKJBIn14EQ9Ajx5FnlAW5HPkGUm2uRCv0KfbJ7CDwDf0/496pZYlksicA
        ZzOaCbxNpl7YOa3zZTVFWNEt1NQzybbA7UgYbqNn6zdVmbkJWUkxqcrpR4rW8iag
        6OvmFV1LoKALn3D/Ny6q8jaUN3zkMc/tcfI+gH2zknXqWr+2l0fRI06lxaRa028S
        TzVlMMsskYx54dO0jqDfvYvgQ9xEwTWczsK1ud705mJr3H5NreU+MtAGpjtMk3Gw
        ==
X-ME-Sender: <xms:4uKVXQ9IOyIYsm3fC2Z4fv1r7fJHZb0a3ZkSTgo3FSqQljmcJYxQxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:4uKVXdrdW1M5Zxz8R6vTzApOzedqhmFOetPvcm6v7H4MmOtKU43cTw>
    <xmx:4uKVXaSB5xk18u-MQ_LXkD2Tw-K_ZFpx5cqxmVH8QdPTDH56Ng8Fiw>
    <xmx:4uKVXQNB3dJIpSJqKkZa-Y7RD-TdAd9Eh3KRlaF5_Sawaw5tVZRYeQ>
    <xmx:4uKVXcmcv1v372wLPZ_q4n7runazDxTXRmPoS3YFDcat4ydlXoJ65A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DE3AA80062;
        Thu,  3 Oct 2019 08:00:33 -0400 (EDT)
Subject: FAILED: patch "[PATCH] i40e: check __I40E_VF_DISABLE bit in" failed to apply to 4.9-stable tree
To:     sassmann@kpanic.de, andrewx.bowers@intel.com,
        jeffrey.t.kirsher@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 14:00:16 +0200
Message-ID: <1570104016169113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
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

