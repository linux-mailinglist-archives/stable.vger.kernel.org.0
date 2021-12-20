Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1808147AE6C
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239348AbhLTPBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237887AbhLTO4Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:56:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7BFC08E9BC;
        Mon, 20 Dec 2021 06:48:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C1B9611B5;
        Mon, 20 Dec 2021 14:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62DA7C36AEA;
        Mon, 20 Dec 2021 14:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011713;
        bh=dWGCvJFke8rlo0Spb5XGfGUG/OaMaANS0VD/u1oFyJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OyM40vFi5Hm5SOeHfpPKkM7kHHhTXg7lXUCzO3eX8b32XbRBbipIDoqbmWufRr1Cg
         Ij+ipR891POpHU096uD8VHtiK+2TnmF3KVim3b3PapUea6oeGIOkK+w1Fn/Cuj+Yba
         YNwZkb8Gj690g1ay1DjOVZudl6UktSN2Ul+tukYc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Sharath Srinivasan <sharath.srinivasan@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 46/99] rds: memory leak in __rds_conn_create()
Date:   Mon, 20 Dec 2021 15:34:19 +0100
Message-Id: <20211220143030.934944001@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit 5f9562ebe710c307adc5f666bf1a2162ee7977c0 ]

__rds_conn_create() did not release conn->c_path when loop_trans != 0 and
trans->t_prefer_loopback != 0 and is_outgoing == 0.

Fixes: aced3ce57cd3 ("RDS tcp loopback connection can hang")
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Reviewed-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/connection.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/rds/connection.c b/net/rds/connection.c
index a3bc4b54d4910..b4cc699c5fad3 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -253,6 +253,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 				 * should end up here, but if it
 				 * does, reset/destroy the connection.
 				 */
+				kfree(conn->c_path);
 				kmem_cache_free(rds_conn_slab, conn);
 				conn = ERR_PTR(-EOPNOTSUPP);
 				goto out;
-- 
2.33.0



