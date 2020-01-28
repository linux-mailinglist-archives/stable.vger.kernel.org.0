Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 139B514B80C
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730588AbgA1OUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:20:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731010AbgA1OUH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:20:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4E462071E;
        Tue, 28 Jan 2020 14:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580221206;
        bh=SuNEaunjicElcpYE4/DtL1GUO/p8JfWw102Z1PSi99s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uNGKVcUlnO/HkpFQgm6yyetLf6tHnK4jZV6xgsa1RoJsjMoPcrNhH13rrmtjwyMaW
         e2VdpIaosFoNxrY0HYofEHXsjW8eqmtt2dOXouRXs0Zm3+eLbif0eYGrC8x9Te+IVT
         wqpjYUVC+9EkRcwyA33fUaFBD1lO2uAARtBPheHs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arthur Kiyanovski <akiyano@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 131/271] net: ena: fix incorrect test of supported hash function
Date:   Tue, 28 Jan 2020 15:04:40 +0100
Message-Id: <20200128135902.353434800@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135852.449088278@linuxfoundation.org>
References: <20200128135852.449088278@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

[ Upstream commit d3cfe7ddbc3dfbb9b201615b7fef8fd66d1b5fe8 ]

ena_com_set_hash_function() tests if a hash function is supported
by the device before setting it.
The test returns the opposite result than needed.
Reverse the condition to return the correct value.
Also use the BIT macro instead of inline shift.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index bcd993140f841..2d196d521b836 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -1967,7 +1967,7 @@ int ena_com_set_hash_function(struct ena_com_dev *ena_dev)
 	if (unlikely(ret))
 		return ret;
 
-	if (get_resp.u.flow_hash_func.supported_func & (1 << rss->hash_func)) {
+	if (!(get_resp.u.flow_hash_func.supported_func & BIT(rss->hash_func))) {
 		pr_err("Func hash %d isn't supported by device, abort\n",
 		       rss->hash_func);
 		return -EPERM;
-- 
2.20.1



