Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 783DB300B9C
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:45:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729108AbhAVSmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:42:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727742AbhAVOVo (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:21:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D171323B40;
        Fri, 22 Jan 2021 14:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324938;
        bh=//bqa8Bs54FOVZ3fRmrsBWz7y02SEyS3ElFgoz15l4M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EmmXZweBzGiwB43qc3XrTvqX6wFB4MKbwUhOOE91vq3zraY7eD8RsEY2CN8vBEW1U
         FK2AyACWeEutNTllBGus/kwlqPrxivVG1CVYr0S+vHID9n6C5NxUoeDd+MMbebayb8
         CHKpRDEuEH2+dgUjMIvSE3hTDB6lnf7SnEl6fOxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Petr Machata <petrm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 12/22] net: dcb: Accept RTM_GETDCB messages carrying set-like DCB commands
Date:   Fri, 22 Jan 2021 15:12:30 +0100
Message-Id: <20210122135732.405110922@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135731.921636245@linuxfoundation.org>
References: <20210122135731.921636245@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit df85bc140a4d6cbaa78d8e9c35154e1a2f0622c7 ]

In commit 826f328e2b7e ("net: dcb: Validate netlink message in DCB
handler"), Linux started rejecting RTM_GETDCB netlink messages if they
contained a set-like DCB_CMD_ command.

The reason was that privileges were only verified for RTM_SETDCB messages,
but the value that determined the action to be taken is the command, not
the message type. And validation of message type against the DCB command
was the obvious missing piece.

Unfortunately it turns out that mlnx_qos, a somewhat widely deployed tool
for configuration of DCB, accesses the DCB set-like APIs through
RTM_GETDCB.

Therefore do not bounce the discrepancy between message type and command.
Instead, in addition to validating privileges based on the actual message
type, validate them also based on the expected message type. This closes
the loophole of allowing DCB configuration on non-admin accounts, while
maintaining backward compatibility.

Fixes: 2f90b8657ec9 ("ixgbe: this patch adds support for DCB to the kernel and ixgbe driver")
Fixes: 826f328e2b7e ("net: dcb: Validate netlink message in DCB handler")
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://lore.kernel.org/r/a3edcfda0825f2aa2591801c5232f2bbf2d8a554.1610384801.git.me@pmachata.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dcb/dcbnl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -1756,7 +1756,7 @@ static int dcb_doit(struct sk_buff *skb,
 	fn = &reply_funcs[dcb->cmd];
 	if (!fn->cb)
 		return -EOPNOTSUPP;
-	if (fn->type != nlh->nlmsg_type)
+	if (fn->type == RTM_SETDCB && !netlink_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
 
 	if (!tb[DCB_ATTR_IFNAME])


