Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE6A126D0A
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbfLSSmW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:42:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:33496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728668AbfLSSmV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:42:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE9D524672;
        Thu, 19 Dec 2019 18:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780941;
        bh=T7u2irnWSC/2m8h2ZdstuWwYRqy/ABA0atxUzbDIXpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CD7Efqp6H7ussMLoUvdjtFSwZAub7kRvAQTxNv8UK2FDiZbNfb9ofvyQYfdA3UClL
         1ypMLfJDC+dMGss6K1n0EFQv4SCsjvw1rDr5VbKMOGlGWU0s+rW++VmUu5Fucv6eRc
         QvqxqJkvRw4xjKK9eaurbVG1nN0AOoonZyIxqDDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arjun Vynipadath <arjun@chelsio.com>,
        Ganesh Goudar <ganeshgr@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 018/199] cxgb4vf: fix memleak in mac_hlist initialization
Date:   Thu, 19 Dec 2019 19:31:40 +0100
Message-Id: <20191219183215.800062634@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
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
index a37481c04a87b..9eb3071b69a42 100644
--- a/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
+++ b/drivers/net/ethernet/chelsio/cxgb4vf/cxgb4vf_main.c
@@ -718,6 +718,10 @@ static int adapter_up(struct adapter *adapter)
 
 		if (adapter->flags & USING_MSIX)
 			name_msix_vecs(adapter);
+
+		/* Initialize hash mac addr list*/
+		INIT_LIST_HEAD(&adapter->mac_hlist);
+
 		adapter->flags |= FULL_INIT_DONE;
 	}
 
@@ -743,8 +747,6 @@ static int adapter_up(struct adapter *adapter)
 	enable_rx(adapter);
 	t4vf_sge_start(adapter);
 
-	/* Initialize hash mac addr list*/
-	INIT_LIST_HEAD(&adapter->mac_hlist);
 	return 0;
 }
 
-- 
2.20.1



