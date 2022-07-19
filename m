Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201A6579B1A
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239618AbiGSMZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:25:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240120AbiGSMYf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:24:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF6861DA5;
        Tue, 19 Jul 2022 05:09:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C32676177C;
        Tue, 19 Jul 2022 12:09:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B67C341CF;
        Tue, 19 Jul 2022 12:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232542;
        bh=yfEAjfbrzGcGOPZEZmkis3DdgaS+IlV9BAc+6jQ81+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K+r1ZneYkDFbybU6dYMYq6o/rpEzhGgldW2j87ZxLUP6ZxabV92KgiuOmHHpNMc8m
         a0ehOLjwGy4MjAsVG6wwEJOxKRUVtHr0FYgErgsDGpqP29fMoJsAvZr4Bkc2Oc9qG7
         lRNxSf4RUlvUj7ysKDi/Rj/6p9uioUIz9NGFRe/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/112] icmp: Fix a data-race around sysctl_icmp_ratemask.
Date:   Tue, 19 Jul 2022 13:53:53 +0200
Message-Id: <20220719114632.331001880@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 1ebcb25ad6fc3d50fca87350acf451b9a66dd31e ]

While reading sysctl_icmp_ratemask, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 9483c2a16b78..0fa0da1d71f5 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -290,7 +290,7 @@ static bool icmpv4_mask_allow(struct net *net, int type, int code)
 		return true;
 
 	/* Limit if icmp type is enabled in ratemask. */
-	if (!((1 << type) & net->ipv4.sysctl_icmp_ratemask))
+	if (!((1 << type) & READ_ONCE(net->ipv4.sysctl_icmp_ratemask)))
 		return true;
 
 	return false;
-- 
2.35.1



