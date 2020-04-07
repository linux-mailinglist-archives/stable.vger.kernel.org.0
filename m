Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC8511A0BAD
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728966AbgDGKZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:25:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:36196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728608AbgDGKZd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:25:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC256207FF;
        Tue,  7 Apr 2020 10:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255132;
        bh=3cR19qKiPaDwlXrsWSDSoSc5ShG6sGpNsCElSxC29fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lV4Ig1EWzbFQPsi0tF3V8LkJvx1KK+tOu3yCzmgMdvw65CUsRnGFWdyaLUFfPRoUA
         RNWnDw0O969aDqVncbsIev3hWt7vcHl2OsHC5i3Ub/g7pX7y17Hqhya3Jh6uHSD3Mh
         T1UJRxHF8k+nL7tBUIfGW2fQ2RtPhnF25ORoaVHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.5 43/46] net: genetlink: return the error code when attribute parsing fails.
Date:   Tue,  7 Apr 2020 12:22:14 +0200
Message-Id: <20200407101503.947995141@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407101459.502593074@linuxfoundation.org>
References: <20200407101459.502593074@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>

commit 39f3b41aa7cae917f928ef9f31d09da28188e5ed upstream.

Currently if attribute parsing fails and the genl family
does not support parallel operation, the error code returned
by __nlmsg_parse() is discarded by genl_family_rcv_msg_attrs_parse().

Be sure to report the error for all genl families.

Fixes: c10e6cf85e7d ("net: genetlink: push attrbuf allocation and parsing to a separate function")
Fixes: ab5b526da048 ("net: genetlink: always allocate separate attrs for dumpit ops")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netlink/genetlink.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/netlink/genetlink.c
+++ b/net/netlink/genetlink.c
@@ -497,8 +497,9 @@ genl_family_rcv_msg_attrs_parse(const st
 
 	err = __nlmsg_parse(nlh, hdrlen, attrbuf, family->maxattr,
 			    family->policy, validate, extack);
-	if (err && parallel) {
-		kfree(attrbuf);
+	if (err) {
+		if (parallel)
+			kfree(attrbuf);
 		return ERR_PTR(err);
 	}
 	return attrbuf;


