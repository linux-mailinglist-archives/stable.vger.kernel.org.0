Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2DA2B6188
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729831AbgKQNUA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:20:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729575AbgKQNT7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:19:59 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 57A8C241A6;
        Tue, 17 Nov 2020 13:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619198;
        bh=QhHr7M29daAeMk7vkOkFo+ezbF6jU7vpB6jpsy5pCOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sURCy3CM6knfEbzPkHL9uo0/UOR/HTvBA15gVb/zLhh9DCTAGc3X+xSCuLrZZT3i3
         iybJBvQ/zZbYZc59nL+uQMbPGnvsnGoeDwgSudr6bGTGutntwkpw7ZZ0I6uY543GJ9
         sIaKwL68ITf1KKjL5sKKuJlWBn8u7zhQbySFeNqk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Evan Nimmo <evan.nimmo@alliedtelesis.co.nz>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 060/101] of/address: Fix of_node memory leak in of_dma_is_coherent
Date:   Tue, 17 Nov 2020 14:05:27 +0100
Message-Id: <20201117122116.028079051@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122113.128215851@linuxfoundation.org>
References: <20201117122113.128215851@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Nimmo <evan.nimmo@alliedtelesis.co.nz>

[ Upstream commit a5bea04fcc0b3c0aec71ee1fd58fd4ff7ee36177 ]

Commit dabf6b36b83a ("of: Add OF_DMA_DEFAULT_COHERENT & select it on
powerpc") added a check to of_dma_is_coherent which returns early
if OF_DMA_DEFAULT_COHERENT is enabled. This results in the of_node_put()
being skipped causing a memory leak. Moved the of_node_get() below this
check so we now we only get the node if OF_DMA_DEFAULT_COHERENT is not
enabled.

Fixes: dabf6b36b83a ("of: Add OF_DMA_DEFAULT_COHERENT & select it on powerpc")
Signed-off-by: Evan Nimmo <evan.nimmo@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20201110022825.30895-1-evan.nimmo@alliedtelesis.co.nz
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/address.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/of/address.c b/drivers/of/address.c
index c42aebba35ab8..30806dd357350 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -975,11 +975,13 @@ EXPORT_SYMBOL_GPL(of_dma_get_range);
  */
 bool of_dma_is_coherent(struct device_node *np)
 {
-	struct device_node *node = of_node_get(np);
+	struct device_node *node;
 
 	if (IS_ENABLED(CONFIG_OF_DMA_DEFAULT_COHERENT))
 		return true;
 
+	node = of_node_get(np);
+
 	while (node) {
 		if (of_property_read_bool(node, "dma-coherent")) {
 			of_node_put(node);
-- 
2.27.0



