Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA3BA2E25E
	for <lists+stable@lfdr.de>; Wed, 29 May 2019 18:38:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfE2Qip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 12:38:45 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44597 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726162AbfE2Qip (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 May 2019 12:38:45 -0400
Received: by mail-pg1-f196.google.com with SMTP id n2so200834pgp.11;
        Wed, 29 May 2019 09:38:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Md0Md0Gh/CU86kMW6YbhAT59kB2A6OWx7FClQOVFvtM=;
        b=Qsali9D+TffSYLFQ2imuiwlyLcK0M4JOEkU5SJpTgUjrlbg0cUCWktjp9pOFbvAXbS
         qRl/ydiAFEI/jT6vB5a6fIuBjFVpoyxvsk9KTYiHvTgjLrLtzoGHjB4ET7HfQrJ4zamX
         A90bh4OHfRfIGoUPe0r6RP8JNZoiv+ua88fyfhOY8CoMLIkakpyE8lGjs3Xbgzs04GaT
         uXF9VWGKBatymmEBU49WgNG5dtBrZDTCZ5+pdYd8bDT4evONe1aw+mSWtAXDcRlv4loX
         T8KvVhgTxobWN53I72I4cQQw2XvkoeMW/7Ytot2cn0mUqe+0+KBmYNDPaqU1ce9lY7ue
         ZwcA==
X-Gm-Message-State: APjAAAWA0i3jlYNR6BS4+3Qdg4YWwtCu7dAKve/R/sW5fuQF8lsNbcEO
        7K2pu9jLAFmweWdkLKld/ao=
X-Google-Smtp-Source: APXvYqwJuDpY32lXK+AajkeL/hf57btq1bSomACItiCccwmMewSej6T9bejwCIsffagTqOUXLYNbVw==
X-Received: by 2002:a62:e217:: with SMTP id a23mr106414568pfi.128.1559147919993;
        Wed, 29 May 2019 09:38:39 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id i101sm166450pje.9.2019.05.29.09.38.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 09:38:39 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Laurence Oberman <loberman@redhat.com>, stable@vger.kernel.org
Subject: [PATCH, RESEND] RDMA/srp: Accept again source addresses that do not have a port number
Date:   Wed, 29 May 2019 09:38:31 -0700
Message-Id: <20190529163831.138926-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.20.GIT
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The function srp_parse_in() is used both for parsing source address
specifications and for target address specifications. Target addresses
must have a port number. Having to specify a port number for source
addresses is inconvenient. Make sure that srp_parse_in() supports again
parsing addresses with no port number.

Cc: Laurence Oberman <loberman@redhat.com>
Cc: <stable@vger.kernel.org>
Fixes: c62adb7def71 ("IB/srp: Fix IPv6 address parsing") # v4.17.
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

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
-- 
2.22.0.rc1

