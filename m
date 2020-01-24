Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9AE147CFD
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 10:56:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388042AbgAXJ4L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 04:56:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:59886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731830AbgAXJ4L (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 04:56:11 -0500
Received: from localhost (unknown [145.15.244.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32EAE2075D;
        Fri, 24 Jan 2020 09:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579859770;
        bh=3JNHxqSOL6IW0z4LiY4CBWCxFhq36dwC5JGGAApbR9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NIxBjtG/Wy+yqwH2486g+FP7E6HGlnzWu7WvliGSRf+xkmj0vF3eVyDFrlMVPiwxH
         kw1uWwc9wClvYFuBhW4VYg0TnAZKWrqfFDEsWd6rj8mqpWCtnGZSXyXqNey3Qb1z6f
         Ugu/Q9XmCHd4mjaVeSfqIHm/kbyevMH0n87SGQRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Netanel Belgazal <netanel@amazon.com>,
        Sameeh Jubran <sameehj@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 191/343] net: ena: fix ena_com_fill_hash_function() implementation
Date:   Fri, 24 Jan 2020 10:30:09 +0100
Message-Id: <20200124092945.104574737@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124092919.490687572@linuxfoundation.org>
References: <20200124092919.490687572@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sameeh Jubran <sameehj@amazon.com>

[ Upstream commit 11bd7a00c0d8ffe33d1e926f8e789b4aea787186 ]

ena_com_fill_hash_function() didn't configure the rss->hash_func.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Netanel Belgazal <netanel@amazon.com>
Signed-off-by: Sameeh Jubran <sameehj@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_com.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c b/drivers/net/ethernet/amazon/ena/ena_com.c
index 011b54c541aae..10e6053f66712 100644
--- a/drivers/net/ethernet/amazon/ena/ena_com.c
+++ b/drivers/net/ethernet/amazon/ena/ena_com.c
@@ -2087,6 +2087,7 @@ int ena_com_fill_hash_function(struct ena_com_dev *ena_dev,
 		return -EINVAL;
 	}
 
+	rss->hash_func = func;
 	rc = ena_com_set_hash_function(ena_dev);
 
 	/* Restore the old function */
-- 
2.20.1



