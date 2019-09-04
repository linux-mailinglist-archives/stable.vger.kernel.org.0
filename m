Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0D68A8E7A
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732518AbfIDR6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:58:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:36572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387991AbfIDR6N (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:58:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D2B3A21883;
        Wed,  4 Sep 2019 17:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619892;
        bh=yOuuWbnzDzrVFrx19MYF+nHUQbpLTEStOdeaKYBpv9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C1Z6MGbEzJLi4nNRZd3N+m78Q7iDTcJ/RWkF68EFcAO9GDuNDcbjfLqgUyjrfy+dy
         4K8aDacfmX4uJxYP+PMhcgG0TkjVmMCpsOuQzXTZsTOahtcuaCdfDD2cbEw3SeEqmk
         JsH/DWBMvttOgPkLQ2wiUZASMDBMNO2aBAAjbYHE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Francois Rigault <rigault.francois@gmail.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Adit Ranadive <aditr@vmware.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Vishnu DASA <vdasa@vmware.com>, Nadav Amit <namit@vmware.com>
Subject: [PATCH 4.4 74/77] VMCI: Release resource if the work is already queued
Date:   Wed,  4 Sep 2019 19:54:01 +0200
Message-Id: <20190904175310.261225520@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

commit ba03a9bbd17b149c373c0ea44017f35fc2cd0f28 upstream.

Francois reported that VMware balloon gets stuck after a balloon reset,
when the VMCI doorbell is removed. A similar error can occur when the
balloon driver is removed with the following splat:

[ 1088.622000] INFO: task modprobe:3565 blocked for more than 120 seconds.
[ 1088.622035]       Tainted: G        W         5.2.0 #4
[ 1088.622087] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1088.622205] modprobe        D    0  3565   1450 0x00000000
[ 1088.622210] Call Trace:
[ 1088.622246]  __schedule+0x2a8/0x690
[ 1088.622248]  schedule+0x2d/0x90
[ 1088.622250]  schedule_timeout+0x1d3/0x2f0
[ 1088.622252]  wait_for_completion+0xba/0x140
[ 1088.622320]  ? wake_up_q+0x80/0x80
[ 1088.622370]  vmci_resource_remove+0xb9/0xc0 [vmw_vmci]
[ 1088.622373]  vmci_doorbell_destroy+0x9e/0xd0 [vmw_vmci]
[ 1088.622379]  vmballoon_vmci_cleanup+0x6e/0xf0 [vmw_balloon]
[ 1088.622381]  vmballoon_exit+0x18/0xcc8 [vmw_balloon]
[ 1088.622394]  __x64_sys_delete_module+0x146/0x280
[ 1088.622408]  do_syscall_64+0x5a/0x130
[ 1088.622410]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[ 1088.622415] RIP: 0033:0x7f54f62791b7
[ 1088.622421] Code: Bad RIP value.
[ 1088.622421] RSP: 002b:00007fff2a949008 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
[ 1088.622426] RAX: ffffffffffffffda RBX: 000055dff8b55d00 RCX: 00007f54f62791b7
[ 1088.622426] RDX: 0000000000000000 RSI: 0000000000000800 RDI: 000055dff8b55d68
[ 1088.622427] RBP: 000055dff8b55d00 R08: 00007fff2a947fb1 R09: 0000000000000000
[ 1088.622427] R10: 00007f54f62f5cc0 R11: 0000000000000206 R12: 000055dff8b55d68
[ 1088.622428] R13: 0000000000000001 R14: 000055dff8b55d68 R15: 00007fff2a94a3f0

The cause for the bug is that when the "delayed" doorbell is invoked, it
takes a reference on the doorbell entry and schedules work that is
supposed to run the appropriate code and drop the doorbell entry
reference. The code ignores the fact that if the work is already queued,
it will not be scheduled to run one more time. As a result one of the
references would not be dropped. When the code waits for the reference
to get to zero, during balloon reset or module removal, it gets stuck.

Fix it. Drop the reference if schedule_work() indicates that the work is
already queued.

Note that this bug got more apparent (or apparent at all) due to
commit ce664331b248 ("vmw_balloon: VMCI_DOORBELL_SET does not check status").

Fixes: 83e2ec765be03 ("VMCI: doorbell implementation.")
Reported-by: Francois Rigault <rigault.francois@gmail.com>
Cc: Jorgen Hansen <jhansen@vmware.com>
Cc: Adit Ranadive <aditr@vmware.com>
Cc: Alexios Zavras <alexios.zavras@intel.com>
Cc: Vishnu DASA <vdasa@vmware.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nadav Amit <namit@vmware.com>
Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
Link: https://lore.kernel.org/r/20190820202638.49003-1-namit@vmware.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/misc/vmw_vmci/vmci_doorbell.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/misc/vmw_vmci/vmci_doorbell.c
+++ b/drivers/misc/vmw_vmci/vmci_doorbell.c
@@ -318,7 +318,8 @@ int vmci_dbell_host_context_notify(u32 s
 
 	entry = container_of(resource, struct dbell_entry, resource);
 	if (entry->run_delayed) {
-		schedule_work(&entry->work);
+		if (!schedule_work(&entry->work))
+			vmci_resource_put(resource);
 	} else {
 		entry->notify_cb(entry->client_data);
 		vmci_resource_put(resource);
@@ -366,7 +367,8 @@ static void dbell_fire_entries(u32 notif
 		    atomic_read(&dbell->active) == 1) {
 			if (dbell->run_delayed) {
 				vmci_resource_get(&dbell->resource);
-				schedule_work(&dbell->work);
+				if (!schedule_work(&dbell->work))
+					vmci_resource_put(&dbell->resource);
 			} else {
 				dbell->notify_cb(dbell->client_data);
 			}


