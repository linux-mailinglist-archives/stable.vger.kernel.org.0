Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E47F815C471
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgBMPrW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:47:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728105AbgBMP1G (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:06 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 753F4218AC;
        Thu, 13 Feb 2020 15:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607624;
        bh=jOzQoKaNoUzmDAcE2f1lJ1Vju69MQpsJT9S2YdQl15U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mb+3vlMfqndt4S9nvvJOReStQdiC9Ui4LrC98OeYEhX8lmz7sh5GyYpAbhzuM2+Eb
         Yk+UAHp2M0E4Y0rEzkEeR6Kw9Zg1h58B7tVQtyHhrYdo6yOwVBtd0uXaqxaz3RH6hS
         1lXUD/K8qC56BzMklPDAIrXAzNQgG58BO5/C0W3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Haywood <mark.haywood@oracle.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.4 06/96] RDMA/netlink: Do not always generate an ACK for some netlink operations
Date:   Thu, 13 Feb 2020 07:20:13 -0800
Message-Id: <20200213151841.439767118@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Håkon Bugge <haakon.bugge@oracle.com>

commit a242c36951ecd24bc16086940dbe6b522205c461 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/core/addr.c     |    2 +-
 drivers/infiniband/core/sa_query.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -139,7 +139,7 @@ int ib_nl_handle_ip_res_resp(struct sk_b
 	if (ib_nl_is_good_ip_resp(nlh))
 		ib_nl_process_good_ip_rsep(nlh);
 
-	return skb->len;
+	return 0;
 }
 
 static int ib_nl_ip_send_msg(struct rdma_dev_addr *dev_addr,
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1068,7 +1068,7 @@ int ib_nl_handle_set_timeout(struct sk_b
 	}
 
 settimeout_out:
-	return skb->len;
+	return 0;
 }
 
 static inline int ib_nl_is_good_resolve_resp(const struct nlmsghdr *nlh)
@@ -1139,7 +1139,7 @@ int ib_nl_handle_resolve_resp(struct sk_
 	}
 
 resp_out:
-	return skb->len;
+	return 0;
 }
 
 static void free_sm_ah(struct kref *kref)


