Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA2071793
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 13:57:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730821AbfGWL5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 07:57:37 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:59891 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728418AbfGWL5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 07:57:37 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 902F659F;
        Tue, 23 Jul 2019 07:57:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 23 Jul 2019 07:57:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=5uxu9s
        9NEh60fNO55TogxrkKQT7I1KFslD+m6kWSnQc=; b=UjGB938sLAg7C/Tmt56rg0
        L8l+9lQ6XIKSokEym9NXHi6GPV6QP9wjFZ+/fZr49rUqsqYRM+LbNkAWnMG6EaUO
        TfDQ97LJreTGNzY5BJSVP4FQTVZW+ABrCmihHXuTbe8AY6+fYeKGtbQqHN87SLwz
        QYq2PHD45ngaQuIfuyo+P/9ZmixZPLQmUpMhK5aj1y7iyiWNnTlboY5+415T85R8
        qxALQcmMf0FoJ5j5k397U3GHQvY0dcJfEpvRsiYOvfn7y84OmtfskN095Arx/VDE
        z7Ve/1gfCxUo712BC7mkK8LJzaXsJazRJY2D/C1g27pDdl4lyAwXPSOULdlwHBog
        ==
X-ME-Sender: <xms:L_Y2XaoYoSh0XhYSnrK5hrF5vKGoZ415260ML_JzvqK8neYSmoQt0A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrjeekgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepshhrtgdrshhspdgushhtrdhsshenucfkphepkeefrdekiedrke
    elrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtgho
    mhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:L_Y2XZNiaYGNja3ZO0sLEXgAE9SAGHvquaPBn1hhslpiWjuUVZeM1g>
    <xmx:L_Y2XYE5lXohRHU3uPQi0z2XR5CMJpbt10pXpZA6CBnzMyVx5sKVPg>
    <xmx:L_Y2XUGuaUzxgP4bUc2vCNBBtcb_FTOexPlH1vm4eqs3LEt9tSA1Gw>
    <xmx:MPY2XZFgmkzPxwDMdTGpl0g1wGf7ZQI-G66d3LLHwbz4Vk-BTOMFAg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8802A8005C;
        Tue, 23 Jul 2019 07:57:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] RDMA/srp: Accept again source addresses that do not have a" failed to apply to 4.19-stable tree
To:     bvanassche@acm.org, jgg@mellanox.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 23 Jul 2019 13:57:34 +0200
Message-ID: <156388305418150@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bcef5b7215681250c4bf8961dfe15e9e4fef97d0 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 29 May 2019 09:38:31 -0700
Subject: [PATCH] RDMA/srp: Accept again source addresses that do not have a
 port number

The function srp_parse_in() is used both for parsing source address
specifications and for target address specifications. Target addresses
must have a port number. Having to specify a port number for source
addresses is inconvenient. Make sure that srp_parse_in() supports again
parsing addresses with no port number.

Cc: <stable@vger.kernel.org>
Fixes: c62adb7def71 ("IB/srp: Fix IPv6 address parsing")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index be9ddcad8f28..87848faa7502 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3481,13 +3481,14 @@ static const match_table_t srp_opt_tokens = {
  * @net:	   [in]  Network namespace.
  * @sa:		   [out] Address family, IP address and port number.
  * @addr_port_str: [in]  IP address and port number.
+ * @has_port:	   [out] Whether or not @addr_port_str includes a port number.
  *
  * Parse the following address formats:
  * - IPv4: <ip_address>:<port>, e.g. 1.2.3.4:5.
  * - IPv6: \[<ipv6_address>\]:<port>, e.g. [1::2:3%4]:5.
  */
 static int srp_parse_in(struct net *net, struct sockaddr_storage *sa,
-			const char *addr_port_str)
+			const char *addr_port_str, bool *has_port)
 {
 	char *addr_end, *addr = kstrdup(addr_port_str, GFP_KERNEL);
 	char *port_str;
@@ -3496,9 +3497,12 @@ static int srp_parse_in(struct net *net, struct sockaddr_storage *sa,
 	if (!addr)
 		return -ENOMEM;
 	port_str = strrchr(addr, ':');
-	if (!port_str)
-		return -EINVAL;
-	*port_str++ = '\0';
+	if (port_str && strchr(port_str, ']'))
+		port_str = NULL;
+	if (port_str)
+		*port_str++ = '\0';
+	if (has_port)
+		*has_port = port_str != NULL;
 	ret = inet_pton_with_scope(net, AF_INET, addr, port_str, sa);
 	if (ret && addr[0]) {
 		addr_end = addr + strlen(addr) - 1;
@@ -3520,6 +3524,7 @@ static int srp_parse_options(struct net *net, const char *buf,
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
 	unsigned long long ull;
+	bool has_port;
 	int opt_mask = 0;
 	int token;
 	int ret = -EINVAL;
@@ -3618,7 +3623,8 @@ static int srp_parse_options(struct net *net, const char *buf,
 				ret = -ENOMEM;
 				goto out;
 			}
-			ret = srp_parse_in(net, &target->rdma_cm.src.ss, p);
+			ret = srp_parse_in(net, &target->rdma_cm.src.ss, p,
+					   NULL);
 			if (ret < 0) {
 				pr_warn("bad source parameter '%s'\n", p);
 				kfree(p);
@@ -3634,7 +3640,10 @@ static int srp_parse_options(struct net *net, const char *buf,
 				ret = -ENOMEM;
 				goto out;
 			}
-			ret = srp_parse_in(net, &target->rdma_cm.dst.ss, p);
+			ret = srp_parse_in(net, &target->rdma_cm.dst.ss, p,
+					   &has_port);
+			if (!has_port)
+				ret = -EINVAL;
 			if (ret < 0) {
 				pr_warn("bad dest parameter '%s'\n", p);
 				kfree(p);

