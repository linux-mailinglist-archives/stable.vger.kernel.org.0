Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 302F83C5446
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348270AbhGLH5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350545AbhGLHxy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:53:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1CFF06142F;
        Mon, 12 Jul 2021 07:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076265;
        bh=uaZ0FqznXkgtH9TsE5H5Mtjlkk2oHewTm7iMVEhkEos=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sfp/j1IwGykk2kb2BZosFX2WfkINwAzm2Egqi70gmlpeElU6fYXka8/KghyzmHNC9
         1YTsayZh01xmecs9N3/r88xQZBsDgFLpF4v1BpKqr1Jg/kaoU/NVjvvvhocrZt36wo
         e5c0jXZWdwtDbu8B9BosAylxt46Sy+FNvXBkvy/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 526/800] net: mana: Fix a memory leak in an error handling path in mana_create_txq()
Date:   Mon, 12 Jul 2021 08:09:09 +0200
Message-Id: <20210712061023.250756630@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b90788459cd6d140171b046f0b37fad341ade0a3 ]

If this test fails we must free some resources as in all the other error
handling paths of this function.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Dexuan Cui <decui@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 04d067243457..1ed25e48f616 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -1230,8 +1230,10 @@ static int mana_create_txq(struct mana_port_context *apc,
 
 		cq->gdma_id = cq->gdma_cq->id;
 
-		if (WARN_ON(cq->gdma_id >= gc->max_num_cqs))
-			return -EINVAL;
+		if (WARN_ON(cq->gdma_id >= gc->max_num_cqs)) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		gc->cq_table[cq->gdma_id] = cq->gdma_cq;
 
-- 
2.30.2



