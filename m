Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38DA93788E2
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235453AbhEJLYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:24:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:49920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232323AbhEJLL6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D56106193B;
        Mon, 10 May 2021 11:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644985;
        bh=j5XTR1qhDcUTBJswHxZ+UguBx7tHL2/2rtgwId+4R3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cuzGivIuFmtS/YCHQY0w71xrEfO0JIEoM8BiTP+5ddHYVxPi/INGNeuYVRKxcTnhS
         bK64BnRhvVHfmd8ZV/O7w253NLDqDNQzNUi0kH3jiaC8Cf6SUu1Jtjdrz+ywd1TGZz
         hSyYaeu+EWROMFRqNOPVLI4QkFvRzEb0QZbiaVqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hou Pu <houpu.main@gmail.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 269/384] nvmet: avoid queuing keep-alive timer if it is disabled
Date:   Mon, 10 May 2021 12:20:58 +0200
Message-Id: <20210510102023.712953366@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Pu <houpu.main@gmail.com>

[ Upstream commit 8f864c595bed20ef85fef3e7314212b73800d51d ]

Issue following command:
nvme set-feature -f 0xf -v 0 /dev/nvme1n1 # disable keep-alive timer
nvme admin-passthru -o 0x18 /dev/nvme1n1  # send keep-alive command
will make keep-alive timer fired and thus delete the controller like
below:

[247459.907635] nvmet: ctrl 1 keep-alive timer (0 seconds) expired!
[247459.930294] nvmet: ctrl 1 fatal error occurred!

Avoid this by not queuing delayed keep-alive if it is disabled when
keep-alive command is received from the admin queue.

Signed-off-by: Hou Pu <houpu.main@gmail.com>
Tested-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/admin-cmd.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/admin-cmd.c b/drivers/nvme/target/admin-cmd.c
index fe6b8aa90b53..81224447605b 100644
--- a/drivers/nvme/target/admin-cmd.c
+++ b/drivers/nvme/target/admin-cmd.c
@@ -919,15 +919,21 @@ void nvmet_execute_async_event(struct nvmet_req *req)
 void nvmet_execute_keep_alive(struct nvmet_req *req)
 {
 	struct nvmet_ctrl *ctrl = req->sq->ctrl;
+	u16 status = 0;
 
 	if (!nvmet_check_transfer_len(req, 0))
 		return;
 
+	if (!ctrl->kato) {
+		status = NVME_SC_KA_TIMEOUT_INVALID;
+		goto out;
+	}
+
 	pr_debug("ctrl %d update keep-alive timer for %d secs\n",
 		ctrl->cntlid, ctrl->kato);
-
 	mod_delayed_work(system_wq, &ctrl->ka_work, ctrl->kato * HZ);
-	nvmet_req_complete(req, 0);
+out:
+	nvmet_req_complete(req, status);
 }
 
 u16 nvmet_parse_admin_cmd(struct nvmet_req *req)
-- 
2.30.2



