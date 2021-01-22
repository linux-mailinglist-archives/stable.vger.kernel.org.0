Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A39E300FCF
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 23:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730716AbhAVT5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:57:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728310AbhAVOMk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:12:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDF8D23A3A;
        Fri, 22 Jan 2021 14:09:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324579;
        bh=2RKH7J2muvcXmbRmaqoRBmJKzIh0qBhj7XPySiMHxCI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WGYMh9eRPou6QwKz7y2XrmxfGnublF571lihgssYiP6BOQzOMPfpwQmx+XBLt9q8G
         dg+0YoUX3pIxC9Imoy8HJmMh4ABlz+zaJqXrtZ7jYe8Kp6TRjx1nK6UAR6USVkCpAJ
         gfqqSzPdUa4wSVNidNpwlnOqcplpCE5jmkM+F1W4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <me@pmachata.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 26/31] net: dcb: Validate netlink message in DCB handler
Date:   Fri, 22 Jan 2021 15:08:40 +0100
Message-Id: <20210122135732.914805427@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.873346566@linuxfoundation.org>
References: <20210122135731.873346566@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <me@pmachata.org>

[ Upstream commit 826f328e2b7e8854dd42ea44e6519cd75018e7b1 ]

DCB uses the same handler function for both RTM_GETDCB and RTM_SETDCB
messages. dcb_doit() bounces RTM_SETDCB mesasges if the user does not have
the CAP_NET_ADMIN capability.

However, the operation to be performed is not decided from the DCB message
type, but from the DCB command. Thus DCB_CMD_*_GET commands are used for
reading DCB objects, the corresponding SET and DEL commands are used for
manipulation.

The assumption is that set-like commands will be sent via an RTM_SETDCB
message, and get-like ones via RTM_GETDCB. However, this assumption is not
enforced.

It is therefore possible to manipulate DCB objects without CAP_NET_ADMIN
capability by sending the corresponding command in an RTM_GETDCB message.
That is a bug. Fix it by validating the type of the request message against
the type used for the response.

Fixes: 2f90b8657ec9 ("ixgbe: this patch adds support for DCB to the kernel and ixgbe driver")
Signed-off-by: Petr Machata <me@pmachata.org>
Link: https://lore.kernel.org/r/a2a9b88418f3a58ef211b718f2970128ef9e3793.1608673640.git.me@pmachata.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dcb/dcbnl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -1725,6 +1725,8 @@ static int dcb_doit(struct sk_buff *skb,
 	fn = &reply_funcs[dcb->cmd];
 	if (!fn->cb)
 		return -EOPNOTSUPP;
+	if (fn->type != nlh->nlmsg_type)
+		return -EPERM;
 
 	if (!tb[DCB_ATTR_IFNAME])
 		return -EINVAL;


