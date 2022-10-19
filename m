Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0B1E603BFC
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbiJSImF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:42:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiJSIkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:40:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4372C7E31C;
        Wed, 19 Oct 2022 01:39:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F125B822DA;
        Wed, 19 Oct 2022 08:39:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0297C4314E;
        Wed, 19 Oct 2022 08:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168753;
        bh=4YV9U22rMuVZHOD9Ed04txET9EO0qOS400nx64n0NYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qAZjiehoG78j4p5Z0inWfLCxUAo4Dss70QcLrpA1trCgjgWWKaFLCk1aZneSgIOpK
         p8qs7VFnTYSxVGKSbp3lhVfFPcVbDXJpIn/N/i+lTNq3XoTXX5S1tGLX39RIxIWoQx
         r0DQ2PgxdcUHqSeJzxATTM+bd/S+gCoJeTDePrSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Aring <aahringo@redhat.com>,
        David Teigland <teigland@redhat.com>
Subject: [PATCH 6.0 043/862] fs: dlm: fix invalid derefence of sb_lvbptr
Date:   Wed, 19 Oct 2022 10:22:10 +0200
Message-Id: <20221019083251.896817897@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Aring <aahringo@redhat.com>

commit 7175e131ebba47afef47e6ac4d5bab474d1e6e49 upstream.

I experience issues when putting a lkbsb on the stack and have sb_lvbptr
field to a dangled pointer while not using DLM_LKF_VALBLK. It will crash
with the following kernel message, the dangled pointer is here
0xdeadbeef as example:

[  102.749317] BUG: unable to handle page fault for address: 00000000deadbeef
[  102.749320] #PF: supervisor read access in kernel mode
[  102.749323] #PF: error_code(0x0000) - not-present page
[  102.749325] PGD 0 P4D 0
[  102.749332] Oops: 0000 [#1] PREEMPT SMP PTI
[  102.749336] CPU: 0 PID: 1567 Comm: lock_torture_wr Tainted: G        W         5.19.0-rc3+ #1565
[  102.749343] Hardware name: Red Hat KVM/RHEL-AV, BIOS 1.16.0-2.module+el8.7.0+15506+033991b0 04/01/2014
[  102.749344] RIP: 0010:memcpy_erms+0x6/0x10
[  102.749353] Code: cc cc cc cc eb 1e 0f 1f 00 48 89 f8 48 89 d1 48 c1 e9 03 83 e2 07 f3 48 a5 89 d1 f3 a4 c3 66 0f 1f 44 00 00 48 89 f8 48 89 d1 <f3> a4 c3 0f 1f 80 00 00 00 00 48 89 f8 48 83 fa 20 72 7e 40 38 fe
[  102.749355] RSP: 0018:ffff97a58145fd08 EFLAGS: 00010202
[  102.749358] RAX: ffff901778b77070 RBX: 0000000000000000 RCX: 0000000000000040
[  102.749360] RDX: 0000000000000040 RSI: 00000000deadbeef RDI: ffff901778b77070
[  102.749362] RBP: ffff97a58145fd10 R08: ffff901760b67a70 R09: 0000000000000001
[  102.749364] R10: ffff9017008e2cb8 R11: 0000000000000001 R12: ffff901760b67a70
[  102.749366] R13: ffff901760b78f00 R14: 0000000000000003 R15: 0000000000000001
[  102.749368] FS:  0000000000000000(0000) GS:ffff901876e00000(0000) knlGS:0000000000000000
[  102.749372] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  102.749374] CR2: 00000000deadbeef CR3: 000000017c49a004 CR4: 0000000000770ef0
[  102.749376] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  102.749378] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  102.749379] PKRU: 55555554
[  102.749381] Call Trace:
[  102.749382]  <TASK>
[  102.749383]  ? send_args+0xb2/0xd0
[  102.749389]  send_common+0xb7/0xd0
[  102.749395]  _unlock_lock+0x2c/0x90
[  102.749400]  unlock_lock.isra.56+0x62/0xa0
[  102.749405]  dlm_unlock+0x21e/0x330
[  102.749411]  ? lock_torture_stats+0x80/0x80 [dlm_locktorture]
[  102.749416]  torture_unlock+0x5a/0x90 [dlm_locktorture]
[  102.749419]  ? preempt_count_sub+0xba/0x100
[  102.749427]  lock_torture_writer+0xbd/0x150 [dlm_locktorture]
[  102.786186]  kthread+0x10a/0x130
[  102.786581]  ? kthread_complete_and_exit+0x20/0x20
[  102.787156]  ret_from_fork+0x22/0x30
[  102.787588]  </TASK>
[  102.787855] Modules linked in: dlm_locktorture torture rpcsec_gss_krb5 intel_rapl_msr intel_rapl_common kvm_intel iTCO_wdt iTCO_vendor_support kvm vmw_vsock_virtio_transport qxl irqbypass vmw_vsock_virtio_transport_common drm_ttm_helper crc32_pclmul joydev crc32c_intel ttm vsock virtio_scsi virtio_balloon snd_pcm drm_kms_helper virtio_console snd_timer snd drm soundcore syscopyarea i2c_i801 sysfillrect sysimgblt i2c_smbus pcspkr fb_sys_fops lpc_ich serio_raw
[  102.792536] CR2: 00000000deadbeef
[  102.792930] ---[ end trace 0000000000000000 ]---

This patch fixes the issue by checking also on DLM_LKF_VALBLK on exflags
is set when copying the lvbptr array instead of if it's just null which
fixes for me the issue.

I think this patch can fix other dlm users as well, depending how they
handle the init, freeing memory handling of sb_lvbptr and don't set
DLM_LKF_VALBLK for some dlm_lock() calls. It might a there could be a
hidden issue all the time. However with checking on DLM_LKF_VALBLK the
user always need to provide a sb_lvbptr non-null value. There might be
more intelligent handling between per ls lvblen, DLM_LKF_VALBLK and
non-null to report the user the way how DLM API is used is wrong but can
be added for later, this will only fix the current behaviour.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lock.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/dlm/lock.c
+++ b/fs/dlm/lock.c
@@ -3623,7 +3623,7 @@ static void send_args(struct dlm_rsb *r,
 	case cpu_to_le32(DLM_MSG_REQUEST_REPLY):
 	case cpu_to_le32(DLM_MSG_CONVERT_REPLY):
 	case cpu_to_le32(DLM_MSG_GRANT):
-		if (!lkb->lkb_lvbptr)
+		if (!lkb->lkb_lvbptr || !(lkb->lkb_exflags & DLM_LKF_VALBLK))
 			break;
 		memcpy(ms->m_extra, lkb->lkb_lvbptr, r->res_ls->ls_lvblen);
 		break;


