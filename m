Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 703B7111FD6
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbfLCWjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:39:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:49298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727850AbfLCWjT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:39:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4BDE207DD;
        Tue,  3 Dec 2019 22:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412758;
        bh=4Hi7puFYa9ZD/tWeZe+cdHnTgvx3uxgPBqtlp1x6mX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sEEJmQkr85TyA++YBeasVmLoubQC4/Did/d5PNzK3B58xG3bTlgQidmJ1SKQ6ILrw
         jlqR1AvDZDaOn5nzk/3poWHpBEvSsVcM7YjZXj6nvuqiDvHYs5+fRcv79ncaEonFon
         COLKqeTTAD7CybjZWLJgqED50rVwFv+pEkw7cTU0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeroen de Borst <jeroendb@google.com>,
        Catherine Sullivan <csully@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 16/46] gve: Fix the queue page list allocated pages count
Date:   Tue,  3 Dec 2019 23:35:36 +0100
Message-Id: <20191203212733.526080403@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203212705.175425505@linuxfoundation.org>
References: <20191203212705.175425505@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeroen de Borst <jeroendb@google.com>

[ Upstream commit a95069ecb7092d03b2ea1c39ee04514fe9627540 ]

In gve_alloc_queue_page_list(), when a page allocation fails,
qpl->num_entries will be wrong.  In this case priv->num_registered_pages
can underflow in gve_free_queue_page_list(), causing subsequent calls
to gve_alloc_queue_page_list() to fail.

Fixes: f5cedc84a30d ("gve: Add transmit and receive support")
Signed-off-by: Jeroen de Borst <jeroendb@google.com>
Reviewed-by: Catherine Sullivan <csully@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/google/gve/gve_main.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -544,7 +544,7 @@ static int gve_alloc_queue_page_list(str
 	}
 
 	qpl->id = id;
-	qpl->num_entries = pages;
+	qpl->num_entries = 0;
 	qpl->pages = kvzalloc(pages * sizeof(*qpl->pages), GFP_KERNEL);
 	/* caller handles clean up */
 	if (!qpl->pages)
@@ -562,6 +562,7 @@ static int gve_alloc_queue_page_list(str
 		/* caller handles clean up */
 		if (err)
 			return -ENOMEM;
+		qpl->num_entries++;
 	}
 	priv->num_registered_pages += pages;
 


