Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCA547AD56
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235089AbhLTOvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237574AbhLTOtm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:49:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B34C07E5F6;
        Mon, 20 Dec 2021 06:46:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E59A8B80EE4;
        Mon, 20 Dec 2021 14:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C9CC36AE7;
        Mon, 20 Dec 2021 14:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011563;
        bh=7epsYOuiAkBUnM9MBXGtORvmN8mGsF7Iomhy9N5DwZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cf9EEn8jYhbxl/nAAcHMFxVH48gOgfi+tlcQTr/6ONGLvxgAjKiihEzFrsEywch2f
         wocadTFe1f8KIDqSCZzufsxzfyUEZZEh0dntDCCRY3W1tjmw+Van0sjsd0HWI2ilyi
         ksNSIMWYuEytOvalPst7HaZCSITGYIlc746nJRUw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Sharath Srinivasan <sharath.srinivasan@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 33/71] rds: memory leak in __rds_conn_create()
Date:   Mon, 20 Dec 2021 15:34:22 +0100
Message-Id: <20211220143026.798180750@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
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
index c85bd6340eaa7..92ff40e7a66cf 100644
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



