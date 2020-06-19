Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A479F200CAA
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 16:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389046AbgFSOsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:48:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389048AbgFSOsS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:48:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B4C2E2083B;
        Fri, 19 Jun 2020 14:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578098;
        bh=saLN3d1KPLnQ2+/04KMRkgHFhsJjNTOGFsAj3gFbmXQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQvpe/AzdJy9bIZ8tCLaTnL2C0FkBphadus3AZ1Ws6bpHUy3ARaYJfKbuflq7CZmM
         gEUZ2atslPTVWGCTmAZsIlJH9ev5yXu0sj/1sZrx4myLYeCsZ2fywID6451GXlDaGf
         A3CqzhkUKs03Y6VltIurwWPoJnL2ahsyxrqCEUe8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sameeh Jubran <sameehj@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 081/190] net: ena: fix error returning in ena_com_get_hash_function()
Date:   Fri, 19 Jun 2020 16:32:06 +0200
Message-Id: <20200619141637.637890862@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141633.446429600@linuxfoundation.org>
References: <20200619141633.446429600@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arthur Kiyanovski <akiyano@amazon.com>

[ Upstream commit e9a1de378dd46375f9abfd8de1e6f59ee114a793 ]

In case the "func" parameter is NULL we now return "-EINVAL".
This shouldn't happen in general, but when it does happen, this is the
proper way to handle it.

We also check func for NULL in the beginning of the function, as there
is no reason to do all the work and realize in the end of the function
it was useless.

Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index dc9149a32f41..bb1710ff910a 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2131,6 +2131,9 @@ int ena_com_get_hash_function(struct ena_com_dev *ena_dev,
 		rss->hash_key;
 	int rc;
 
+	if (unlikely(!func))
+		return -EINVAL;
+
 	rc = ena_com_get_feature_ex(ena_dev, &get_resp,
 				    ENA_ADMIN_RSS_HASH_FUNCTION,
 				    rss->hash_key_dma_addr,
@@ -2143,8 +2146,7 @@ int ena_com_get_hash_function(struct ena_com_dev *ena_dev,
 	if (rss->hash_func)
 		rss->hash_func--;
 
-	if (func)
-		*func = rss->hash_func;
+	*func = rss->hash_func;
 
 	if (key)
 		memcpy(key, hash_key->key, (size_t)(hash_key->keys_num) << 2);
-- 
2.25.1



