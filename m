Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58CCE29C3CA
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1822565AbgJ0Ru3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:50:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:50928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758879AbgJ0OZ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:25:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FD0820780;
        Tue, 27 Oct 2020 14:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808728;
        bh=hc3IxUAj9toAq0/vxIXbZJ9/pa0OOYceVsz4jHcHSzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J09zxVjXcqvvqJZJUBS4MacZC/0M3W6yDQu1mEgqAS3OCoXn6czuJbMBJVNaSi2/z
         hEG3b3yc9A44aJJm7W+69EfGFAi8blF27O6WBdPKxfTAgVhxwYI9LqZWk461SdS191
         al8xvBjQmMAfROr+J6Kc4f61km2n3gz8v/zF11RI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhenwei pi <pizhenwei@bytedance.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 201/264] nvmet: fix uninitialized work for zero kato
Date:   Tue, 27 Oct 2020 14:54:19 +0100
Message-Id: <20201027135440.109067269@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhenwei pi <pizhenwei@bytedance.com>

[ Upstream commit 85bd23f3dc09a2ae9e56885420e52c54bf983713 ]

When connecting a controller with a zero kato value using the following
command line

   nvme connect -t tcp -n NQN -a ADDR -s PORT --keep-alive-tmo=0

the warning below can be reproduced:

WARNING: CPU: 1 PID: 241 at kernel/workqueue.c:1627 __queue_delayed_work+0x6d/0x90
with trace:
  mod_delayed_work_on+0x59/0x90
  nvmet_update_cc+0xee/0x100 [nvmet]
  nvmet_execute_prop_set+0x72/0x80 [nvmet]
  nvmet_tcp_try_recv_pdu+0x2f7/0x770 [nvmet_tcp]
  nvmet_tcp_io_work+0x63f/0xb2d [nvmet_tcp]
  ...

This is caused by queuing up an uninitialized work.  Althrough the
keep-alive timer is disabled during allocating the controller (fixed in
0d3b6a8d213a), ka_work still has a chance to run (called by
nvmet_start_ctrl).

Fixes: 0d3b6a8d213a ("nvmet: Disable keep-alive timer when kato is cleared to 0h")
Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/target/core.c b/drivers/nvme/target/core.c
index f28df233dfcd0..2b492ad55f0e4 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -787,7 +787,8 @@ static void nvmet_start_ctrl(struct nvmet_ctrl *ctrl)
 	 * in case a host died before it enabled the controller.  Hence, simply
 	 * reset the keep alive timer when the controller is enabled.
 	 */
-	mod_delayed_work(system_wq, &ctrl->ka_work, ctrl->kato * HZ);
+	if (ctrl->kato)
+		mod_delayed_work(system_wq, &ctrl->ka_work, ctrl->kato * HZ);
 }
 
 static void nvmet_clear_ctrl(struct nvmet_ctrl *ctrl)
-- 
2.25.1



