Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7857F122059
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbfLQAyQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:54:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35374 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727086AbfLQAvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:44 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0003MS-QN; Tue, 17 Dec 2019 00:51:34 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15K-0005cs-Je; Tue, 17 Dec 2019 00:51:34 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jozsef Kadlecsik" <kadlec@netfilter.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date:   Tue, 17 Dec 2019 00:47:29 +0000
Message-ID: <lsq.1576543535.460649484@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 115/136] netfilter: ipset: Fix an error code in
 ip_set_sockfn_get()
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 30b7244d79651460ff114ba8f7987ed94c86b99a upstream.

The copy_to_user() function returns the number of bytes remaining to be
copied.  In this code, that positive return is checked at the end of the
function and we return zero/success.  What we should do instead is
return -EFAULT.

Fixes: a7b4f989a629 ("netfilter: ipset: IP set core support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/netfilter/ipset/ip_set_core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/net/netfilter/ipset/ip_set_core.c
+++ b/net/netfilter/ipset/ip_set_core.c
@@ -1860,8 +1860,9 @@ ip_set_sockfn_get(struct sock *sk, int o
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
@@ -1918,7 +1919,8 @@ ip_set_sockfn_get(struct sock *sk, int o
 	}	/* end of switch(op) */
 
 copy:
-	ret = copy_to_user(user, data, copylen);
+	if (copy_to_user(user, data, copylen))
+		ret = -EFAULT;
 
 done:
 	vfree(data);

