Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4D29707E
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 05:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbfHUDsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 23:48:01 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34667 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfHUDsA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 23:48:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id n9so517244pgc.1;
        Tue, 20 Aug 2019 20:48:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SrFWC17xwJEJa4p6/Sn5RGFtwj8GJ2HsGVtuMd6BeF0=;
        b=H6nCqaybrrOeV9XvO7rt6Q3es1Zko3lz2dO9Ruy9O7q2eDWqZEQ9y6fLuUzqca/i9g
         xjDTfyN4Sm4uhsz3UADSDm4eziMTV+WCv1gwp0+jSK6B5txqOO1UIsj3twmuWbqE+Y1S
         L9LvJevNIjvPyrgwySEtz32/NaFx6YNtzXa5s41IMngBawzItd8LwuMa9+QlnGHEG4p4
         NQoEcUZubz3+xrlbO71oIV37aO5yAXqHSpz6p9MvI+/2SzBdSn8foR0Frs34A0+bXxKH
         PRiMxxKVJOCTFuOppQdsTBaU6aGKpFh1JODVeEWIsa8tqLVkvkC3MmNZAjMOcD9SNnaW
         8yZg==
X-Gm-Message-State: APjAAAVjQqFAD9IL1MG0WBgwfNJF1Rze0Uer2b52wD3C1HRD5ZP8lwQm
        FhPt2v2RLYxegm9xmKQNriTf0xIJL8t5sg==
X-Google-Smtp-Source: APXvYqxnVHzSylWdbGFrfTRQIBfuFgjU/wa/Q5L6gf8yTQNp7Kq6vOaWdHQINUtasyA8c/pHoVwnAw==
X-Received: by 2002:a17:90a:33ed:: with SMTP id n100mr3307855pjb.19.1566359279798;
        Tue, 20 Aug 2019 20:47:59 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id j12sm20315167pff.4.2019.08.20.20.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 20:47:59 -0700 (PDT)
From:   Nadav Amit <namit@vmware.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     linux-kernel@vger.kernel.org,
        Francois Rigault <rigault.francois@gmail.com>,
        Nadav Amit <namit@vmware.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Adit Ranadive <aditr@vmware.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Vishnu DASA <vdasa@vmware.com>, stable@vger.kernel.org
Subject: [PATCH] VMCI: Release resource if the work is already queued
Date:   Tue, 20 Aug 2019 13:26:38 -0700
Message-Id: <20190820202638.49003-1-namit@vmware.com>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 drivers/misc/vmw_vmci/vmci_doorbell.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_doorbell.c b/drivers/misc/vmw_vmci/vmci_doorbell.c
index bad89b6e0802..345addd9306d 100644
--- a/drivers/misc/vmw_vmci/vmci_doorbell.c
+++ b/drivers/misc/vmw_vmci/vmci_doorbell.c
@@ -310,7 +310,8 @@ int vmci_dbell_host_context_notify(u32 src_cid, struct vmci_handle handle)
 
 	entry = container_of(resource, struct dbell_entry, resource);
 	if (entry->run_delayed) {
-		schedule_work(&entry->work);
+		if (!schedule_work(&entry->work))
+			vmci_resource_put(resource);
 	} else {
 		entry->notify_cb(entry->client_data);
 		vmci_resource_put(resource);
@@ -361,7 +362,8 @@ static void dbell_fire_entries(u32 notify_idx)
 		    atomic_read(&dbell->active) == 1) {
 			if (dbell->run_delayed) {
 				vmci_resource_get(&dbell->resource);
-				schedule_work(&dbell->work);
+				if (!schedule_work(&dbell->work))
+					vmci_resource_put(&dbell->resource);
 			} else {
 				dbell->notify_cb(dbell->client_data);
 			}
-- 
2.19.1

