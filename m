Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D3C8622DB
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389530AbfGHP3k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:29:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:58532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389525AbfGHP3j (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:29:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A8BCA21537;
        Mon,  8 Jul 2019 15:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562599779;
        bh=IXYegOQdh8W66Esya2jE5jhePux88Z2Un7Hwk2T2SAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VEiTPdbCbV6yapMfaFgkR81wtjkRiYLVFyGokh4rmv5e+FL4o/q6WEMQC09SKekV8
         Kn+nSbnrRzQ4itLvW/F40j2Z0S5dix7UEcM3rFLqIo0YOx/q1lfhc6AOsZizwuxRrT
         /fxymOTZ4TBgSwqAQ4+92o+XRAzx5Zd4QKyhxpfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 75/90] rds: Fix warning.
Date:   Mon,  8 Jul 2019 17:13:42 +0200
Message-Id: <20190708150526.123716819@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150521.829733162@linuxfoundation.org>
References: <20190708150521.829733162@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit d84e7bc0595a7e146ad0ddb80b240cea77825245 ]

>> net/rds/send.c:1109:42: warning: Using plain integer as NULL pointer

Fixes: ea010070d0a7 ("net/rds: fix warn in rds_message_alloc_sgs")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/send.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/rds/send.c b/net/rds/send.c
index ec2267cbf85f..26e2c2305f7a 100644
--- a/net/rds/send.c
+++ b/net/rds/send.c
@@ -1106,9 +1106,11 @@ int rds_sendmsg(struct socket *sock, struct msghdr *msg, size_t payload_len)
 		      sock_flag(rds_rs_to_sk(rs), SOCK_ZEROCOPY));
 	int num_sgs = ceil(payload_len, PAGE_SIZE);
 	int namelen;
-	struct rds_iov_vector_arr vct = {0};
+	struct rds_iov_vector_arr vct;
 	int ind;
 
+	memset(&vct, 0, sizeof(vct));
+
 	/* expect 1 RDMA CMSG per rds_sendmsg. can still grow if more needed. */
 	vct.incr = 1;
 
-- 
2.20.1



