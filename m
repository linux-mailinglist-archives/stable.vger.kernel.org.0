Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10BE2ACE51
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730900AbfIHMsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:37002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730891AbfIHMsH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:48:07 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09C83218AC;
        Sun,  8 Sep 2019 12:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946886;
        bh=LPBjogdDxQGRxl0QqqPik9edUm0vEPbU7w0GpYfhx30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nvoLUSdy/gD3PcKkQjk+U3RtZwQy8LS+47M085bW6gm56i5qZkjBSwFPEqC08p1oZ
         o3aY/0RJokaz7yC6OJNIC3ajzjZa7j54fVpO6OUnWn2hQYSgQL8JiPWFBcfz8x6Unh
         xIYQIbZzBLSWLZ3K/lGDbdOLwcrgS5c6AIFrtv/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=E9=BB=84ID=E8=9D=B4=E8=9D=B6?= 
        <butterflyhuangxx@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ka-Cheong Poon <ka-cheong.poon@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 08/57] net/rds: Fix info leak in rds6_inc_info_copy()
Date:   Sun,  8 Sep 2019 13:41:32 +0100
Message-Id: <20190908121128.197012518@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
References: <20190908121125.608195329@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ka-Cheong Poon <ka-cheong.poon@oracle.com>

[ Upstream commit 7d0a06586b2686ba80c4a2da5f91cb10ffbea736 ]

The rds6_inc_info_copy() function has a couple struct members which
are leaking stack information.  The ->tos field should hold actual
information and the ->flags field needs to be zeroed out.

Fixes: 3eb450367d08 ("rds: add type of service(tos) infrastructure")
Fixes: b7ff8b1036f0 ("rds: Extend RDS API for IPv6 support")
Reported-by: 黄ID蝴蝶 <butterflyhuangxx@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/rds/recv.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/rds/recv.c
+++ b/net/rds/recv.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2006, 2018 Oracle and/or its affiliates. All rights reserved.
+ * Copyright (c) 2006, 2019 Oracle and/or its affiliates. All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -803,6 +803,7 @@ void rds6_inc_info_copy(struct rds_incom
 
 	minfo6.seq = be64_to_cpu(inc->i_hdr.h_sequence);
 	minfo6.len = be32_to_cpu(inc->i_hdr.h_len);
+	minfo6.tos = 0;
 
 	if (flip) {
 		minfo6.laddr = *daddr;
@@ -816,6 +817,8 @@ void rds6_inc_info_copy(struct rds_incom
 		minfo6.fport = inc->i_hdr.h_dport;
 	}
 
+	minfo6.flags = 0;
+
 	rds_info_copy(iter, &minfo6, sizeof(minfo6));
 }
 #endif


