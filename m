Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6597558727
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 20:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236926AbiFWSUz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 14:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236829AbiFWSSw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 14:18:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339A4647B7;
        Thu, 23 Jun 2022 10:25:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA73160B79;
        Thu, 23 Jun 2022 17:25:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D2CC3411B;
        Thu, 23 Jun 2022 17:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656005099;
        bh=hqzuFkqJZfZ2xw66ZjW5NeLcs8PlIC6Yzab2noj3OdM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OQfntXg1188KUKr9JXf5EzFxhKy0EAR5xejfPR5Hxo09lr4QimdA5PqW0brDTOPTh
         Wv3oL29nVIFuS4IwhVTX/ghEzmT7C4KDfEMn/GcSTsvuQrL2/YYPXcMBU/c7jKFtPD
         lslBexq7buCBjHMCCKGGpKi+fxyfRuQmeC1Y4OLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.4 08/11] tcp: increase source port perturb table to 2^16
Date:   Thu, 23 Jun 2022 18:45:12 +0200
Message-Id: <20220623164321.442250829@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164321.195163701@linuxfoundation.org>
References: <20220623164321.195163701@linuxfoundation.org>
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

commit 4c2c8f03a5ab7cb04ec64724d7d176d00bcc91e5 upstream.

Moshe Kol, Amit Klein, and Yossi Gilad reported being able to accurately
identify a client by forcing it to emit only 40 times more connections
than there are entries in the table_perturb[] table. The previous two
improvements consisting in resalting the secret every 10s and adding
randomness to each port selection only slightly improved the situation,
and the current value of 2^8 was too small as it's not very difficult
to make a client emit 10k connections in less than 10 seconds.

Thus we're increasing the perturb table from 2^8 to 2^16 so that the
same precision now requires 2.6M connections, which is more difficult in
this time frame and harder to hide as a background activity. The impact
is that the table now uses 256 kB instead of 1 kB, which could mostly
affect devices making frequent outgoing connections. However such
components usually target a small set of destinations (load balancers,
database clients, perf assessment tools), and in practice only a few
entries will be visited, like before.

A live test at 1 million connections per second showed no performance
difference from the previous value.

Reported-by: Moshe Kol <moshe.kol@mail.huji.ac.il>
Reported-by: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
Reported-by: Amit Klein <aksecurity@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_hashtables.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -675,11 +675,12 @@ EXPORT_SYMBOL_GPL(inet_unhash);
  * Note that we use 32bit integers (vs RFC 'short integers')
  * because 2^16 is not a multiple of num_ephemeral and this
  * property might be used by clever attacker.
- * RFC claims using TABLE_LENGTH=10 buckets gives an improvement,
- * we use 256 instead to really give more isolation and
- * privacy, this only consumes 1 KB of kernel memory.
+ * RFC claims using TABLE_LENGTH=10 buckets gives an improvement, though
+ * attacks were since demonstrated, thus we use 65536 instead to really
+ * give more isolation and privacy, at the expense of 256kB of kernel
+ * memory.
  */
-#define INET_TABLE_PERTURB_SHIFT 8
+#define INET_TABLE_PERTURB_SHIFT 16
 #define INET_TABLE_PERTURB_SIZE (1 << INET_TABLE_PERTURB_SHIFT)
 static u32 *table_perturb;
 


