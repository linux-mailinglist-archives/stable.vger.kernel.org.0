Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 744B717F94C
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 13:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbgCJMz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:55:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:34246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729132AbgCJMz2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:55:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 954ED24696;
        Tue, 10 Mar 2020 12:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844928;
        bh=Rfaf0UuygPgpO1jfho2w1TZXl6bHsbmNn7hutTOKgwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XVP2nCXlPqXh7EdzMGWOeyIRNNxwV50plEOlsQbAp3r1/tiLZceyWbPC9dVL6UWou
         u0sVENGjTzDBtZczd9iUaHNXFRyZqnHrVfqYu3wViR7PGTXUctRnQkj9YPhyCIyUP/
         pzKCOG3VOHZaxgeyAMhvfr11Fh0tFLjCfQvn4tK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 152/168] RMDA/cm: Fix missing ib_cm_destroy_id() in ib_cm_insert_listen()
Date:   Tue, 10 Mar 2020 13:39:58 +0100
Message-Id: <20200310123650.898847851@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit c14dfddbd869bf0c2bafb7ef260c41d9cebbcfec upstream.

The algorithm pre-allocates a cm_id since allocation cannot be done while
holding the cm.lock spinlock, however it doesn't free it on one error
path, leading to a memory leak.

Fixes: 067b171b8679 ("IB/cm: Share listening CM IDs")
Link: https://lore.kernel.org/r/20200221152023.GA8680@ziepe.ca
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/cm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -1228,6 +1228,7 @@ struct ib_cm_id *ib_cm_insert_listen(str
 			/* Sharing an ib_cm_id with different handlers is not
 			 * supported */
 			spin_unlock_irqrestore(&cm.lock, flags);
+			ib_destroy_cm_id(cm_id);
 			return ERR_PTR(-EINVAL);
 		}
 		atomic_inc(&cm_id_priv->refcount);


