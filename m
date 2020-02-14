Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA79915E136
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404523AbgBNQRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:17:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404518AbgBNQRi (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:17:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84FFE246EB;
        Fri, 14 Feb 2020 16:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581697057;
        bh=kRP+y3HcithTsJIOcW8CMWya+y7N06/9CyauDLJGA84=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqC7RWrasEjQ2dXNmUBjTX++r19BavlQpjH9FME4wg1Glc1PUT/W7c1ukzm+TJFfn
         wDryAIoLo5p6OETN9V7SbsS08GE6L2QsxSgZy9qqL73aqs7ay/nN1puA+RZQJT7Gpx
         HS7/m6jEtT142UtXpZ42I+1qhxu1Cif0tKRYXyAo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Mark Haywood <mark.haywood@oracle.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 016/186] RDMA/netlink: Do not always generate an ACK for some netlink operations
Date:   Fri, 14 Feb 2020 11:14:25 -0500
Message-Id: <20200214161715.18113-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214161715.18113-1-sashal@kernel.org>
References: <20200214161715.18113-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Håkon Bugge <haakon.bugge@oracle.com>

[ Upstream commit a242c36951ecd24bc16086940dbe6b522205c461 ]

In rdma_nl_rcv_skb(), the local variable err is assigned the return value
of the supplied callback function, which could be one of
ib_nl_handle_resolve_resp(), ib_nl_handle_set_timeout(), or
ib_nl_handle_ip_res_resp(). These three functions all return skb->len on
success.

rdma_nl_rcv_skb() is merely a copy of netlink_rcv_skb(). The callback
functions used by the latter have the convention: "Returns 0 on success or
a negative error code".

In particular, the statement (equal for both functions):

   if (nlh->nlmsg_flags & NLM_F_ACK || err)

implies that rdma_nl_rcv_skb() always will ack a message, independent of
the NLM_F_ACK being set in nlmsg_flags or not.

The fix could be to change the above statement, but it is better to keep
the two *_rcv_skb() functions equal in this respect and instead change the
three callback functions in the rdma subsystem to the correct convention.

Fixes: 2ca546b92a02 ("IB/sa: Route SA pathrecord query through netlink")
Fixes: ae43f8286730 ("IB/core: Add IP to GID netlink offload")
Link: https://lore.kernel.org/r/20191216120436.3204814-1-haakon.bugge@oracle.com
Suggested-by: Mark Haywood <mark.haywood@oracle.com>
Signed-off-by: Håkon Bugge <haakon.bugge@oracle.com>
Tested-by: Mark Haywood <mark.haywood@oracle.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/addr.c     | 2 +-
 drivers/infiniband/core/sa_query.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index aadaa9e84eeea..c2bbe0df0931c 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -140,7 +140,7 @@ int ib_nl_handle_ip_res_resp(struct sk_buff *skb,
 	if (ib_nl_is_good_ip_resp(nlh))
 		ib_nl_process_good_ip_rsep(nlh);
 
-	return skb->len;
+	return 0;
 }
 
 static int ib_nl_ip_send_msg(struct rdma_dev_addr *dev_addr,
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 50068b0a91fa4..83dad5401c932 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1078,7 +1078,7 @@ int ib_nl_handle_set_timeout(struct sk_buff *skb,
 	}
 
 settimeout_out:
-	return skb->len;
+	return 0;
 }
 
 static inline int ib_nl_is_good_resolve_resp(const struct nlmsghdr *nlh)
@@ -1149,7 +1149,7 @@ int ib_nl_handle_resolve_resp(struct sk_buff *skb,
 	}
 
 resp_out:
-	return skb->len;
+	return 0;
 }
 
 static void free_sm_ah(struct kref *kref)
-- 
2.20.1

