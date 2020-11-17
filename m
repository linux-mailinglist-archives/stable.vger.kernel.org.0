Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1372B66B5
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 15:06:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgKQNH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:07:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:36400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729184AbgKQNH6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:07:58 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26C31246BC;
        Tue, 17 Nov 2020 13:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605618477;
        bh=WHGapFUCYjqIwjWno05Zd5FO/X6rBRNXN9nYRsiogMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BKbOUZv7Pud/NeH4N4x6/P0eS7uD0ne3yVYlxBeQtbfUkNp0Ew4F2sbJsf2wdHYXu
         vT1NzwXeU5F9wrgVy0STkDs4HjedKvWe0ric9Ffr8jDFwVVNXIq4LWKiR6m6bOhDGG
         TieulSbt0a3vpa8r9iCC6oziu52fu9/WKp0bQl3k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Evan Nimmo <evan.nimmo@alliedtelesis.co.nz>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 29/64] of/address: Fix of_node memory leak in of_dma_is_coherent
Date:   Tue, 17 Nov 2020 14:04:52 +0100
Message-Id: <20201117122107.581408797@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122106.144800239@linuxfoundation.org>
References: <20201117122106.144800239@linuxfoundation.org>
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
index b3bf8762f4e8c..77881432dd404 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -1014,11 +1014,13 @@ EXPORT_SYMBOL_GPL(of_dma_get_range);
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



