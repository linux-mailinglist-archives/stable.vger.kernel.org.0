Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2FEA548CAC
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384103AbiFMOcv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385521AbiFMObQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:31:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E320ABE6F;
        Mon, 13 Jun 2022 04:48:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 129C8B80ECC;
        Mon, 13 Jun 2022 11:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D33DC3411B;
        Mon, 13 Jun 2022 11:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120929;
        bh=fOGyiO/Q/y/xv0Yi8FkPvSRMF+bUyYruvb+2AB7CZhw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QEtIS6AljOlnoaEZ46j/rTc6PxuNFgrURP7SJFnSmF8r7tIGHshBKoYdGBfY+ctfu
         G9814difbwUdJVzfREUXnJdkjYDhSIGwIYhiym4qRJWJqNEA7TGt1OWMERr06fCTpX
         y19cJYb0q1VYa0Hr2FACE900DpN78lBgojh6V9ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 192/298] tcp: use alloc_large_system_hash() to allocate table_perturb
Date:   Mon, 13 Jun 2022 12:11:26 +0200
Message-Id: <20220613094930.929532082@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muchun Song <songmuchun@bytedance.com>

[ Upstream commit e67b72b90b7e19a4be4d9c29f3feea6f58ab43f8 ]

In our server, there may be no high order (>= 6) memory since we reserve
lots of HugeTLB pages when booting.  Then the system panic.  So use
alloc_large_system_hash() to allocate table_perturb.

Fixes: e9261476184b ("tcp: dynamically allocate the perturb table used by source ports")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20220607070214.94443-1-songmuchun@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_hashtables.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index a5d57fa679ca..55654e335d43 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -917,10 +917,12 @@ void __init inet_hashinfo2_init(struct inet_hashinfo *h, const char *name,
 	init_hashinfo_lhash2(h);
 
 	/* this one is used for source ports of outgoing connections */
-	table_perturb = kmalloc_array(INET_TABLE_PERTURB_SIZE,
-				      sizeof(*table_perturb), GFP_KERNEL);
-	if (!table_perturb)
-		panic("TCP: failed to alloc table_perturb");
+	table_perturb = alloc_large_system_hash("Table-perturb",
+						sizeof(*table_perturb),
+						INET_TABLE_PERTURB_SIZE,
+						0, 0, NULL, NULL,
+						INET_TABLE_PERTURB_SIZE,
+						INET_TABLE_PERTURB_SIZE);
 }
 
 int inet_hashinfo2_init_mod(struct inet_hashinfo *h)
-- 
2.35.1



