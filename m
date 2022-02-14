Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D62904B4A81
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347270AbiBNK1l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:27:41 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347374AbiBNKZx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:25:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A7A6EF19;
        Mon, 14 Feb 2022 01:57:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BC4C6126B;
        Mon, 14 Feb 2022 09:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDE9C340E9;
        Mon, 14 Feb 2022 09:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832631;
        bh=x4XQYM5nJO+yQAGR11Fx9n3eVpNCCNywTwTDhK1as+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XzY9hTni94YoUJjCHktKrF2l68lMmJb/F/Ev4Nm62KJAO9T2iTRizBpTimqkRaAha
         CgENx3pv5150IuomAZ/u3tGpiKGAqQiPirgPfF4n5H+YZ5g0VcJMhTCwPr0md4VIAR
         96z+bnOenHGZZnWceX7IcGsPqDS+G+Dxk385PsJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Saurav Kashyap <skashyap@marvell.com>,
        Nilesh Javali <njavali@marvell.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 045/203] scsi: qedf: Add stag_work to all the vports
Date:   Mon, 14 Feb 2022 10:24:49 +0100
Message-Id: <20220214092511.746786799@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saurav Kashyap <skashyap@marvell.com>

[ Upstream commit b70a99fd13282d7885f69bf1372e28b7506a1613 ]

Call trace seen when creating NPIV ports, only 32 out of 64 show online.
stag work was not initialized for vport, hence initialize the stag work.

WARNING: CPU: 8 PID: 645 at kernel/workqueue.c:1635 __queue_delayed_work+0x68/0x80
CPU: 8 PID: 645 Comm: kworker/8:1 Kdump: loaded Tainted: G IOE    --------- --
 4.18.0-348.el8.x86_64 #1
Hardware name: Dell Inc. PowerEdge MX740c/0177V9, BIOS 2.12.2 07/09/2021
Workqueue: events fc_lport_timeout [libfc]
RIP: 0010:__queue_delayed_work+0x68/0x80
Code: 89 b2 88 00 00 00 44 89 82 90 00 00 00 48 01 c8 48 89 42 50 41 81
f8 00 20 00 00 75 1d e9 60 24 07 00 44 89 c7 e9 98 f6 ff ff <0f> 0b eb
c5 0f 0b eb a1 0f 0b eb a7 0f 0b eb ac 44 89 c6 e9 40 23
RSP: 0018:ffffae514bc3be40 EFLAGS: 00010006
RAX: ffff8d25d6143750 RBX: 0000000000000202 RCX: 0000000000000002
RDX: ffff8d2e31383748 RSI: ffff8d25c000d600 RDI: ffff8d2e31383788
RBP: ffff8d2e31380de0 R08: 0000000000002000 R09: ffff8d2e31383750
R10: ffffffffc0c957e0 R11: ffff8d2624800000 R12: ffff8d2e31380a58
R13: ffff8d2d915eb000 R14: ffff8d25c499b5c0 R15: ffff8d2e31380e18
FS:  0000000000000000(0000) GS:ffff8d2d1fb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055fd0484b8b8 CR3: 00000008ffc10006 CR4: 00000000007706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
PKRU: 55555554
Call Trace:
  queue_delayed_work_on+0x36/0x40
  qedf_elsct_send+0x57/0x60 [qedf]
  fc_lport_enter_flogi+0x90/0xc0 [libfc]
  fc_lport_timeout+0xb7/0x140 [libfc]
  process_one_work+0x1a7/0x360
  ? create_worker+0x1a0/0x1a0
  worker_thread+0x30/0x390
  ? create_worker+0x1a0/0x1a0
  kthread+0x116/0x130
  ? kthread_flush_work_fn+0x10/0x10
  ret_from_fork+0x35/0x40
 ---[ end trace 008f00f722f2c2ff ]--

Initialize stag work for all the vports.

Link: https://lore.kernel.org/r/20220117135311.6256-2-njavali@marvell.com
Signed-off-by: Saurav Kashyap <skashyap@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 1bf7a22d49480..6e367b40ecc96 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -1862,6 +1862,7 @@ static int qedf_vport_create(struct fc_vport *vport, bool disabled)
 	vport_qedf->cmd_mgr = base_qedf->cmd_mgr;
 	init_completion(&vport_qedf->flogi_compl);
 	INIT_LIST_HEAD(&vport_qedf->fcports);
+	INIT_DELAYED_WORK(&vport_qedf->stag_work, qedf_stag_change_work);
 
 	rc = qedf_vport_libfc_config(vport, vn_port);
 	if (rc) {
-- 
2.34.1



