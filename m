Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E19823381
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbfETMRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:17:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:58528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387561AbfETMRb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:17:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AED920815;
        Mon, 20 May 2019 12:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558354650;
        bh=udL3M1vP8B8S3V4S/JWx04LQMK+eLIfFE9fbigQye/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sGjYFNxZXYYxYDC2Xh5KAhJ+4g6DyasTmpDU0o5eBjHfoDq9kEMXtRmzakfF3m36S
         GePuXYBj9a2M9A8miFNUskbhjKzDpZyDDBZ64DqeLiMKqu60gwl0fvoeMvRAVa9FYy
         Z+PK3Uo6sQ3nbClKLBCQvg4e0pGc/zMpmjAzoXuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 38/44] fib_rules: fix error in backport of e9919a24d302 ("fib_rules: return 0...")
Date:   Mon, 20 May 2019 14:14:27 +0200
Message-Id: <20190520115235.482112363@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115230.720347034@linuxfoundation.org>
References: <20190520115230.720347034@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

When commit e9919a24d302 ("fib_rules: return 0 directly if an exactly
same rule exists when NLM_F_EXCL not supplied") was backported to 4.9.y,
it changed the logic a bit as err should have been reset before exiting
the test, like it happens in the original logic.

If this is not set, errors happen :(

Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: David Ahern <dsahern@gmail.com>
Reported-by: Florian Westphal <fw@strlen.de>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/fib_rules.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -430,6 +430,7 @@ int fib_nl_newrule(struct sk_buff *skb,
 		goto errout_free;
 
 	if (rule_exists(ops, frh, tb, rule)) {
+		err = 0;
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			err = -EEXIST;
 		goto errout_free;


