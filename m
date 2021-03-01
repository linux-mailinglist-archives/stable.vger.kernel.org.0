Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20AF328630
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236997AbhCARFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:05:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:59144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236108AbhCAQ7H (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:59:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8984464F6D;
        Mon,  1 Mar 2021 16:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616644;
        bh=Jr7Bt1lZrWD1JwraGMPIFqP0U3pkzDgg51wvpVbDEi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ySw0O01sqJwhL1I7pCbQpjPyE76NSJokVcpWGqjJcNVm7efInYRcm8wkTCk1L8eDe
         CYbD87i5q0JERSX257aUYbZHJwLPnxWRf0X7Bo+wOrCQAdpg200lu5m2aZkjXQ3xKV
         CbD6uHz3QUzhQsUAFv0ULPGHwgZAmoZ2BWKjS9Fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 045/247] memory: ti-aemif: Drop child node when jumping out loop
Date:   Mon,  1 Mar 2021 17:11:05 +0100
Message-Id: <20210301161033.878962466@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit 94e9dd43cf327366388c8f146bccdc6322c0d999 ]

Call of_node_put() to decrement the reference count of the child node
child_np when jumping out of the loop body of
for_each_available_child_of_node(), which is a macro that increments and
decrements the reference count of child node. If the loop is broken, the
reference of the child node should be dropped manually.

Fixes: 5a7c81547c1d ("memory: ti-aemif: introduce AEMIF driver")
Signed-off-by: Pan Bian <bianpan2016@163.com>
Link: https://lore.kernel.org/r/20210121090359.61763-1-bianpan2016@163.com
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/ti-aemif.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/memory/ti-aemif.c b/drivers/memory/ti-aemif.c
index 475e5b3790edb..be3d978648f57 100644
--- a/drivers/memory/ti-aemif.c
+++ b/drivers/memory/ti-aemif.c
@@ -381,8 +381,10 @@ static int aemif_probe(struct platform_device *pdev)
 		 */
 		for_each_available_child_of_node(np, child_np) {
 			ret = of_aemif_parse_abus_config(pdev, child_np);
-			if (ret < 0)
+			if (ret < 0) {
+				of_node_put(child_np);
 				goto error;
+			}
 		}
 	} else if (pdata && pdata->num_abus_data > 0) {
 		for (i = 0; i < pdata->num_abus_data; i++, aemif->num_cs++) {
@@ -408,8 +410,10 @@ static int aemif_probe(struct platform_device *pdev)
 		for_each_available_child_of_node(np, child_np) {
 			ret = of_platform_populate(child_np, NULL,
 						   dev_lookup, dev);
-			if (ret < 0)
+			if (ret < 0) {
+				of_node_put(child_np);
 				goto error;
+			}
 		}
 	} else if (pdata) {
 		for (i = 0; i < pdata->num_sub_devices; i++) {
-- 
2.27.0



