Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4880F4D78C
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:20:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729460AbfFTSOd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:14:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:42850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729453AbfFTSOa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:14:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 504DF205F4;
        Thu, 20 Jun 2019 18:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561054469;
        bh=UA8CJVHl22WRCysNGAs/ioVTOP1RLKtNLe+cIK4dq6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n0deR8UAGxL2dZ+J70UEjCbiZWmLU3ZDlTqbStj0/REGJKRvmR02NjTzRCKWNB8Y3
         yKdVzxZcLW5GH6dNbcz4j9s6s+4xi9ZEM6HjrjMru45YX0c1vI+cYRNZ6CtrbfqkxQ
         MoWwtA7ZqAJNv853Xx7zUHYqNZCZr28U1fIPqw3s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jagdish Motwani <jagdish.motwani@sophos.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 39/98] netfilter: nf_queue: fix reinject verdict handling
Date:   Thu, 20 Jun 2019 19:57:06 +0200
Message-Id: <20190620174350.871488415@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174349.443386789@linuxfoundation.org>
References: <20190620174349.443386789@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 946c0d8e6ed43dae6527e878d0077c1e11015db0 ]

This patch fixes netfilter hook traversal when there are more than 1 hooks
returning NF_QUEUE verdict. When the first queue reinjects the packet,
'nf_reinject' starts traversing hooks with a proper hook_index. However,
if it again receives a NF_QUEUE verdict (by some other netfilter hook), it
queues the packet with a wrong hook_index. So, when the second queue
reinjects the packet, it re-executes hooks in between.

Fixes: 960632ece694 ("netfilter: convert hook list to an array")
Signed-off-by: Jagdish Motwani <jagdish.motwani@sophos.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_queue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
index a36a77bae1d6..5b86574e7b89 100644
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -254,6 +254,7 @@ static unsigned int nf_iterate(struct sk_buff *skb,
 repeat:
 		verdict = nf_hook_entry_hookfn(hook, skb, state);
 		if (verdict != NF_ACCEPT) {
+			*index = i;
 			if (verdict != NF_REPEAT)
 				return verdict;
 			goto repeat;
-- 
2.20.1



