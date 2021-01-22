Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88AF2300FCA
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 23:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730892AbhAVT66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 14:58:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:35774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728437AbhAVOQL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:16:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8DE8E23B04;
        Fri, 22 Jan 2021 14:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324733;
        bh=ZwsZkSYfM5KR4IgNJmfL82GKzTKSzQC5mSAEDNtlr6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fI/UGQ4or4hgRqkNP9ZLJnRYc+l6ompBPGSxwc9TQL900Swiax1Q5M1Ick3JPbUMB
         sdkZvrs42wXqvl+025NXXXIzxppSKk6o9D6P3gUmI62JjYIJYQdIMaxfHtXIa6VkaU
         oX/WkAEBPafDaD+1sXiSW6TmWBmpG2oM36KVGJVA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <me@pmachata.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 29/35] net: dcb: Validate netlink message in DCB handler
Date:   Fri, 22 Jan 2021 15:10:31 +0100
Message-Id: <20210122135733.481500136@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135732.357969201@linuxfoundation.org>
References: <20210122135732.357969201@linuxfoundation.org>
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
@@ -1726,6 +1726,8 @@ static int dcb_doit(struct sk_buff *skb,
 	fn = &reply_funcs[dcb->cmd];
 	if (!fn->cb)
 		return -EOPNOTSUPP;
+	if (fn->type != nlh->nlmsg_type)
+		return -EPERM;
 
 	if (!tb[DCB_ATTR_IFNAME])
 		return -EINVAL;


