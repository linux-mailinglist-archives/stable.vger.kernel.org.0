Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3840D5584C5
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbiFWRtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235530AbiFWRsS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:48:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4CDAA377F;
        Thu, 23 Jun 2022 10:11:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6574B824BA;
        Thu, 23 Jun 2022 17:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29492C3411B;
        Thu, 23 Jun 2022 17:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004288;
        bh=BiKY0cWKwAsCGIT5tUZUQGIoQsLFPbq9+UZnNUOmaPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MAn2V3ZlVwFDf00Jq8eWl1PLdHXwSMAB2DPY/dLRs6omDMNU5JokenG6wCFgt58+g
         lJMRllGZLTOqVX9N+TnATMbqf4rFnlyKYR2U9aTmlwN3+tnmwAKKG7u31ai/PK+NiF
         au7gJh8xa+Neu33axuUNocwK2v115IRtRCRdhQOU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Dworken <ddworken@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 04/11] tcp: add some entropy in __inet_hash_connect()
Date:   Thu, 23 Jun 2022 18:44:37 +0200
Message-Id: <20220623164322.426528204@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit c579bd1b4021c42ae247108f1e6f73dd3f08600c upstream.

Even when implementing RFC 6056 3.3.4 (Algorithm 4: Double-Hash
Port Selection Algorithm), a patient attacker could still be able
to collect enough state from an otherwise idle host.

Idea of this patch is to inject some noise, in the
cases __inet_hash_connect() found a candidate in the first
attempt.

This noise should not significantly reduce the collision
avoidance, and should be zero if connection table
is already well used.

Note that this is not implementing RFC 6056 3.3.5
because we think Algorithm 5 could hurt typical
workloads.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: David Dworken <ddworken@google.com>
Cc: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_hashtables.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -833,6 +833,11 @@ next_port:
 	return -EADDRNOTAVAIL;
 
 ok:
+	/* If our first attempt found a candidate, skip next candidate
+	 * in 1/16 of cases to add some noise.
+	 */
+	if (!i && !(prandom_u32() % 16))
+		i = 2;
 	WRITE_ONCE(table_perturb[index], READ_ONCE(table_perturb[index]) + i + 2);
 
 	/* Head lock still held and bh's disabled */


