Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945E347AC44
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbhLTOmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:42:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49912 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbhLTOlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:41:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3304B80EDF;
        Mon, 20 Dec 2021 14:41:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2F4C36AED;
        Mon, 20 Dec 2021 14:41:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011282;
        bh=w6Rk7sXsS2sNvB40ulQlnxoCtVQkotRdPS4tX/XhkaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iOjACOPJn1iPdoZIazU7wCKM7DpDgRSfYqV8jydmUJ9Iu1q6DB2qOZednr78vl/9l
         9FWFf4DysmhLBgAbvkrKFjewsYnT4FDxCkk2H6YH0TazFZ+8cjoHS/DZbjTojOybQG
         dJlHwh8k4vhCLa6owOoTP0TSbckd4ubP1OBhysy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Sharath Srinivasan <sharath.srinivasan@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/56] rds: memory leak in __rds_conn_create()
Date:   Mon, 20 Dec 2021 15:34:15 +0100
Message-Id: <20211220143024.172619581@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143023.451982183@linuxfoundation.org>
References: <20211220143023.451982183@linuxfoundation.org>
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
index ac3300b204a6f..af9f7d1840037 100644
--- a/net/rds/connection.c
+++ b/net/rds/connection.c
@@ -250,6 +250,7 @@ static struct rds_connection *__rds_conn_create(struct net *net,
 				 * should end up here, but if it
 				 * does, reset/destroy the connection.
 				 */
+				kfree(conn->c_path);
 				kmem_cache_free(rds_conn_slab, conn);
 				conn = ERR_PTR(-EOPNOTSUPP);
 				goto out;
-- 
2.33.0



