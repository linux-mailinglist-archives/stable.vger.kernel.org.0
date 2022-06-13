Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBED3548732
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 17:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383977AbiFMOb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384628AbiFMO3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:29:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D109A5FC9;
        Mon, 13 Jun 2022 04:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1224861425;
        Mon, 13 Jun 2022 11:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270F6C36AFE;
        Mon, 13 Jun 2022 11:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120859;
        bh=UuwuoCKP0zhAIEMCwoBc6I19MSn59HdkRGxknIb62ZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UAdBDN0iJ5Ry0cj9/q3AQ9xNjjJ+yEprXKMy63ALhYF4NjTIYltAr2MfUGMTtIoBg
         VPY7IEu/QvDDHOetHfZcpq6a6m3m4E2LKWZhK+SLu2A57LbOlow19ynyD+fotxQaAP
         y4M7u+upvtbJzDo3iGAwJzwQL7Hyx2Jw8pKQ7ido=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 184/298] net: ipv6: unexport __init-annotated seg6_hmac_init()
Date:   Mon, 13 Jun 2022 12:11:18 +0200
Message-Id: <20220613094930.511005664@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 5801f064e35181c71857a80ff18af4dbec3c5f5c ]

EXPORT_SYMBOL and __init is a bad combination because the .init.text
section is freed up after the initialization. Hence, modules cannot
use symbols annotated __init. The access to a freed symbol may end up
with kernel panic.

modpost used to detect it, but it has been broken for a decade.

Recently, I fixed modpost so it started to warn it again, then this
showed up in linux-next builds.

There are two ways to fix it:

  - Remove __init
  - Remove EXPORT_SYMBOL

I chose the latter for this case because the caller (net/ipv6/seg6.c)
and the callee (net/ipv6/seg6_hmac.c) belong to the same module.
It seems an internal function call in ipv6.ko.

Fixes: bf355b8d2c30 ("ipv6: sr: add core files for SR HMAC support")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/seg6_hmac.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 29bc4e7c3046..6de01185cc68 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -399,7 +399,6 @@ int __init seg6_hmac_init(void)
 {
 	return seg6_hmac_init_algo();
 }
-EXPORT_SYMBOL(seg6_hmac_init);
 
 int __net_init seg6_hmac_net_init(struct net *net)
 {
-- 
2.35.1



