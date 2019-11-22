Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 597A91070F6
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbfKVKfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:35:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:34058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728269AbfKVKfg (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:35:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8372520637;
        Fri, 22 Nov 2019 10:35:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418936;
        bh=DzMQUX6s9k8wSUp8WtR4VzDixx38NDOCValpnxIZC6Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ums6rh/3+Im1NoMVRVUemRVsCKRj+JaltljIlsSys0JU9xLp8ycEOE0U7Eg3c0x2S
         tctKK108Gt5nnXhmLrVmQsqcl7r+Ov+vhHrzkq+jrYfnXG4W9zvgCc0A6GJsRh4wAW
         jHPTJlpi7Si12hHf8Colw3cJEGkPTJfjnzmfIIC0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        John Johansen <john.johansen@canonical.com>,
        Seth Arnold <seth.arnold@canonical.com>
Subject: [PATCH 4.4 102/159] apparmor: fix uninitialized lsm_audit member
Date:   Fri, 22 Nov 2019 11:28:13 +0100
Message-Id: <20191122100821.546748569@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Johansen <john.johansen@canonical.com>

commit b6b1b81b3afba922505b57f4c812bba022f7c4a9 upstream.

BugLink: http://bugs.launchpad.net/bugs/1268727

The task field in the lsm_audit struct needs to be initialized if
a change_hat fails, otherwise the following oops will occur

BUG: unable to handle kernel paging request at 0000002fbead7d08
IP: [<ffffffff8171153e>] _raw_spin_lock+0xe/0x50
PGD 1e3f35067 PUD 0
Oops: 0002 [#1] SMP
Modules linked in: pppox crc_ccitt p8023 p8022 psnap llc ax25 btrfs raid6_pq xor xfs libcrc32c dm_multipath scsi_dh kvm_amd dcdbas kvm microcode amd64_edac_mod joydev edac_core psmouse edac_mce_amd serio_raw k10temp sp5100_tco i2c_piix4 ipmi_si ipmi_msghandler acpi_power_meter mac_hid lp parport hid_generic usbhid hid pata_acpi mpt2sas ahci raid_class pata_atiixp bnx2 libahci scsi_transport_sas [last unloaded: tipc]
CPU: 2 PID: 699 Comm: changehat_twice Tainted: GF          O 3.13.0-7-generic #25-Ubuntu
Hardware name: Dell Inc. PowerEdge R415/08WNM9, BIOS 1.8.6 12/06/2011
task: ffff8802135c6000 ti: ffff880212986000 task.ti: ffff880212986000
RIP: 0010:[<ffffffff8171153e>]  [<ffffffff8171153e>] _raw_spin_lock+0xe/0x50
RSP: 0018:ffff880212987b68  EFLAGS: 00010006
RAX: 0000000000020000 RBX: 0000002fbead7500 RCX: 0000000000000000
RDX: 0000000000000292 RSI: ffff880212987ba8 RDI: 0000002fbead7d08
RBP: ffff880212987b68 R08: 0000000000000246 R09: ffff880216e572a0
R10: ffffffff815fd677 R11: ffffea0008469580 R12: ffffffff8130966f
R13: ffff880212987ba8 R14: 0000002fbead7d08 R15: ffff8800d8c6b830
FS:  00002b5e6c84e7c0(0000) GS:ffff880216e40000(0000) knlGS:0000000055731700
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000002fbead7d08 CR3: 000000021270f000 CR4: 00000000000006e0
Stack:
 ffff880212987b98 ffffffff81075f17 ffffffff8130966f 0000000000000009
 0000000000000000 0000000000000000 ffff880212987bd0 ffffffff81075f7c
 0000000000000292 ffff880212987c08 ffff8800d8c6b800 0000000000000026
Call Trace:
 [<ffffffff81075f17>] __lock_task_sighand+0x47/0x80
 [<ffffffff8130966f>] ? apparmor_cred_prepare+0x2f/0x50
 [<ffffffff81075f7c>] do_send_sig_info+0x2c/0x80
 [<ffffffff81075fee>] send_sig_info+0x1e/0x30
 [<ffffffff8130242d>] aa_audit+0x13d/0x190
 [<ffffffff8130c1dc>] aa_audit_file+0xbc/0x130
 [<ffffffff8130966f>] ? apparmor_cred_prepare+0x2f/0x50
 [<ffffffff81304cc2>] aa_change_hat+0x202/0x530
 [<ffffffff81308fc6>] aa_setprocattr_changehat+0x116/0x1d0
 [<ffffffff8130a11d>] apparmor_setprocattr+0x25d/0x300
 [<ffffffff812cee56>] security_setprocattr+0x16/0x20
 [<ffffffff8121fc87>] proc_pid_attr_write+0x107/0x130
 [<ffffffff811b7604>] vfs_write+0xb4/0x1f0
 [<ffffffff811b8039>] SyS_write+0x49/0xa0
 [<ffffffff8171a1bf>] tracesys+0xe1/0xe6

Signed-off-by: John Johansen <john.johansen@canonical.com>
Acked-by: Seth Arnold <seth.arnold@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/apparmor/audit.c |    3 ++-
 security/apparmor/file.c  |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/security/apparmor/audit.c
+++ b/security/apparmor/audit.c
@@ -200,7 +200,8 @@ int aa_audit(int type, struct aa_profile
 
 	if (sa->aad->type == AUDIT_APPARMOR_KILL)
 		(void)send_sig_info(SIGKILL, NULL,
-				    sa->u.tsk ?  sa->u.tsk : current);
+			sa->type == LSM_AUDIT_DATA_TASK && sa->u.tsk ?
+				    sa->u.tsk : current);
 
 	if (sa->aad->type == AUDIT_APPARMOR_ALLOWED)
 		return complain_error(sa->aad->error);
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -110,7 +110,8 @@ int aa_audit_file(struct aa_profile *pro
 	int type = AUDIT_APPARMOR_AUTO;
 	struct common_audit_data sa;
 	struct apparmor_audit_data aad = {0,};
-	sa.type = LSM_AUDIT_DATA_NONE;
+	sa.type = LSM_AUDIT_DATA_TASK;
+	sa.u.tsk = NULL;
 	sa.aad = &aad;
 	aad.op = op,
 	aad.fs.request = request;


