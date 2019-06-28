Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B11C85A45F
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 20:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbfF1Smd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 14:42:33 -0400
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:48135 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726497AbfF1Smd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 14:42:33 -0400
Received: from [4.30.142.84] (helo=[127.0.1.1])
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1hgvpQ-000SxN-5G; Fri, 28 Jun 2019 14:42:32 -0400
Subject: [4.19.y PATCH 2/3] ip_sockglue: Fix missing-check bug in
 ip_ra_control()
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
To:     stable@vger.kernel.org, gregkh@linuxfoundation.org
Cc:     Gen Zhang <blackgod016574@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, akaher@vmware.com,
        srinidhir@vmware.com, bvikas@vmware.com, amakhalov@vmware.com,
        srivatsab@vmware.com, srivatsa@csail.mit.edu
Date:   Fri, 28 Jun 2019 11:42:30 -0700
Message-ID: <156174734089.34985.7694357051190385114.stgit@srivatsa-ubuntu>
In-Reply-To: <156174726746.34985.1890238158382638220.stgit@srivatsa-ubuntu>
References: <156174726746.34985.1890238158382638220.stgit@srivatsa-ubuntu>
User-Agent: StGit/0.18
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gen Zhang <blackgod016574@gmail.com>

commit 425aa0e1d01513437668fa3d4a971168bbaa8515 upstream.

In function ip_ra_control(), the pointer new_ra is allocated a memory
space via kmalloc(). And it is used in the following codes. However,
when  there is a memory allocation error, kmalloc() fails. Thus null
pointer dereference may happen. And it will cause the kernel to crash.
Therefore, we should check the return value and handle the error.

Signed-off-by: Gen Zhang <blackgod016574@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
---

 net/ipv4/ip_sockglue.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
index b7a2612..faaf688 100644
--- a/net/ipv4/ip_sockglue.c
+++ b/net/ipv4/ip_sockglue.c
@@ -343,6 +343,8 @@ int ip_ra_control(struct sock *sk, unsigned char on,
 		return -EINVAL;
 
 	new_ra = on ? kmalloc(sizeof(*new_ra), GFP_KERNEL) : NULL;
+	if (on && !new_ra)
+		return -ENOMEM;
 
 	mutex_lock(&net->ipv4.ra_mutex);
 	for (rap = &net->ipv4.ra_chain;

