Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 660F7247567
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:23:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730594AbgHQTXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730453AbgHQPfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:35:22 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CB5320882;
        Mon, 17 Aug 2020 15:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678522;
        bh=IzTK1brHvbzYGCLGKWtVUX/++/DgFMolRIjMEhdKywU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KHjFcfezqOgmUM7DQ8Xdj3RhqRhR93AUuPl9vQzOsmAH7TQwKoU7Dz1tV1BnZyG8I
         //wtPm12+DExoIVhNoFm6OSKHKKm4uUPq7E5XREsoCI2Bwk6RH9DeV4o9MstDhIqH+
         AP6yW4+SzzhoiOgNnvH2yjm/1SlFrXRD5Neow+nE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 364/464] fsl/fman: fix eth hash table allocation
Date:   Mon, 17 Aug 2020 17:15:17 +0200
Message-Id: <20200817143851.209597844@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florinel Iordache <florinel.iordache@nxp.com>

[ Upstream commit 3207f715c34317d08e798e11a10ce816feb53c0f ]

Fix memory allocation for ethernet address hash table.
The code was wrongly allocating an array for eth hash table which
is incorrect because this is the main structure for eth hash table
(struct eth_hash_t) that contains inside a number of elements.

Fixes: 57ba4c9b56d8 ("fsl/fman: Add FMan MAC support")
Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fman/fman_mac.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_mac.h b/drivers/net/ethernet/freescale/fman/fman_mac.h
index dd6d0526f6c1f..19f327efdaff3 100644
--- a/drivers/net/ethernet/freescale/fman/fman_mac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_mac.h
@@ -252,7 +252,7 @@ static inline struct eth_hash_t *alloc_hash_table(u16 size)
 	struct eth_hash_t *hash;
 
 	/* Allocate address hash table */
-	hash = kmalloc_array(size, sizeof(struct eth_hash_t *), GFP_KERNEL);
+	hash = kmalloc(sizeof(*hash), GFP_KERNEL);
 	if (!hash)
 		return NULL;
 
-- 
2.25.1



