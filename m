Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D13824B395
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgHTJtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:49:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729654AbgHTJta (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:49:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B34D92173E;
        Thu, 20 Aug 2020 09:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916970;
        bh=mHCLShJIyONqXrwZHOovab7y/jig8WvlVqeHasDla7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gaGrwXc+PfV14/SUwxOHhWRLZkGEZxSenFtHEeyV6I7fgtspVKMogPJl2edHLmHGf
         7sfQb65Orjs/o/Uex62iI1W47Vh4F7vP7YAzx7Lu3TqpfKcpucTkoGNS/smqHJq/UX
         8Rpon7K7fToUtG4LwKiOHHyds1AFHXKJtTdtlTGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 079/152] octeontx2-af: change (struct qmem)->entry_sz from u8 to u16
Date:   Thu, 20 Aug 2020 11:20:46 +0200
Message-Id: <20200820091557.777626013@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091553.615456912@linuxfoundation.org>
References: <20200820091553.615456912@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 393415203f5c916b5907e0a7c89f4c2c5a9c5505 ]

We need to increase TSO_HEADER_SIZE from 128 to 256.

Since otx2_sq_init() calls qmem_alloc() with TSO_HEADER_SIZE,
we need to change (struct qmem)->entry_sz to avoid truncation to 0.

Fixes: 7a37245ef23f ("octeontx2-af: NPA block admin queue init")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/common.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index 413c3f254cf85..c881a573da662 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -43,7 +43,7 @@ struct qmem {
 	void            *base;
 	dma_addr_t	iova;
 	int		alloc_sz;
-	u8		entry_sz;
+	u16		entry_sz;
 	u8		align;
 	u32		qsize;
 };
-- 
2.25.1



