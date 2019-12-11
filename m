Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32FDF11AFDB
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:18:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731982AbfLKPRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:17:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:44454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731979AbfLKPRI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:17:08 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9EE824658;
        Wed, 11 Dec 2019 15:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077428;
        bh=2AS1A87NUSa4PIiydpIvNtQkPx9HzA4w4FQEbZAn4iY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YJD0uw0ujt1WmJGAsvdPbXGBQqas1W8wmvsnQC3FukQC/o9AYr4jTlPf8+xJBpfTW
         l31BWk9OA3NE1zv0Lsc2MTA2RZc+Z62VmbmyXsyDQG+NmG41Npoy4XjJaV7l/noijW
         MMDN9FuUErKT9ngb0RFIOwpL/vTP2YNcLL4jz5v8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arjun Vynipadath <arjun@chelsio.com>,
        Ganesh Goudar <ganeshgr@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 028/243] cxgb4vf: fix memleak in mac_hlist initialization
Date:   Wed, 11 Dec 2019 16:03:10 +0100
Message-Id: <20191211150340.765909315@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arjun Vynipadath <arjun@chelsio.com>

[ Upstream commit 24357e06ba511ad874d664d39475dbb01c1ca450 ]

mac_hlist was initialized during adapter_up, which will be called
every time a vf device is first brought up, or every time when device
is brought up again after bringing all devices down. This means our
state of previous list is lost, causing a memleak if entries are
present in the list. To fix that, move list init to the condition
that performs initial one time adapter setup.

Signed-off-by: Arjun Vynipadath <arjun@chelsio.com>
Signed-off-by: Ganesh Goudar <ganeshgr@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
index ff84791a0ff85..972dc7bd721d9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -722,6 +722,10 @@ static int adapter_up(struct adapter *adapter)
 
 		if (adapter->flags & USING_MSIX)
 			name_msix_vecs(adapter);
+
+		/* Initialize hash mac addr list*/
+		INIT_LIST_HEAD(&adapter->mac_hlist);
+
 		adapter->flags |= FULL_INIT_DONE;
 	}
 
@@ -747,8 +751,6 @@ static int adapter_up(struct adapter *adapter)
 	enable_rx(adapter);
 	t4vf_sge_start(adapter);
 
-	/* Initialize hash mac addr list*/
-	INIT_LIST_HEAD(&adapter->mac_hlist);
 	return 0;
 }
 
-- 
2.20.1



