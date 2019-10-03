Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C41BCAA99
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393422AbfJCRJh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 13:09:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:42316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731952AbfJCQeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:34:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12F2C2133F;
        Thu,  3 Oct 2019 16:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120443;
        bh=WfxDNclaPwQMRAUKsE1cmWMDs3Yv+dnYyxNB+8LnBpk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JNFTW0ZbNzTVdaXx9IC30sUcfTqhrAy4QqOG4NNf3zL7DVUUY+QmcXjP0acKtfZUm
         HH8QPXYtwUmsXFA/ey7nZDYm4DKDbHg/Wh6yy/xbtfUq4zPVHW2tPxmXM8Zb/GX+oU
         ALfGzejVIhEGWRr4tnz47c2ov5A6X8wjFUtyDpgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jack Morgenstein <jackm@dev.mellanox.co.il>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.2 224/313] RDMA: Fix double-free in srq creation error flow
Date:   Thu,  3 Oct 2019 17:53:22 +0200
Message-Id: <20191003154555.095265867@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Morgenstein <jackm@dev.mellanox.co.il>

commit 3eca7fc2d8d1275d9cf0c709f0937becbfcf6d96 upstream.

The cited commit introduced a double-free of the srq buffer in the error
flow of procedure __uverbs_create_xsrq().

The problem is that ib_destroy_srq_user() called in the error flow also
frees the srq buffer.

Thus, if uverbs_response() fails in __uverbs_create_srq(), the srq buffer
will be freed twice.

Cc: <stable@vger.kernel.org>
Fixes: 68e326dea1db ("RDMA: Handle SRQ allocations by IB/core")
Link: https://lore.kernel.org/r/20190916071154.20383-5-leon@kernel.org
Signed-off-by: Jack Morgenstein <jackm@dev.mellanox.co.il>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/uverbs_cmd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3477,7 +3477,8 @@ static int __uverbs_create_xsrq(struct u
 
 err_copy:
 	ib_destroy_srq_user(srq, uverbs_get_cleared_udata(attrs));
-
+	/* It was released in ib_destroy_srq_user */
+	srq = NULL;
 err_free:
 	kfree(srq);
 err_put:


