Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1276373C98
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404614AbfGXT64 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405004AbfGXT6y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:58:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CB6A120665;
        Wed, 24 Jul 2019 19:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998333;
        bh=CyBCEbDBz1BSAcBzsXW89LRvaF7GfCsGEVdKEaDP2d8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f7LOulmn+CT1sEy1HaIUJ1t/ar2VFZ/rnOkHfL3JSC6Ys6PTut9im4sYtPqE8t5A5
         MpUYHfMKJvGuz6IapA+40xbDlaSdJiy2SMRyhLk6yuAHI5Dhwn6f7Z/G0BLGZqfW1Y
         1e5rhc7pWvEOEcQ70y0w3F6vqfOlD+v8NywtWZBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.1 328/371] RDMA/srp: Accept again source addresses that do not have a port number
Date:   Wed, 24 Jul 2019 21:21:20 +0200
Message-Id: <20190724191748.507692141@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

commit bcef5b7215681250c4bf8961dfe15e9e4fef97d0 upstream.

The function srp_parse_in() is used both for parsing source address
specifications and for target address specifications. Target addresses
must have a port number. Having to specify a port number for source
addresses is inconvenient. Make sure that srp_parse_in() supports again
parsing addresses with no port number.

Cc: <stable@vger.kernel.org>
Fixes: c62adb7def71 ("IB/srp: Fix IPv6 address parsing")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/ulp/srp/ib_srp.c |   21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3481,13 +3481,14 @@ static const match_table_t srp_opt_token
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
@@ -3496,9 +3497,12 @@ static int srp_parse_in(struct net *net,
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
@@ -3520,6 +3524,7 @@ static int srp_parse_options(struct net
 	char *p;
 	substring_t args[MAX_OPT_ARGS];
 	unsigned long long ull;
+	bool has_port;
 	int opt_mask = 0;
 	int token;
 	int ret = -EINVAL;
@@ -3618,7 +3623,8 @@ static int srp_parse_options(struct net
 				ret = -ENOMEM;
 				goto out;
 			}
-			ret = srp_parse_in(net, &target->rdma_cm.src.ss, p);
+			ret = srp_parse_in(net, &target->rdma_cm.src.ss, p,
+					   NULL);
 			if (ret < 0) {
 				pr_warn("bad source parameter '%s'\n", p);
 				kfree(p);
@@ -3634,7 +3640,10 @@ static int srp_parse_options(struct net
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


