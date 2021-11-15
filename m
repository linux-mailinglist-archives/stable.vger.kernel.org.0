Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA999451221
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:27:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238781AbhKOTaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:30:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:42218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244423AbhKOTOI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:14:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02031634B7;
        Mon, 15 Nov 2021 18:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000462;
        bh=MmKejlUk1h1XpRkaHo0b7s+0uOcH78Ok4wRnpFwKOvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qP/idTKpZyYgUkW/tb1P9WqDdtw5TOXD1aXtBH7EcNUQ/v7/FRpj5FzJ9Cz+qdigf
         vJKqDjqGlEWt8mSzZWFaHmuuiD3aghObXC8FCaCbAWtpgyA+JfQAlHPOJzUVywH6SR
         fr4YZ6RWT7z+vqkK78W9eyaB2K/CW1Et6lgnr1KQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 667/849] nfsd: dont alloc under spinlock in rpc_parse_scope_id
Date:   Mon, 15 Nov 2021 18:02:30 +0100
Message-Id: <20211115165442.828923162@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: J. Bruce Fields <bfields@redhat.com>

[ Upstream commit 9b6e27d01adcec58e046c624874f8a124e8b07ec ]

Dan Carpenter says:

  The patch d20c11d86d8f: "nfsd: Protect session creation and client
  confirm using client_lock" from Jul 30, 2014, leads to the following
  Smatch static checker warning:

        net/sunrpc/addr.c:178 rpc_parse_scope_id()
        warn: sleeping in atomic context

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: d20c11d86d8f ("nfsd: Protect session creation and client...")
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/addr.c | 40 ++++++++++++++++++----------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/net/sunrpc/addr.c b/net/sunrpc/addr.c
index 6e4dbd577a39f..d435bffc61999 100644
--- a/net/sunrpc/addr.c
+++ b/net/sunrpc/addr.c
@@ -162,8 +162,10 @@ static int rpc_parse_scope_id(struct net *net, const char *buf,
 			      const size_t buflen, const char *delim,
 			      struct sockaddr_in6 *sin6)
 {
-	char *p;
+	char p[IPV6_SCOPE_ID_LEN + 1];
 	size_t len;
+	u32 scope_id = 0;
+	struct net_device *dev;
 
 	if ((buf + buflen) == delim)
 		return 1;
@@ -175,29 +177,23 @@ static int rpc_parse_scope_id(struct net *net, const char *buf,
 		return 0;
 
 	len = (buf + buflen) - delim - 1;
-	p = kmemdup_nul(delim + 1, len, GFP_KERNEL);
-	if (p) {
-		u32 scope_id = 0;
-		struct net_device *dev;
-
-		dev = dev_get_by_name(net, p);
-		if (dev != NULL) {
-			scope_id = dev->ifindex;
-			dev_put(dev);
-		} else {
-			if (kstrtou32(p, 10, &scope_id) != 0) {
-				kfree(p);
-				return 0;
-			}
-		}
-
-		kfree(p);
-
-		sin6->sin6_scope_id = scope_id;
-		return 1;
+	if (len > IPV6_SCOPE_ID_LEN)
+		return 0;
+
+	memcpy(p, delim + 1, len);
+	p[len] = 0;
+
+	dev = dev_get_by_name(net, p);
+	if (dev != NULL) {
+		scope_id = dev->ifindex;
+		dev_put(dev);
+	} else {
+		if (kstrtou32(p, 10, &scope_id) != 0)
+			return 0;
 	}
 
-	return 0;
+	sin6->sin6_scope_id = scope_id;
+	return 1;
 }
 
 static size_t rpc_pton6(struct net *net, const char *buf, const size_t buflen,
-- 
2.33.0



