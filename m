Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5EBF137D0B
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 10:54:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbgAKJxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:53:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728752AbgAKJxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:53:00 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 992DE2077C;
        Sat, 11 Jan 2020 09:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736379;
        bh=3uU3R90uC4A507UzUFMjyCffy1vzoVECycbLWSvf2ww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RSPQT90pJ5W4o7MfFAO95uH+W0CiVVTcDIrY7bdeTq7v+IvxFubaQz/av14BGkDCI
         +iIIUKZ+4tgOCxVxRcp2gHsRIvLqdXTw68HCGikxc0BWLTbunI3zHsrtRvBAdIIbT9
         PVo61gpjWMPHzDXUYB0hTJVXjq1taT+j2aPYcLsg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Dave Airlie <airlied@redhat.com>,
        Imre Deak <imre.deak@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 26/59] drm/mst: Fix MST sideband up-reply failure handling
Date:   Sat, 11 Jan 2020 10:49:35 +0100
Message-Id: <20200111094843.880640242@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
References: <20200111094835.417654274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit d8fd3722207f154b53c80eee2cf4977c3fc25a92 ]

Fix the breakage resulting in the stacktrace below, due to tx queue
being full when trying to send an up-reply. txmsg->seqno is -1 in this
case leading to a corruption of the mstb object by

	txmsg->dst->tx_slots[txmsg->seqno] = NULL;

in process_single_up_tx_qlock().

[  +0,005162] [drm:process_single_tx_qlock [drm_kms_helper]] set_hdr_from_dst_qlock: failed to find slot
[  +0,000015] [drm:drm_dp_send_up_ack_reply.constprop.19 [drm_kms_helper]] failed to send msg in q -11
[  +0,000939] BUG: kernel NULL pointer dereference, address: 00000000000005a0
[  +0,006982] #PF: supervisor write access in kernel mode
[  +0,005223] #PF: error_code(0x0002) - not-present page
[  +0,005135] PGD 0 P4D 0
[  +0,002581] Oops: 0002 [#1] PREEMPT SMP NOPTI
[  +0,004359] CPU: 1 PID: 1200 Comm: kworker/u16:3 Tainted: G     U            5.2.0-rc1+ #410
[  +0,008433] Hardware name: Intel Corporation Ice Lake Client Platform/IceLake U DDR4 SODIMM PD RVP, BIOS ICLSFWR1.R00.3175.A00.1904261428 04/26/2019
[  +0,013323] Workqueue: i915-dp i915_digport_work_func [i915]
[  +0,005676] RIP: 0010:queue_work_on+0x19/0x70
[  +0,004372] Code: ff ff ff 0f 1f 40 00 66 2e 0f 1f 84 00 00 00 00 00 41 56 49 89 f6 41 55 41 89 fd 41 54 55 53 48 89 d3 9c 5d fa e8 e7 81 0c 00 <f0> 48 0f ba 2b 00 73 31 45 31 e4 f7 c5 00 02 00 00 74 13 e8 cf 7f
[  +0,018750] RSP: 0018:ffffc900007dfc50 EFLAGS: 00010006
[  +0,005222] RAX: 0000000000000046 RBX: 00000000000005a0 RCX: 0000000000000001
[  +0,007133] RDX: 000000000001b608 RSI: 0000000000000000 RDI: ffffffff82121972
[  +0,007129] RBP: 0000000000000202 R08: 0000000000000000 R09: 0000000000000001
[  +0,007129] R10: 0000000000000000 R11: 0000000000000000 R12: ffff88847bfa5096
[  +0,007131] R13: 0000000000000010 R14: ffff88849c08f3f8 R15: 0000000000000000
[  +0,007128] FS:  0000000000000000(0000) GS:ffff88849dc80000(0000) knlGS:0000000000000000
[  +0,008083] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  +0,005749] CR2: 00000000000005a0 CR3: 0000000005210006 CR4: 0000000000760ee0
[  +0,007128] PKRU: 55555554
[  +0,002722] Call Trace:
[  +0,002458]  drm_dp_mst_handle_up_req+0x517/0x540 [drm_kms_helper]
[  +0,006197]  ? drm_dp_mst_hpd_irq+0x5b/0x9c0 [drm_kms_helper]
[  +0,005764]  drm_dp_mst_hpd_irq+0x5b/0x9c0 [drm_kms_helper]
[  +0,005623]  ? intel_dp_hpd_pulse+0x205/0x370 [i915]
[  +0,005018]  intel_dp_hpd_pulse+0x205/0x370 [i915]
[  +0,004836]  i915_digport_work_func+0xbb/0x140 [i915]
[  +0,005108]  process_one_work+0x245/0x610
[  +0,004027]  worker_thread+0x37/0x380
[  +0,003684]  ? process_one_work+0x610/0x610
[  +0,004184]  kthread+0x119/0x130
[  +0,003240]  ? kthread_park+0x80/0x80
[  +0,003668]  ret_from_fork+0x24/0x50

Cc: Lyude Paul <lyude@redhat.com>
Cc: Dave Airlie <airlied@redhat.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190523212433.9058-1-imre.deak@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index ff12d926eb65..cd707b401b10 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -1538,7 +1538,11 @@ static void process_single_up_tx_qlock(struct drm_dp_mst_topology_mgr *mgr,
 	if (ret != 1)
 		DRM_DEBUG_KMS("failed to send msg in q %d\n", ret);
 
-	txmsg->dst->tx_slots[txmsg->seqno] = NULL;
+	if (txmsg->seqno != -1) {
+		WARN_ON((unsigned int)txmsg->seqno >
+			ARRAY_SIZE(txmsg->dst->tx_slots));
+		txmsg->dst->tx_slots[txmsg->seqno] = NULL;
+	}
 }
 
 static void drm_dp_queue_down_tx(struct drm_dp_mst_topology_mgr *mgr,
-- 
2.20.1



