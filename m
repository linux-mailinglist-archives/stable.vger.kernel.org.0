Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C4B01C44F5
	for <lists+stable@lfdr.de>; Mon,  4 May 2020 20:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731626AbgEDSEG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 May 2020 14:04:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:33322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731622AbgEDSEF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 May 2020 14:04:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E13C2073B;
        Mon,  4 May 2020 18:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588615444;
        bh=ci47eiWNLUFZvk28Ty4nu5g7RfATAgZzgBWRl7eZKRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sCT+9u6P7EANU8vVlUm7kScI3m1yj3t+xpCIiYjyVbyOfLFuyCumWd0cwcnMmjriF
         vw6oCX/p3j3zNTFyweT4TJ9JPpDrkUwGAsNgcDSAekuZpYPvYt+wunG/G60zaKtk1r
         2n9bV+QNorG1l3z08UUdyJSo1x/Sh2q3H7CuQ1ME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 42/57] RDMA/cm: Fix an error check in cm_alloc_id_priv()
Date:   Mon,  4 May 2020 19:57:46 +0200
Message-Id: <20200504165459.974554129@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200504165456.783676004@linuxfoundation.org>
References: <20200504165456.783676004@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 983653515849fb56b78ce55d349bb384d43030f6 upstream.

The xa_alloc_cyclic_irq() function returns either 0 or 1 on success and
negatives on error.  This code treats 1 as an error and returns ERR_PTR(1)
which will cause an Oops in the caller.

Fixes: ae78ff3a0f0c ("RDMA/cm: Convert local_id_table to XArray")
Link: https://lore.kernel.org/r/20200407093714.GA80285@mwanda
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/cm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -873,7 +873,7 @@ struct ib_cm_id *ib_create_cm_id(struct
 
 	ret = xa_alloc_cyclic_irq(&cm.local_id_table, &id, NULL, xa_limit_32b,
 				  &cm.local_id_next, GFP_KERNEL);
-	if (ret)
+	if (ret < 0)
 		goto error;
 	cm_id_priv->id.local_id = (__force __be32)id ^ cm.random_id_operand;
 	xa_store_irq(&cm.local_id_table, cm_local_id(cm_id_priv->id.local_id),


