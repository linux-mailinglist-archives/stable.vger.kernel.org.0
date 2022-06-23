Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAD1E5584D0
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235133AbiFWRtV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235683AbiFWRsg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:48:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03C3562FF;
        Thu, 23 Jun 2022 10:11:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFFD1B82495;
        Thu, 23 Jun 2022 17:11:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADCAC3411B;
        Thu, 23 Jun 2022 17:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004294;
        bh=wC86r6mpyEtv5BOHeZ97mnmocu4FXkxLXJ7f0+8BoUo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rWAzxuN+VXS5imASqF/pFV8ue34yR5doGzLdQMX8osx4CqFua1C2Xk3hTklYvTjeU
         knb/zj23vqJqHOnvy5B5RaJ2frgwvQHCEA8fdaI9ueZq1Asuz46e+tkobT8d3eTRX5
         ++irJp97NvUvJH9Pwq44EqX+jLYXJqDDQF0nKlmo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Kol <moshe.kol@mail.huji.ac.il>,
        Yossi Gilad <yossi.gilad@mail.huji.ac.il>,
        Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>, Willy Tarreau <w@1wt.eu>,
        Jakub Kicinski <kuba@kernel.org>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 06/11] tcp: add small random increments to the source port
Date:   Thu, 23 Jun 2022 18:44:39 +0200
Message-Id: <20220623164322.484496274@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164322.296526800@linuxfoundation.org>
References: <20220623164322.296526800@linuxfoundation.org>
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

commit ca7af0402550f9a0b3316d5f1c30904e42ed257d upstream.

Here we're randomly adding between 0 and 7 random increments to the
selected source port in order to add some noise in the source port
selection that will make the next port less predictable.

With the default port range of 32768-60999 this means a worst case
reuse scenario of 14116/8=1764 connections between two consecutive
uses of the same port, with an average of 14116/4.5=3137. This code
was stressed at more than 800000 connections per second to a fixed
target with all connections closed by the client using RSTs (worst
condition) and only 2 connections failed among 13 billion, despite
the hash being reseeded every 10 seconds, indicating a perfectly
safe situation.

Cc: Moshe Kol <moshe.kol@mail.huji.ac.il>
Cc: Yossi Gilad <yossi.gilad@mail.huji.ac.il>
Cc: Amit Klein <aksecurity@gmail.com>
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
@@ -833,11 +833,12 @@ next_port:
 	return -EADDRNOTAVAIL;
 
 ok:
-	/* If our first attempt found a candidate, skip next candidate
-	 * in 1/16 of cases to add some noise.
+	/* Here we want to add a little bit of randomness to the next source
+	 * port that will be chosen. We use a max() with a random here so that
+	 * on low contention the randomness is maximal and on high contention
+	 * it may be inexistent.
 	 */
-	if (!i && !(prandom_u32() % 16))
-		i = 2;
+	i = max_t(int, i, (prandom_u32() & 7) * 2);
 	WRITE_ONCE(table_perturb[index], READ_ONCE(table_perturb[index]) + i + 2);
 
 	/* Head lock still held and bh's disabled */


