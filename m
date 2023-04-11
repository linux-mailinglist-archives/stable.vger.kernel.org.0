Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6CFF6DD0B0
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 06:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjDKEKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 00:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjDKEKh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 00:10:37 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1C810EB
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 21:10:15 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id o2so6635508plg.4
        for <stable@vger.kernel.org>; Mon, 10 Apr 2023 21:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1681186215; x=1683778215;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eN2VsvcD5hPHo+/vlmQCptxa+XrNBTPC8kVbJFk1whI=;
        b=UZFe1vqI+wN9iQAUaKh6UKtom6rHOvL9AJb7n/MojmI9ZlaKauWs5yldPgww5XsKyn
         AlJQyJYQhn+WWTx5NiuImiFc8uLeQZ5Y7sTp5zmkOliTiMGJ9ZWK8AJUNJx4aFfXqLY6
         5Yylfkgcg2+ivHSGJaPPTRC+JShlBzyW8LxWC6vHPEeEuKIywsq7dT5fxb5vW6i8TfEn
         4F217cam94a5ZTgzS/rY9XurNwkQkqtQKY66vg39eNTvW2+UVcTwccas4Afk1giVpINj
         l3q7iKBhwrFa9UDTdMtI1CgWPG5ugokypEJ2HJq+hfikd0mBJZjB7m1d6mBR1tyyJaxe
         CSug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681186215; x=1683778215;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eN2VsvcD5hPHo+/vlmQCptxa+XrNBTPC8kVbJFk1whI=;
        b=D6+iNjRGm/e/Wen/v33eDtqN7yKjli6njVJe/1OKlNU1zTRyHlM0fD6uPJv6Z5DNwc
         7W1+sKQJ94Jb8pTTf/6uTDKZqV3qqVyxhL2Kd4ohxg4IgAhFe9AJhvq5yYD6N7nktUVC
         CpRq3DsF2CfIjBzv/84sQE+cA4RexXaT6/PKSqvHWhpb8tdPkjdmeQdfFAqnEtgYCuMs
         B4zXkZ1vRSbA8JL8Whfmh3g4mhtXjM328uh64aDceB33FHHz5DCkZBdjfFhzi4uG3wDr
         FpsKKao0M9bgtrLey0BXiXr8uaS1pRuzyDXQK7EWwvLovRJGjUxTTMT3vqjfP2DzbV6Q
         wZig==
X-Gm-Message-State: AAQBX9c0/MbzQLRtIQR7khkvEvrUGSz81N9y+uRsI5BYjjnKdN631ytY
        J3Zc+JHoy60vOtk2OZ81RCbt7nIny+VGqQmGotE=
X-Google-Smtp-Source: AKy350aSrN8B0Sp6VnEsjBen0H6woXVY8sym2SpKJ+kLilm7zW8jPJh6ije32zry0RpRfMYjoUZOTA==
X-Received: by 2002:a17:902:d2d2:b0:1a1:bcf:db5f with SMTP id n18-20020a170902d2d200b001a10bcfdb5fmr20291415plc.25.1681186215375;
        Mon, 10 Apr 2023 21:10:15 -0700 (PDT)
Received: from GL4FX4PXWL.bytedance.net ([139.177.225.248])
        by smtp.gmail.com with ESMTPSA id g13-20020a170902868d00b00198f36a8941sm5567317plo.221.2023.04.10.21.10.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 10 Apr 2023 21:10:14 -0700 (PDT)
From:   Peng Zhang <zhangpeng.00@bytedance.com>
To:     Liam.Howlett@oracle.com
Cc:     akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org,
        Peng Zhang <zhangpeng.00@bytedance.com>, stable@vger.kernel.org
Subject: [PATCH v2 1/2] maple_tree: Fix a potential memory leak, OOB access, or other unpredictable bug
Date:   Tue, 11 Apr 2023 12:10:04 +0800
Message-Id: <20230411041005.26205-1-zhangpeng.00@bytedance.com>
X-Mailer: git-send-email 2.37.0 (Apple Git-136)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

In mas_alloc_nodes(), "node->node_count = 0" means to initialize the
node_count field of the new node, but the node may not be a new node.
It may be a node that existed before and node_count has a value, setting
it to 0 will cause a memory leak. At this time, mas->alloc->total will
be greater than the actual number of nodes in the linked list, which may
cause many other errors. For example, out-of-bounds access in mas_pop_node(),
and mas_pop_node() may return addresses that should not be used. Fix it
by initializing node_count only for new nodes.

Also, by the way, an if-else statement was removed to simplify the code.

Fixes: 54a611b60590 ("Maple Tree: add new data structure")
Signed-off-by: Peng Zhang <zhangpeng.00@bytedance.com>
Cc: <stable@vger.kernel.org>
---
 lib/maple_tree.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/lib/maple_tree.c b/lib/maple_tree.c
index dd1a114d9e2b..938634bea2d6 100644
--- a/lib/maple_tree.c
+++ b/lib/maple_tree.c
@@ -1303,26 +1303,21 @@ static inline void mas_alloc_nodes(struct ma_state *mas, gfp_t gfp)
 	node = mas->alloc;
 	node->request_count = 0;
 	while (requested) {
-		max_req = MAPLE_ALLOC_SLOTS;
-		if (node->node_count) {
-			unsigned int offset = node->node_count;
-
-			slots = (void **)&node->slot[offset];
-			max_req -= offset;
-		} else {
-			slots = (void **)&node->slot;
-		}
-
+		max_req = MAPLE_ALLOC_SLOTS - node->node_count;
+		slots = (void **)&node->slot[node->node_count];
 		max_req = min(requested, max_req);
 		count = mt_alloc_bulk(gfp, max_req, slots);
 		if (!count)
 			goto nomem_bulk;
 
+		if (node->node_count == 0) {
+			node->slot[0]->node_count = 0;
+			node->slot[0]->request_count = 0;
+		}
+
 		node->node_count += count;
 		allocated += count;
 		node = node->slot[0];
-		node->node_count = 0;
-		node->request_count = 0;
 		requested -= count;
 	}
 	mas->alloc->total = allocated;
-- 
2.20.1

