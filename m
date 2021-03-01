Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B63C0329122
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:23:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235495AbhCAUT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:19:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:40906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242999AbhCAUNW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:13:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F338465062;
        Mon,  1 Mar 2021 18:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621690;
        bh=Ot42q7Y638tuh+QNwlF33dG+EhFDcDtlt1XeUKnPln8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xkKlcXm0Bqw+n8jHLEQU7YKdd3I1n6nAArYrPKT8Z84kcrzp7rde6pvMn+EMVJvFt
         /xoO/c5GUNbjTj9+Dsjv9W6h6IsPru3CoXiH9WntZsYxaZRDSJexI9qFOJvIVZTt7U
         xm1D3jho6woKPLJA0IpZa4ukHWN5o1C06fNz8HWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Kai Krakow <kai@kaishome.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.11 609/775] bcache: Give btree_io_wq correct semantics again
Date:   Mon,  1 Mar 2021 17:12:57 +0100
Message-Id: <20210301161231.510448255@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Krakow <kai@kaishome.de>

commit d797bd9897e3559eb48d68368550d637d32e468c upstream.

Before killing `btree_io_wq`, the queue was allocated using
`create_singlethread_workqueue()` which has `WQ_MEM_RECLAIM`. After
killing it, it no longer had this property but `system_wq` is not
single threaded.

Let's combine both worlds and make it multi threaded but able to
reclaim memory.

Cc: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org # 5.4+
Signed-off-by: Kai Krakow <kai@kaishome.de>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/btree.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -2775,7 +2775,7 @@ void bch_btree_exit(void)
 
 int __init bch_btree_init(void)
 {
-	btree_io_wq = create_singlethread_workqueue("bch_btree_io");
+	btree_io_wq = alloc_workqueue("bch_btree_io", WQ_MEM_RECLAIM, 0);
 	if (!btree_io_wq)
 		return -ENOMEM;
 


