Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D593A8E04
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732734AbfIDRzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 13:55:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732715AbfIDRzf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 13:55:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 58C2422CF7;
        Wed,  4 Sep 2019 17:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567619734;
        bh=PJ7TrG4ut12kBlFZF+g0Rh64lgOq705udYvt5reIFUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f0yhGFP1PZRzmOUuopoUP5BEplN+vZF6vzRiPPnyjFX3YuNIn1UShVbGktuSc4WAw
         /i8r0RNNU7PS/MPxzZiJtM665Haz/AKWYR1OoeSauaP5gP7oqZfkpy8jh4+kCywi5P
         jNUn5toBz8UY17jnaVCKSHxPOZP5k+qbnmchVnJk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenwen Wang <wenwen@cs.uga.edu>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 03/77] netfilter: ebtables: fix a memory leak bug in compat
Date:   Wed,  4 Sep 2019 19:52:50 +0200
Message-Id: <20190904175303.700985315@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175303.317468926@linuxfoundation.org>
References: <20190904175303.317468926@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 15a78ba1844a8e052c1226f930133de4cef4e7ad ]

In compat_do_replace(), a temporary buffer is allocated through vmalloc()
to hold entries copied from the user space. The buffer address is firstly
saved to 'newinfo->entries', and later on assigned to 'entries_tmp'. Then
the entries in this temporary buffer is copied to the internal kernel
structure through compat_copy_entries(). If this copy process fails,
compat_do_replace() should be terminated. However, the allocated temporary
buffer is not freed on this path, leading to a memory leak.

To fix the bug, free the buffer before returning from compat_do_replace().

Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebtables.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 1a87cf78fadc4..d9471e3ef2161 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -2280,8 +2280,10 @@ static int compat_do_replace(struct net *net, void __user *user,
 	state.buf_kern_len = size64;
 
 	ret = compat_copy_entries(entries_tmp, tmp.entries_size, &state);
-	if (WARN_ON(ret < 0))
+	if (WARN_ON(ret < 0)) {
+		vfree(entries_tmp);
 		goto out_unlock;
+	}
 
 	vfree(entries_tmp);
 	tmp.entries_size = size64;
-- 
2.20.1



