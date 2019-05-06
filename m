Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AB1914EF0
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfEFOhs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:37:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:58630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726418AbfEFOhq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:37:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC446204EC;
        Mon,  6 May 2019 14:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153466;
        bh=7OxJbkyPyhXvXcm9b2wqW0qcqTSUjNm69XWQPModrrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RfFhi8niW4jC0Q+yX3cg5HBf2uFgbjmx5rwIWMeNARXFB/irLNlgirrqa/DsKUj5A
         2gCGHVUfrPvshuMpIAeup1QsngerCF3O5nwM3tYCtslDU69/6nXycWRStP8OGzIQlb
         T9d8VSnNkaF3+oikMh0rEH7kDw5N9aU30mWFiUdw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Pittman <jpittman@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Sasha Levin (Microsoft)" <sashal@kernel.org>
Subject: [PATCH 5.0 078/122] null_blk: prevent crash from bad home_node value
Date:   Mon,  6 May 2019 16:32:16 +0200
Message-Id: <20190506143101.836774644@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7ff684a683d777c4956fce93e60accbab2bd7696 ]

At module load, if the selected home_node value is greater than
the available numa nodes, the system will crash in
__alloc_pages_nodemask() due to a bad paging request.  Prevent this
user error crash by detecting the bad value, logging an error, and
setting g_home_node back to the default of NUMA_NO_NODE.

Signed-off-by: John Pittman <jpittman@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin (Microsoft) <sashal@kernel.org>
---
 drivers/block/null_blk_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 62c9654b9ce8..fd7a9be54595 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1749,6 +1749,11 @@ static int __init null_init(void)
 		return -EINVAL;
 	}
 
+	if (g_home_node != NUMA_NO_NODE && g_home_node >= nr_online_nodes) {
+		pr_err("null_blk: invalid home_node value\n");
+		g_home_node = NUMA_NO_NODE;
+	}
+
 	if (g_queue_mode == NULL_Q_RQ) {
 		pr_err("null_blk: legacy IO path no longer available\n");
 		return -EINVAL;
-- 
2.20.1



