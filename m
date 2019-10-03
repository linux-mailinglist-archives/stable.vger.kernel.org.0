Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8BF6CA42F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:23:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389699AbfJCQWv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:22:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:51656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390388AbfJCQWu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:22:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DDA7220659;
        Thu,  3 Oct 2019 16:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119769;
        bh=j4lh2ZM1tdLQVmtE9VZzdEw/a5n8LU5JpF5XFHMeu1Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oiZeZpnaMYwLfr7KKLsDARY2aiZZGz9EsZ2v2hiGwJ0drj6hYRm5aS2Jibjni+vW0
         1SrKKeezCEdMwDZBivu0iTS1J9heTYpGUDxeH2UI3QaBpnukAlabPWnIrVH7WCJrEr
         42l0jqff2V6WkjnWYp6nEccgfiY4obDCvNsn4WrY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Assmann <sassmann@kpanic.de>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH 4.19 185/211] i40e: check __I40E_VF_DISABLE bit in i40e_sync_filters_subtask
Date:   Thu,  3 Oct 2019 17:54:11 +0200
Message-Id: <20191003154527.872966831@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Assmann <sassmann@kpanic.de>

commit a7542b87607560d0b89e7ff81d870bd6ff8835cb upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/intel/i40e/i40e_main.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2566,6 +2566,10 @@ static void i40e_sync_filters_subtask(st
 		return;
 	if (!test_and_clear_bit(__I40E_MACVLAN_SYNC_PENDING, pf->state))
 		return;
+	if (test_and_set_bit(__I40E_VF_DISABLE, pf->state)) {
+		set_bit(__I40E_MACVLAN_SYNC_PENDING, pf->state);
+		return;
+	}
 
 	for (v = 0; v < pf->num_alloc_vsi; v++) {
 		if (pf->vsi[v] &&
@@ -2580,6 +2584,7 @@ static void i40e_sync_filters_subtask(st
 			}
 		}
 	}
+	clear_bit(__I40E_VF_DISABLE, pf->state);
 }
 
 /**


