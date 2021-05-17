Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E25E3832F5
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241185AbhEQOxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:53:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241689AbhEQOu6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:50:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 247766197D;
        Mon, 17 May 2021 14:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261399;
        bh=ltPnM2g22KvBxBhFEn+obnsGfdj0ICGUjMx526Tdgs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nmbz/VGw37OvggAUG80HhWDpX8DYe2yPHSMzzYvlDXLn0tE9xdPNXV9eb7ZVxIN5P
         y2ridEGT4gbWjJbCNcNAJ+DXR3BMCneyxmU8cr13q94en8FEAMgbcJpjkM1quK5WAr
         ECjsbvTmPQPw7YkfZpqWmH9IqpR0OaWdYshR3mOI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 016/289] tipc: convert dest nodes address to network order
Date:   Mon, 17 May 2021 15:59:01 +0200
Message-Id: <20210517140305.726545036@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

[ Upstream commit 1980d37565061ab44bdc2f9e4da477d3b9752e81 ]

(struct tipc_link_info)->dest is in network order (__be32), so we must
convert the value to network order before assigning. The problem detected
by sparse:

net/tipc/netlink_compat.c:699:24: warning: incorrect type in assignment (different base types)
net/tipc/netlink_compat.c:699:24:    expected restricted __be32 [usertype] dest
net/tipc/netlink_compat.c:699:24:    got int

Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/netlink_compat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/netlink_compat.c b/net/tipc/netlink_compat.c
index 1c7aa51cc2a3..49e893313652 100644
--- a/net/tipc/netlink_compat.c
+++ b/net/tipc/netlink_compat.c
@@ -693,7 +693,7 @@ static int tipc_nl_compat_link_dump(struct tipc_nl_compat_msg *msg,
 	if (err)
 		return err;
 
-	link_info.dest = nla_get_flag(link[TIPC_NLA_LINK_DEST]);
+	link_info.dest = htonl(nla_get_flag(link[TIPC_NLA_LINK_DEST]));
 	link_info.up = htonl(nla_get_flag(link[TIPC_NLA_LINK_UP]));
 	nla_strlcpy(link_info.str, link[TIPC_NLA_LINK_NAME],
 		    TIPC_MAX_LINK_NAME);
-- 
2.30.2



