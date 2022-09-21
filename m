Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0F625C0332
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbiIUQAu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232204AbiIUP6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:58:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E85A1A5F;
        Wed, 21 Sep 2022 08:52:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD7B963168;
        Wed, 21 Sep 2022 15:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB940C433D6;
        Wed, 21 Sep 2022 15:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775536;
        bh=w/n5KhdA3MVKZUaifbVJ8pga5w6qC0rPdRyADTfyPrc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ft3QqJ8fHOqf6hDzsfYhBgNRVkT6gmnFcdMfh1oy8hOsZIS708YdBgbVI2toIEgUK
         MPueij7yYhgLYpsg/ierXpfK6vudWvksLtGrsXi+onhLE3ynXrQ6Wax5Z9/A698NVn
         GMTiawi+dCQoCZRe/kzoIPNFicHPPu4b4GF+CP00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 29/39] rxrpc: Fix calc of resend age
Date:   Wed, 21 Sep 2022 17:46:34 +0200
Message-Id: <20220921153646.690594739@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 214a9dc7d852216e83acac7b75bc18f01ce184c2 ]

Fix the calculation of the resend age to add a microsecond value as
microseconds, not nanoseconds.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/call_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index f8ecad2b730e..2a93e7b5fbd0 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -166,7 +166,7 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 	_enter("{%d,%d}", call->tx_hard_ack, call->tx_top);
 
 	now = ktime_get_real();
-	max_age = ktime_sub(now, jiffies_to_usecs(call->peer->rto_j));
+	max_age = ktime_sub_us(now, jiffies_to_usecs(call->peer->rto_j));
 
 	spin_lock_bh(&call->lock);
 
-- 
2.35.1



