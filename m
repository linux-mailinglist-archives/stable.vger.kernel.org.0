Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8ADBA8FEF
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388768AbfIDSGp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:06:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:48854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732321AbfIDSGo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:06:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C61C208E4;
        Wed,  4 Sep 2019 18:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620403;
        bh=3dQiJ0I3nOjQlJ5QXGYzOKeUQs0f52s6ysCBJrBzAZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HjoAC5mhX40fikAT20evM3zwu4Ni8sxlcP9c4DIlzb7bCwLykNCmEi2SNhAkmhqaZ
         kWaqt8lNCYD+OHb6IL9APLKtLlTtCjZgP51awR15Py27G4IWn2XI1UmAsjymUTsGvK
         5++Zl4/upRxOS5bOLVbvczJnnvoZoixl6hsNIoHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Max Gurtovoy <maxg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 07/93] nvmet-loop: Flush nvme_delete_wq when removing the port
Date:   Wed,  4 Sep 2019 19:53:09 +0200
Message-Id: <20190904175303.699597924@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 86b9a63e595ff03f9d0a7b92b6acc231fecefc29 ]

After calling nvme_loop_delete_ctrl(), the controllers will not
yet be deleted because nvme_delete_ctrl() only schedules work
to do the delete.

This means a race can occur if a port is removed but there
are still active controllers trying to access that memory.

To fix this, flush the nvme_delete_wq before returning from
nvme_loop_remove_port() so that any controllers that might
be in the process of being deleted won't access a freed port.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
Reviewed-by : Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/loop.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index 9908082b32c4b..137a27fa369cb 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -678,6 +678,14 @@ static void nvme_loop_remove_port(struct nvmet_port *port)
 	mutex_lock(&nvme_loop_ports_mutex);
 	list_del_init(&port->entry);
 	mutex_unlock(&nvme_loop_ports_mutex);
+
+	/*
+	 * Ensure any ctrls that are in the process of being
+	 * deleted are in fact deleted before we return
+	 * and free the port. This is to prevent active
+	 * ctrls from using a port after it's freed.
+	 */
+	flush_workqueue(nvme_delete_wq);
 }
 
 static const struct nvmet_fabrics_ops nvme_loop_ops = {
-- 
2.20.1



