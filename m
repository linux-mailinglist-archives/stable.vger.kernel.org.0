Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 811201676A6
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731428AbgBUIFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:05:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:38596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730972AbgBUIFM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:05:12 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB29B20801;
        Fri, 21 Feb 2020 08:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272312;
        bh=6GnYNQpX3kRlCJgr37H2+nzeqECSZmwoGPWyPnE+dIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rDeFEX0LrblKvtNbxMi7/z5iQu15rhmcdFTg1zh7WCkmuJ6N97jPszvNV2/PK6Vu+
         qmLj+gnlYtAhXoFbRkMJUYMg8qbrKYZrLkGqPgooNydig0gQGlY294HEDvAOhebeVa
         JsBLeUodfHymQWDJqgfFcOGcIlYcSn4X4atls68o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Sitnicki <jakub@cloudflare.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/344] bpf, sockhash: Synchronize_rcu before freeing map
Date:   Fri, 21 Feb 2020 08:38:13 +0100
Message-Id: <20200221072357.497217143@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit 0b2dc83906cf1e694e48003eae5df8fa63f76fd9 ]

We need to have a synchronize_rcu before free'ing the sockhash because any
outstanding psock references will have a pointer to the map and when they
use it, this could trigger a use after free.

This is a sister fix for sockhash, following commit 2bb90e5cc90e ("bpf:
sockmap, synchronize_rcu before free'ing map") which addressed sockmap,
which comes from a manual audit.

Fixes: 604326b41a6fb ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20200206111652.694507-3-jakub@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_map.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 085cef5857bbf..405397801bb07 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -881,6 +881,9 @@ static void sock_hash_free(struct bpf_map *map)
 	/* wait for psock readers accessing its map link */
 	synchronize_rcu();
 
+	/* wait for psock readers accessing its map link */
+	synchronize_rcu();
+
 	bpf_map_area_free(htab->buckets);
 	kfree(htab);
 }
-- 
2.20.1



