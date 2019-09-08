Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3E82ACE08
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731739AbfIHMtt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:40042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731719AbfIHMts (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:49:48 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 940AF21A4A;
        Sun,  8 Sep 2019 12:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946988;
        bh=UInMLA7CFEkckbHgViyrgOpN41KrT2K8pBfDhmGfCcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0g4qHtNAgT5GkUBs9Yi75SFqA3W56bfnYiLs4Uy8TWU9PbOd20hZxSBOOwut0pmQ
         z3Yn5n0zRkAlRj5APjnB2Dy1ns1U/NOa8sSdDmHoR32EZi8/DX2M+o6YrMgC/Phz/A
         RilOjW/Ep0fwEv02GQqmM0nkcKjW4qDVcmn90Bps=
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
Subject: [PATCH 5.2 19/94] net/rds: Fix info leak in rds6_inc_info_copy()
Date:   Sun,  8 Sep 2019 13:41:15 +0100
Message-Id: <20190908121150.989665197@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
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
@@ -811,6 +811,7 @@ void rds6_inc_info_copy(struct rds_incom
 
 	minfo6.seq = be64_to_cpu(inc->i_hdr.h_sequence);
 	minfo6.len = be32_to_cpu(inc->i_hdr.h_len);
+	minfo6.tos = inc->i_conn->c_tos;
 
 	if (flip) {
 		minfo6.laddr = *daddr;
@@ -824,6 +825,8 @@ void rds6_inc_info_copy(struct rds_incom
 		minfo6.fport = inc->i_hdr.h_dport;
 	}
 
+	minfo6.flags = 0;
+
 	rds_info_copy(iter, &minfo6, sizeof(minfo6));
 }
 #endif


