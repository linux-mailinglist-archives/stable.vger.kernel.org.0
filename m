Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80C6A121279
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 18:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfLPRw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:52:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:45850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726976AbfLPRw6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:52:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B3D02176D;
        Mon, 16 Dec 2019 17:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518777;
        bh=P3fHYkF8uiwCRNGqsqGZ22zNSpDc/wgJmZ4ibWm9yMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5cSuNrtGMMyJAJ2tk/mk6NsOFkQnNOsqrDnPI8bwvhgI+72kCfgiJkNkBVfqEN3B
         kxIInEW61bLhQT4ARjAygdrj26y4batqr0azT+2KC7Zmn1+XHPmTHdBxD+XoeN6CaD
         LUMa6GGnZtvKab+HrtZelGg2Kw48EEHCs5ranRYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arjun Vynipadath <arjun@chelsio.com>,
        Ganesh Goudar <ganeshgr@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 023/267] cxgb4vf: fix memleak in mac_hlist initialization
Date:   Mon, 16 Dec 2019 18:45:49 +0100
Message-Id: <20191216174851.465350278@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
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
index 8996ebbd222e0..26ba18ea08c6a 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -714,6 +714,10 @@ static int adapter_up(struct adapter *adapter)
 
 		if (adapter->flags & USING_MSIX)
 			name_msix_vecs(adapter);
+
+		/* Initialize hash mac addr list*/
+		INIT_LIST_HEAD(&adapter->mac_hlist);
+
 		adapter->flags |= FULL_INIT_DONE;
 	}
 
@@ -739,8 +743,6 @@ static int adapter_up(struct adapter *adapter)
 	enable_rx(adapter);
 	t4vf_sge_start(adapter);
 
-	/* Initialize hash mac addr list*/
-	INIT_LIST_HEAD(&adapter->mac_hlist);
 	return 0;
 }
 
-- 
2.20.1



