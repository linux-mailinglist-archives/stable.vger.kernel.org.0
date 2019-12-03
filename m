Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B01A0111EA6
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730084AbfLCWxB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:53:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:46034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730078AbfLCWxA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:53:00 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE81920862;
        Tue,  3 Dec 2019 22:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413580;
        bh=L7kOZ2DuuxrBOah1HpwY0bLme+c1Dzk3lN0xbxhInE8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XhKanbveyr+ASEY3/PvjS6mYhnMI4aMpvZAKBwbr0fr98Ppb8NyDkV3Qt2yYSuuEu
         9oQNNKg28Vyx7a2qM1h4KsobVSDHTAuP6Z9kTbtUed8E5vT8oZKqGx+OKOeRJ/fkIK
         2GUJFoLeacUkCwxD1mCAJ4MvpEq0UAgik4chMJPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 183/321] net/netlink_compat: Fix a missing check of nla_parse_nested
Date:   Tue,  3 Dec 2019 23:34:09 +0100
Message-Id: <20191203223436.645103976@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>

[ Upstream commit 89dfd0083751d00d5d7ead36f6d8b045bf89c5e1 ]

In tipc_nl_compat_sk_dump(), if nla_parse_nested() fails, it could return
an error. To be consistent with other invocations of the function call,
on error, the fix passes the return value upstream.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/netlink_compat.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 318c541970ecd..6494d6b5e1b24 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -1030,8 +1030,11 @@ static int tipc_nl_compat_sk_dump(struct tipc_nl_compat_msg *msg,
 		u32 node;
 		struct nlattr *con[TIPC_NLA_CON_MAX + 1];
 
-		nla_parse_nested(con, TIPC_NLA_CON_MAX,
-				 sock[TIPC_NLA_SOCK_CON], NULL, NULL);
+		err = nla_parse_nested(con, TIPC_NLA_CON_MAX,
+				       sock[TIPC_NLA_SOCK_CON], NULL, NULL);
+
+		if (err)
+			return err;
 
 		node = nla_get_u32(con[TIPC_NLA_CON_NODE]);
 		tipc_tlv_sprintf(msg->rep, "  connected to <%u.%u.%u:%u>",
-- 
2.20.1



