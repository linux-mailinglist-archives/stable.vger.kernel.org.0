Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A2E35BD68
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238127AbhDLIvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:51:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238213AbhDLItK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:49:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D37B61019;
        Mon, 12 Apr 2021 08:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217287;
        bh=3uQwXTnB51AhzbCwL+mQ0uXvVC+Y3YgNCYT6lLwsrZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gZMgPhjwAfGf/6k5uHOImtK0zTks5BtiuMR9msQOxnXi77+YIFPjUHqPn3mHskiMm
         yxlMj1D5t+cllowiHuyy/jsBOionNdiowvmFP9k10D2a30b2e0buXhqhEgabVb/tOB
         EEenB2tBhi6SXGWrZjPf+6+PHauqkt6vqUVBjJg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/111] net/rds: Fix a use after free in rds_message_map_pages
Date:   Mon, 12 Apr 2021 10:40:49 +0200
Message-Id: <20210412084006.637894017@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit bdc2ab5c61a5c07388f4820ff21e787b4dfd1ced ]

In rds_message_map_pages, the rm is freed by rds_message_put(rm).
But rm is still used by rm->data.op_sg in return value.

My patch assigns ERR_CAST(rm->data.op_sg) to err before the rm is
freed to avoid the uaf.

Fixes: 7dba92037baf3 ("net/rds: Use ERR_PTR for rds_message_alloc_sgs()")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/message.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/rds/message.c b/net/rds/message.c
index 2d43e13d6dd5..92b6b22884d4 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -347,8 +347,9 @@ struct rds_message *rds_message_map_pages(unsigned long *page_addrs, unsigned in
 	rm->data.op_nents = DIV_ROUND_UP(total_len, PAGE_SIZE);
 	rm->data.op_sg = rds_message_alloc_sgs(rm, num_sgs);
 	if (IS_ERR(rm->data.op_sg)) {
+		void *err = ERR_CAST(rm->data.op_sg);
 		rds_message_put(rm);
-		return ERR_CAST(rm->data.op_sg);
+		return err;
 	}
 
 	for (i = 0; i < rm->data.op_nents; ++i) {
-- 
2.30.2



