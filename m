Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B19582AA3
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232784AbiG0QW1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234732AbiG0QWC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:22:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBAD231238;
        Wed, 27 Jul 2022 09:22:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A38FDCE2304;
        Wed, 27 Jul 2022 16:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1D9C433C1;
        Wed, 27 Jul 2022 16:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658938918;
        bh=baCgCy56YObxzhgX2L4La7FM8mD+ITUsB5YBk92O+E4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WnLFJbvYmfmgTmfHCuULrJWxPzfXM1FfxM7ysPyd00NLDPUF00rdo5ejKI9v+cHnh
         Hg6l9kXFhFCBIfYPaF/TWE8TtFikERqVponiOvopIPzE+2RYRXEb4YgHVL8z2fHR/Q
         MSJ5Q0TlsFwE9WfymxrOjWIJG15L3VrDdc2SdZgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 14/26] igmp: Fix a data-race around sysctl_igmp_max_memberships.
Date:   Wed, 27 Jul 2022 18:10:43 +0200
Message-Id: <20220727160959.689789254@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727160959.122591422@linuxfoundation.org>
References: <20220727160959.122591422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 6305d821e3b9b5379d348528e5b5faf316383bc2 ]

While reading sysctl_igmp_max_memberships, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/igmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 6e217424e0ff..3c09bee931b7 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2171,7 +2171,7 @@ int ip_mc_join_group(struct sock *sk, struct ip_mreqn *imr)
 		count++;
 	}
 	err = -ENOBUFS;
-	if (count >= net->ipv4.sysctl_igmp_max_memberships)
+	if (count >= READ_ONCE(net->ipv4.sysctl_igmp_max_memberships))
 		goto done;
 	iml = sock_kmalloc(sk, sizeof(*iml), GFP_KERNEL);
 	if (!iml)
-- 
2.35.1



