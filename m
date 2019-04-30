Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F21F7D3
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:03:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728882AbfD3LnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729874AbfD3LnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:43:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B63521734;
        Tue, 30 Apr 2019 11:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624601;
        bh=DQAPoA1vmz5pLFoA53smvGOgqPbkDEWjxB/23Uq+0Uo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wh0YyozLsGTZZf6wdGytBUIJRy59LPEFSUkMKWqLuzEpBlcwIRYfyGAaSgY0Taumv
         NldJHOeWztaq+afhHNh9SzkJBLChZrncG4iS4OIbRpGMnKZPR/b2FNoqokHy9nEoQG
         3q+Dj9zm0yrhJ90aAqcxAPPkz6fqlD1VIdtF2aN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+659574e7bcc7f7eb4df7@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.14 35/53] netfilter: ebtables: CONFIG_COMPAT: drop a bogus WARN_ON
Date:   Tue, 30 Apr 2019 13:38:42 +0200
Message-Id: <20190430113557.415213926@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113549.400132183@linuxfoundation.org>
References: <20190430113549.400132183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 7caa56f006e9d712b44f27b32520c66420d5cbc6 upstream.

It means userspace gave us a ruleset where there is some other
data after the ebtables target but before the beginning of the next rule.

Fixes: 81e675c227ec ("netfilter: ebtables: add CONFIG_COMPAT support")
Reported-by: syzbot+659574e7bcc7f7eb4df7@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/bridge/netfilter/ebtables.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2030,7 +2030,8 @@ static int ebt_size_mwt(struct compat_eb
 		if (match_kern)
 			match_kern->match_size = ret;
 
-		if (WARN_ON(type == EBT_COMPAT_TARGET && size_left))
+		/* rule should have no remaining data after target */
+		if (type == EBT_COMPAT_TARGET && size_left)
 			return -EINVAL;
 
 		match32 = (struct compat_ebt_entry_mwt *) buf;


