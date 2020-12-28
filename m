Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6C2B2E3998
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:25:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388877AbgL1NZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:25:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388880AbgL1NZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:25:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27C7D208D5;
        Mon, 28 Dec 2020 13:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161876;
        bh=fQZgblhjFzDdcEo9QNDDaTdNYYxU6/ECnoa3kOsORnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dUowhocmN2G+Wkpmy+Mxgws+329TLAGdkYz8t7/Ay/6Yo5g1u1GP6bY/kw0y3KL3r
         hMbD1LcTUe9C5z5HdM3JbQiZd8O28y4ttaqFJOMRnXUMXPZfruxG/hIrT3/o2I1CRt
         20bI6u4IgmKqZ8Lco6sONjOInRmqCbXgZngKsUNA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 112/346] crypto: talitos - Endianess in current_desc_hdr()
Date:   Mon, 28 Dec 2020 13:47:11 +0100
Message-Id: <20201228124925.202873002@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 195404db27f9533c71fdcb78d32a77075c2cb4a2 ]

current_desc_hdr() compares the value of the current descriptor
with the next_desc member of the talitos_desc struct.

While the current descriptor is obtained from in_be32() which
return CPU ordered bytes, next_desc member is in big endian order.

Convert the current descriptor into big endian before comparing it
with next_desc.

This fixes a sparse warning.

Fixes: 37b5e8897eb5 ("crypto: talitos - chain in buffered data for ahash on SEC1")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/talitos.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index ea16308fae0a5..7e69d77ea2595 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -492,7 +492,7 @@ static u32 current_desc_hdr(struct device *dev, int ch)
 
 	iter = tail;
 	while (priv->chan[ch].fifo[iter].dma_desc != cur_desc &&
-	       priv->chan[ch].fifo[iter].desc->next_desc != cur_desc) {
+	       priv->chan[ch].fifo[iter].desc->next_desc != cpu_to_be32(cur_desc)) {
 		iter = (iter + 1) & (priv->fifo_len - 1);
 		if (iter == tail) {
 			dev_err(dev, "couldn't locate current descriptor\n");
@@ -500,7 +500,7 @@ static u32 current_desc_hdr(struct device *dev, int ch)
 		}
 	}
 
-	if (priv->chan[ch].fifo[iter].desc->next_desc == cur_desc) {
+	if (priv->chan[ch].fifo[iter].desc->next_desc == cpu_to_be32(cur_desc)) {
 		struct talitos_edesc *edesc;
 
 		edesc = container_of(priv->chan[ch].fifo[iter].desc,
-- 
2.27.0



