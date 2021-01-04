Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D19E2E9A38
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:12:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbhADQBQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:01:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:38422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728523AbhADQBO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:01:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67118224D4;
        Mon,  4 Jan 2021 16:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776033;
        bh=RfDIi+ld6PVLeo0NMQXjKVHQtzypeNuRJnbtIICYHuI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zPgUPyNmVf91RRCxOW0wwHI43tfURk4egiPLGugA6tcU/D0Wx4gkyWZsRVWwJ+pE4
         y+QsbM/1y1R/NJwB97Ya700hkyz10F9rrPU3NIQUhxk2nrqf+hygTC8FboBlRNqNwY
         AlTS8qLlnsEVvPzygeLkG7uGTaj+F1rhaW5aIziM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qinglang Miao <miaoqinglang@huawei.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 39/47] i3c master: fix missing destroy_workqueue() on error in i3c_master_register
Date:   Mon,  4 Jan 2021 16:57:38 +0100
Message-Id: <20210104155707.622173155@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 59165d16c699182b86b5c65181013f1fd88feb62 ]

Add the missing destroy_workqueue() before return from
i3c_master_register in the error handling case.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://lore.kernel.org/linux-i3c/20201028091543.136167-1-miaoqinglang@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 6cc71c90f85ea..19337aed9f235 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -2492,7 +2492,7 @@ int i3c_master_register(struct i3c_master_controller *master,
 
 	ret = i3c_master_bus_init(master);
 	if (ret)
-		goto err_put_dev;
+		goto err_destroy_wq;
 
 	ret = device_add(&master->dev);
 	if (ret)
@@ -2523,6 +2523,9 @@ int i3c_master_register(struct i3c_master_controller *master,
 err_cleanup_bus:
 	i3c_master_bus_cleanup(master);
 
+err_destroy_wq:
+	destroy_workqueue(master->wq);
+
 err_put_dev:
 	put_device(&master->dev);
 
-- 
2.27.0



