Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3DA129B3B8
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1752541AbgJ0Oyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:54:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:44422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762874AbgJ0Ooh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:44:37 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4155421527;
        Tue, 27 Oct 2020 14:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809875;
        bh=ri3/j4O81BRM8Mr9mos8cWecgHH1LaP/CQcLfglo6sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zY4IZbgaALxCsugId+ORiKhMo9rGa/5JiMLNENKoI7NCebj1kB8wT41mMkj3jv/1T
         dg58+fpKZr5utTYZDL+0GqLPQFkukSs87VlpJTeyRy0j1X/ixZC8G+ql6qvmksFQIQ
         RloL+6+8LdFfmT+gfaFbikF8guX3HPyjb7G+hcp0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhenwei pi <pizhenwei@bytedance.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 319/408] nvmet: fix uninitialized work for zero kato
Date:   Tue, 27 Oct 2020 14:54:17 +0100
Message-Id: <20201027135509.835925964@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
index 7d7176369edf7..6b2f1e290fa73 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1048,7 +1048,8 @@ static void nvmet_start_ctrl(struct nvmet_ctrl *ctrl)
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



