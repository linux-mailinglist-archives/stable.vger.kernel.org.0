Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12995B7011
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233235AbiIMOUc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233546AbiIMOTT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:19:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDC1B65547;
        Tue, 13 Sep 2022 07:14:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB023614BD;
        Tue, 13 Sep 2022 14:12:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFE3C433D6;
        Tue, 13 Sep 2022 14:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078364;
        bh=ENOFx+2hCkzle9QLjIch9KzpL1Yqyo5Dw+rB4EmSoz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N4ChxNGOBKlzJ/0FNtCFhEYLj53cf0iX4DxMxQcs637fr4+sogQjtbdO1d8FytNjo
         VJ0XDDqMoNV6Bwef2vMwQR6NWiKto+w5cfrwqPrg4HiaGizeLGoV7CstXcs+Ac7N8v
         MKZwEMj1+Pe74UqZgcOo2MQMYeRJppWZ7LhU+yC4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Dionne <marc.dionne@auristor.com>,
        David Howells <dhowells@redhat.com>,
        linux-afs@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 111/192] rxrpc: Fix an insufficiently large sglist in rxkad_verify_packet_2()
Date:   Tue, 13 Sep 2022 16:03:37 +0200
Message-Id: <20220913140415.504632548@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

[ Upstream commit 0d40f728e28393a8817d1fcae923dfa3409e488c ]

rxkad_verify_packet_2() has a small stack-allocated sglist of 4 elements,
but if that isn't sufficient for the number of fragments in the socket
buffer, we try to allocate an sglist large enough to hold all the
fragments.

However, for large packets with a lot of fragments, this isn't sufficient
and we need at least one additional fragment.

The problem manifests as skb_to_sgvec() returning -EMSGSIZE and this then
getting returned by userspace.  Most of the time, this isn't a problem as
rxrpc sets a limit of 5692, big enough for 4 jumbo subpackets to be glued
together; occasionally, however, the server will ignore the reported limit
and give a packet that's a lot bigger - say 19852 bytes with ->nr_frags
being 7.  skb_to_sgvec() then tries to return a "zeroth" fragment that
seems to occur before the fragments counted by ->nr_frags and we hit the
end of the sglist too early.

Note that __skb_to_sgvec() also has an skb_walk_frags() loop that is
recursive up to 24 deep.  I'm not sure if I need to take account of that
too - or if there's an easy way of counting those frags too.

Fix this by counting an extra frag and allocating a larger sglist based on
that.

Fixes: d0d5c0cd1e71 ("rxrpc: Use skb_unshare() rather than skb_cow_data()")
Reported-by: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-afs@lists.infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rxrpc/rxkad.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rxrpc/rxkad.c b/net/rxrpc/rxkad.c
index 08aab5c01437d..db47844f4ac99 100644
--- a/net/rxrpc/rxkad.c
+++ b/net/rxrpc/rxkad.c
@@ -540,7 +540,7 @@ static int rxkad_verify_packet_2(struct rxrpc_call *call, struct sk_buff *skb,
 	 * directly into the target buffer.
 	 */
 	sg = _sg;
-	nsg = skb_shinfo(skb)->nr_frags;
+	nsg = skb_shinfo(skb)->nr_frags + 1;
 	if (nsg <= 4) {
 		nsg = 4;
 	} else {
-- 
2.35.1



