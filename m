Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47809475F2F
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:31:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238495AbhLOR2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344059AbhLOR1K (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:27:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D310C0613B5;
        Wed, 15 Dec 2021 09:26:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45606B8204A;
        Wed, 15 Dec 2021 17:26:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F59EC36AE2;
        Wed, 15 Dec 2021 17:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589172;
        bh=emMZ2g/cfMNEvsT0EsNPtAE7YXkJz8+dxp22diq2jh8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oXVQmnT1W7V9/QAPJHbjFsV3lRyqDJuwgN1Xt4DQVLRAC/pXFW1OzmJcLrprQzXo3
         4T/WfJ9jJQqiEgWj3bdzViNr+fPcjyAn3WSoAbGzTWnj1B5vtMNo7YWF9sJC4Nltqe
         IVKbWwhZmrSvNFWarTBHRyK+XiNseCr/ZcDysz0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bui Quang Minh <minhquangbui99@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Connor OBrien <connoro@google.com>
Subject: [PATCH 5.4 12/18] bpf: Fix integer overflow in argument calculation for bpf_map_area_alloc
Date:   Wed, 15 Dec 2021 18:21:33 +0100
Message-Id: <20211215172023.233762350@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172022.795825673@linuxfoundation.org>
References: <20211215172022.795825673@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bui Quang Minh <minhquangbui99@gmail.com>

commit 7dd5d437c258bbf4cc15b35229e5208b87b8b4e0 upstream.

In 32-bit architecture, the result of sizeof() is a 32-bit integer so
the expression becomes the multiplication between 2 32-bit integer which
can potentially leads to integer overflow. As a result,
bpf_map_area_alloc() allocates less memory than needed.

Fix this by casting 1 operand to u64.

Fixes: 0d2c4f964050 ("bpf: Eliminate rlimit-based memory accounting for sockmap and sockhash maps")
Fixes: 99c51064fb06 ("devmap: Use bpf_map_area_alloc() for allocating hash buckets")
Fixes: 546ac1ffb70d ("bpf: add devmap, a map for storing net device references")
Signed-off-by: Bui Quang Minh <minhquangbui99@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20210613143440.71975-1-minhquangbui99@gmail.com
Signed-off-by: Connor O'Brien <connoro@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/devmap.c |    4 ++--
 net/core/sock_map.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -94,7 +94,7 @@ static struct hlist_head *dev_map_create
 	int i;
 	struct hlist_head *hash;
 
-	hash = bpf_map_area_alloc(entries * sizeof(*hash), numa_node);
+	hash = bpf_map_area_alloc((u64) entries * sizeof(*hash), numa_node);
 	if (hash != NULL)
 		for (i = 0; i < entries; i++)
 			INIT_HLIST_HEAD(&hash[i]);
@@ -159,7 +159,7 @@ static int dev_map_init_map(struct bpf_d
 
 		spin_lock_init(&dtab->index_lock);
 	} else {
-		dtab->netdev_map = bpf_map_area_alloc(dtab->map.max_entries *
+		dtab->netdev_map = bpf_map_area_alloc((u64) dtab->map.max_entries *
 						      sizeof(struct bpf_dtab_netdev *),
 						      dtab->map.numa_node);
 		if (!dtab->netdev_map)
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -48,7 +48,7 @@ static struct bpf_map *sock_map_alloc(un
 	if (err)
 		goto free_stab;
 
-	stab->sks = bpf_map_area_alloc(stab->map.max_entries *
+	stab->sks = bpf_map_area_alloc((u64) stab->map.max_entries *
 				       sizeof(struct sock *),
 				       stab->map.numa_node);
 	if (stab->sks)


