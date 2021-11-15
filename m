Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD05D4520AF
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343597AbhKPA4N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:56:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343512AbhKOTVQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 525E56359F;
        Mon, 15 Nov 2021 18:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001673;
        bh=erjptlGVqA1lIBoZchTvLDCAAjN1uZValxdJft8b+LM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6UuOQ9aTgyuAsL5Tp+ExpMPdHHt+rVbJDIiQG9pSJv3KCx/eayRU2zGJoycalu2h
         9mDcq6FrSYb6NP/jnv06uQbJ+7hEa0XzE4AM+SwwTH+gfuSaOuuJrSSt3Oy8m6fjcR
         BURzHqc4tLANBXJe7o6+pNtqVF7kj3Kd2w8xjz6s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Israel Rukshin <israelr@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 278/917] nvmet: fix use-after-free when a port is removed
Date:   Mon, 15 Nov 2021 17:56:13 +0100
Message-Id: <20211115165438.198595639@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Israel Rukshin <israelr@nvidia.com>

[ Upstream commit e3e19dcc4c416d65f99f13d55be2b787f8d0050e ]

When a port is removed through configfs, any connected controllers
are starting teardown flow asynchronously and can still send commands.
This causes a use-after-free bug for any command that dereferences
req->port (like in nvmet_parse_io_cmd).

To fix this, wait for all the teardown scheduled works to complete
(like release_work at rdma/tcp drivers). This ensures there are no
active controllers when the port is eventually removed.

Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index be5d82421e3a4..496d775c67707 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -1553,6 +1553,8 @@ static void nvmet_port_release(struct config_item *item)
 {
 	struct nvmet_port *port = to_nvmet_port(item);
 
+	/* Let inflight controllers teardown complete */
+	flush_scheduled_work();
 	list_del(&port->global_entry);
 
 	kfree(port->ana_state);
-- 
2.33.0



