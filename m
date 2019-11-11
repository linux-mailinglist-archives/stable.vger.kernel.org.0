Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AAA0F7AD9
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727208AbfKKSaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:30:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:46522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727192AbfKKSaP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:30:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74D86214E0;
        Mon, 11 Nov 2019 18:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497015;
        bh=/6P89LKFLnV4atW4E8l4Q+dc5K4YUqiskhCGJJztcIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y7+XGVwGSOeKCARDsNX+i8MT/vNNtf7o1No53RjdzZy9iv+0KMGuDNtTqqRl8Ssl3
         a1Co835krVbSUPkCuvU+C067194zZWGFOAI9DEBRvAWB4skrMM+YR34A0ZDxk/89hC
         JhM8Beiq+fO0wdw330x9UjJ1wei9cpLwMGdoxVK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: [PATCH 4.4 17/43] netfilter: ipset: Fix an error code in ip_set_sockfn_get()
Date:   Mon, 11 Nov 2019 19:28:31 +0100
Message-Id: <20191111181307.797092015@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181246.772983347@linuxfoundation.org>
References: <20191111181246.772983347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 30b7244d79651460ff114ba8f7987ed94c86b99a upstream.

The copy_to_user() function returns the number of bytes remaining to be
copied.  In this code, that positive return is checked at the end of the
function and we return zero/success.  What we should do instead is
return -EFAULT.

Fixes: a7b4f989a629 ("netfilter: ipset: IP set core support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/ipset/ip_set_core.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1930,8 +1930,9 @@ ip_set_sockfn_get(struct sock *sk, int o
 		}
 
 		req_version->version = IPSET_PROTOCOL;
-		ret = copy_to_user(user, req_version,
-				   sizeof(struct ip_set_req_version));
+		if (copy_to_user(user, req_version,
+				 sizeof(struct ip_set_req_version)))
+			ret = -EFAULT;
 		goto done;
 	}
 	case IP_SET_OP_GET_BYNAME: {
@@ -1988,7 +1989,8 @@ ip_set_sockfn_get(struct sock *sk, int o
 	}	/* end of switch(op) */
 
 copy:
-	ret = copy_to_user(user, data, copylen);
+	if (copy_to_user(user, data, copylen))
+		ret = -EFAULT;
 
 done:
 	vfree(data);


