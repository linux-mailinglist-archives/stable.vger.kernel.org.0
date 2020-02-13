Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0319A15C1FC
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:28:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729541AbgBMP2D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:28:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:54040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728280AbgBMP2C (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:02 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 311AD20661;
        Thu, 13 Feb 2020 15:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607682;
        bh=jOzQoKaNoUzmDAcE2f1lJ1Vju69MQpsJT9S2YdQl15U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yK71ba9IqR0fAa3OdcIy8bB9ANmaQvC1nVF1eNKPZYaGo7nReApyu/UEdJUMo441n
         SdRnOwLrEDvhE9UJYehmovNI7EYAEd38enD8SMAhU34wMMF7oGVkkeFflD1Gy41tn2
         eo8aW3nHR3To4f6Gv6YNqiVBOrv9I2bXvOSVEagM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Haywood <mark.haywood@oracle.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 005/120] RDMA/netlink: Do not always generate an ACK for some netlink operations
Date:   Thu, 13 Feb 2020 07:20:01 -0800
Message-Id: <20200213151903.095079526@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
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


