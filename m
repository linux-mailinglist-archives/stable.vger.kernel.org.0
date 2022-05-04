Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C27B51A8A4
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356023AbiEDRME (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357062AbiEDRJz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA83D47571;
        Wed,  4 May 2022 09:56:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65D0F618DF;
        Wed,  4 May 2022 16:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AD6C385C2;
        Wed,  4 May 2022 16:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683417;
        bh=eidVBpEHpfCZhtqWZN0t3L727DuGTceR+6ii9207lXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQeJO8cMOMA5jNK5Rvc24NFJtJp0R55vUBGGtnoReL3Pq9nYOGgozpH7Ivs25o3pD
         kzcEXSCDGJkTaqj14FXCmUKCSC75wQoEefiHRQyEugCyb8SRrburcFq/qG8SgBfsEr
         pm7U6phfpKPlGmoGkkuHQEDP1xdRh2P3GpZtdjrQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Stefano Brivio <sbrivio@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 102/225] netfilter: nft_set_rbtree: overlap detection with element re-addition after deletion
Date:   Wed,  4 May 2022 18:45:40 +0200
Message-Id: <20220504153119.811799595@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit babc3dc9524f0bcb5a0ec61f3c3639b11508fad6 ]

This patch fixes spurious EEXIST errors.

Extend d2df92e98a34 ("netfilter: nft_set_rbtree: handle element
re-addition after deletion") to deal with elements with same end flags
in the same transation.

Reset the overlap flag as described by 7c84d41416d8 ("netfilter:
nft_set_rbtree: Detect partial overlaps on insertion").

Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
Fixes: d2df92e98a34 ("netfilter: nft_set_rbtree: handle element re-addition after deletion")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_rbtree.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index d600a566da32..7325bee7d144 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -349,7 +349,11 @@ static int __nft_rbtree_insert(const struct net *net, const struct nft_set *set,
 				*ext = &rbe->ext;
 				return -EEXIST;
 			} else {
-				p = &parent->rb_left;
+				overlap = false;
+				if (nft_rbtree_interval_end(rbe))
+					p = &parent->rb_left;
+				else
+					p = &parent->rb_right;
 			}
 		}
 
-- 
2.35.1



