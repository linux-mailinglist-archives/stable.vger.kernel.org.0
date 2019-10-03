Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7218CC9DED
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 14:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbfJCMAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 08:00:46 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:55791 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725892AbfJCMAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Oct 2019 08:00:46 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E668421D25;
        Thu,  3 Oct 2019 08:00:45 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 03 Oct 2019 08:00:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=15wCOg
        Z6+Wn1fFG2nF3E8M39gWWvuaOUqEzH/C7XCWY=; b=ENenr/OPQBFZTLRkrTLUhW
        qR7CjW/eIuKyedRlwya+40UTUKAx+JxYKCFp5twO/HtWM+iW8ocIjy3Sikv0tUlD
        qDt4OIu6alJxEsXJPovjQkFW6cbjuOcGKeIQrFuOLTQY8FgyyFnOPmMlU3xQqlG1
        ycwE7A5c7U/fZG9wTqD7+36fIF5yJb/WDWZH1tqXDomDRwqEbvXctRD9NZUxrlzh
        nu59bpycBu1WffXHbjiIiqAjmjG9PfJ2R/quM0f3DfHfGPM3zd/Fbe9+/0hrlPld
        0YyZy3jIXy+cdcrDd/hDjospotgiwxW5t0wb/zITYmKTaTjXhRg7ZhaIS+1sHswA
        ==
X-ME-Sender: <xms:7eKVXat3kQpZ3LuMGHntG987h7jxXoHJK6F5QPsDBtF--FJ_2uOX3g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrgeekgdegkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedv
X-ME-Proxy: <xmx:7eKVXWwrPwLR65J_HbMug6Pukb5YYY6VKrH4zYAmFJOQK8VwUoKH4g>
    <xmx:7eKVXYb0Pa8scJStvdSc2dSCXixMEJq2so4m27k5_GqDGJbJFRRERg>
    <xmx:7eKVXfSlu04YeSnFGqeZy-iLcxUyJ7bWJrdn3NRj3ObtuGvC8V4ScA>
    <xmx:7eKVXcJlpZWNo5Dex0SJLomkG7jS-sL9tFwgjNXqyUv_2smUSVW8Xg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5CEF580061;
        Thu,  3 Oct 2019 08:00:45 -0400 (EDT)
Subject: FAILED: patch "[PATCH] i40e: check __I40E_VF_DISABLE bit in" failed to apply to 4.14-stable tree
To:     sassmann@kpanic.de, andrewx.bowers@intel.com,
        jeffrey.t.kirsher@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 03 Oct 2019 14:00:29 +0200
Message-ID: <15701040298252@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

