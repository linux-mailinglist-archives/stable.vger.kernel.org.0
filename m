Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D1029BE59
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1794764AbgJ0PNZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:13:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1794757AbgJ0PNY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:13:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2403B20728;
        Tue, 27 Oct 2020 15:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811602;
        bh=2/4bFbKDfm+XVX1/UH+VcP6K9ZV0b7bxP4odHlwzXPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=INXKbUjIv7ZG879muEyVNZbrwpj+6OHiolxbumKnAKxKwJ99vFFVQCnOAWg0ZsX1E
         jsmFLh4rPr7IiK57CkL7XFRrygpa/tNwdrfeglWjttzka2+HYUJQ28jtAYjVn6LBRH
         /JMaWnfKjEwaLWTYCZ3hWHublxASw2GCRWH8+M6I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zhenwei pi <pizhenwei@bytedance.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 520/633] nvmet: fix uninitialized work for zero kato
Date:   Tue, 27 Oct 2020 14:54:23 +0100
Message-Id: <20201027135547.159661179@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index 58b035cc67a01..75ed95a250fb5 100644
--- a/drivers/nvme/target/core.c
+++ b/drivers/nvme/target/core.c
@@ -1142,7 +1142,8 @@ static void nvmet_start_ctrl(struct nvmet_ctrl *ctrl)
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



