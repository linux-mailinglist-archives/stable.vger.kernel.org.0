Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6119103F3A
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732123AbfKTPlt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:41:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52990 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731831AbfKTPkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:20 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5V-0004ak-Bv; Wed, 20 Nov 2019 15:40:13 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5U-0004KY-Nw; Wed, 20 Nov 2019 15:40:12 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Nadav Amit" <namit@vmware.com>,
        "Francois Rigault" <rigault.francois@gmail.com>,
        "Vishnu DASA" <vdasa@vmware.com>,
        "Alexios Zavras" <alexios.zavras@intel.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Adit Ranadive" <aditr@vmware.com>,
        "Jorgen Hansen" <jhansen@vmware.com>
Date:   Wed, 20 Nov 2019 15:38:08 +0000
Message-ID: <lsq.1574264230.91206156@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 58/83] VMCI: Release resource if the work is already
 queued
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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
Signed-off-by: Nadav Amit <namit@vmware.com>
Reviewed-by: Vishnu Dasa <vdasa@vmware.com>
Link: https://lore.kernel.org/r/20190820202638.49003-1-namit@vmware.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/misc/vmw_vmci/vmci_doorbell.c | 6 ++++--
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

