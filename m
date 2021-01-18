Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3D52F9EB5
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390901AbhARLuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:50:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390788AbhARLqt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:46:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC13522472;
        Mon, 18 Jan 2021 11:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970392;
        bh=HD219p2bjaksFPf8izzghIpIbKQvW3YpDH4Gm8+FzAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBvpxxaYh7LLdLnKacjZm4C5MUihN3s306G0ox7LiCM0Kcj09isC/LUKt9Aoes7jX
         YW5GgdgVOBz0QXhGTngfZlziceZbTXyrMCQwjoffwcie0SgYTHV5O1Y8YUJcd2EYeE
         QojGC37NaWdBq5rkd+0yFGU3DqopJNMeZmelyhI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 133/152] RDMA/restrack: Dont treat as an error allocation ID wrapping
Date:   Mon, 18 Jan 2021 12:35:08 +0100
Message-Id: <20210118113359.099475996@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

commit 3c638cdb8ecc0442552156e0fed8708dd2c7f35b upstream.

xa_alloc_cyclic() call returns positive number if ID allocation
succeeded but wrapped. It is not an error, so normalize the "ret"
variable to zero as marker of not-an-error.

   drivers/infiniband/core/restrack.c:261 rdma_restrack_add()
   warn: 'ret' can be either negative or positive

Fixes: fd47c2f99f04 ("RDMA/restrack: Convert internal DB from hash to XArray")
Link: https://lore.kernel.org/r/20201216100753.1127638-1-leon@kernel.org
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/restrack.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -244,6 +244,7 @@ void rdma_restrack_add(struct rdma_restr
 	} else {
 		ret = xa_alloc_cyclic(&rt->xa, &res->id, res, xa_limit_32b,
 				      &rt->next_id, GFP_KERNEL);
+		ret = (ret < 0) ? ret : 0;
 	}
 
 	if (!ret)


