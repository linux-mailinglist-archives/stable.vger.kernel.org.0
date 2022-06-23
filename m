Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D6AF5584B5
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230362AbiFWRrF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232598AbiFWRpm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:45:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842009F0DF;
        Thu, 23 Jun 2022 10:10:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE12761D53;
        Thu, 23 Jun 2022 17:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829FDC341C4;
        Thu, 23 Jun 2022 17:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004243;
        bh=5pcQ+N/VNU+McFAAEGqtasN6rpA6IhKZLV3wiEulpY0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1yd0izJjiNXYT+uOHit1sPjm3TTZ/cfG5r6CbDeJoDytW5SIOCMPw4yRXFAfxliPw
         BNIFoVy9XUeN96M64gQsyZnNLngXg7qsBqcI+ZY5/HnFPxYa3keJkOflkmHV3REOXa
         cXpx5eIkgsE573maqpN7kZVYsf89boMaWGHj/xn8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.14 235/237] tcp: dynamically allocate the perturb table used by source ports
Date:   Thu, 23 Jun 2022 18:44:29 +0200
Message-Id: <20220623164349.914909290@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

commit e9261476184be1abd486c9434164b2acbe0ed6c2 upstream.

We'll need to further increase the size of this table and it's likely
that at some point its size will not be suitable anymore for a static
table. Let's allocate it on boot from inet_hashinfo2_init(), which is
called from tcp_init().

Cc: Moshe Kol <moshe.kol@mail.huji.ac.il>
Cc: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
Cc: Amit Klein <aksecurity@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[bwh: Backported to 4.14:
 - There is no inet_hashinfo2_init(), so allocate the table in
   inet_hashinfo_init() when called by TCP
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_hashtables.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -596,7 +596,8 @@ EXPORT_SYMBOL_GPL(inet_unhash);
  * privacy, this only consumes 1 KB of kernel memory.
  */
 #define INET_TABLE_PERTURB_SHIFT 8
-static u32 table_perturb[1 << INET_TABLE_PERTURB_SHIFT];
+#define INET_TABLE_PERTURB_SIZE (1 << INET_TABLE_PERTURB_SHIFT)
+static u32 *table_perturb;
 
 int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 		struct sock *sk, u64 port_offset,
@@ -636,7 +637,8 @@ int __inet_hash_connect(struct inet_time
 	if (likely(remaining > 1))
 		remaining &= ~1U;
 
-	net_get_random_once(table_perturb, sizeof(table_perturb));
+	net_get_random_once(table_perturb,
+			    INET_TABLE_PERTURB_SIZE * sizeof(*table_perturb));
 	index = hash_32(port_offset, INET_TABLE_PERTURB_SHIFT);
 
 	offset = READ_ONCE(table_perturb[index]) + (port_offset >> 32);
@@ -741,6 +743,15 @@ void inet_hashinfo_init(struct inet_hash
 		INIT_HLIST_NULLS_HEAD(&h->listening_hash[i].nulls_head,
 				      i + LISTENING_NULLS_BASE);
 	}
+
+	if (h != &tcp_hashinfo)
+		return;
+
+	/* this one is used for source ports of outgoing connections */
+	table_perturb = kmalloc_array(INET_TABLE_PERTURB_SIZE,
+				      sizeof(*table_perturb), GFP_KERNEL);
+	if (!table_perturb)
+		panic("TCP: failed to alloc table_perturb");
 }
 EXPORT_SYMBOL_GPL(inet_hashinfo_init);
 


