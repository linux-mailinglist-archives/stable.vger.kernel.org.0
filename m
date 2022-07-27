Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49661582D24
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240852AbiG0QyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240756AbiG0Qwe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:52:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B4434D4D4;
        Wed, 27 Jul 2022 09:34:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36AA1B821A6;
        Wed, 27 Jul 2022 16:34:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D091C433C1;
        Wed, 27 Jul 2022 16:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939680;
        bh=+gPwJQDHUp6HbCRAKvYwBLRJuFPLv+QcewdlpQuqxCM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIjQUOzqpYuIwqirKSgi3By5vz7SFjzOqi6CJ+ixlSJvlJc9LRKfq4wsPvsWnq9H1
         rBDsxSiv20uRg+vEHdINismhQnlC41cTUL/0OGtJEcaVYgtdLAF/K0my9yRet6Plo0
         Lvl82FiliKck6r8lTZd2IOlCY4kRQtWXeSlCUTGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 067/105] udp: Fix a data-race around sysctl_udp_l3mdev_accept.
Date:   Wed, 27 Jul 2022 18:10:53 +0200
Message-Id: <20220727161014.744920536@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
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

[ Upstream commit 3d72bb4188c708bb16758c60822fc4dda7a95174 ]

While reading sysctl_udp_l3mdev_accept, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 63a6fff353d0 ("net: Avoid receiving packets with an l3mdev on unbound UDP sockets")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/udp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/udp.h b/include/net/udp.h
index 4017f257628f..010bc324f860 100644
--- a/include/net/udp.h
+++ b/include/net/udp.h
@@ -259,7 +259,7 @@ static inline bool udp_sk_bound_dev_eq(struct net *net, int bound_dev_if,
 				       int dif, int sdif)
 {
 #if IS_ENABLED(CONFIG_NET_L3_MASTER_DEV)
-	return inet_bound_dev_eq(!!net->ipv4.sysctl_udp_l3mdev_accept,
+	return inet_bound_dev_eq(!!READ_ONCE(net->ipv4.sysctl_udp_l3mdev_accept),
 				 bound_dev_if, dif, sdif);
 #else
 	return inet_bound_dev_eq(true, bound_dev_if, dif, sdif);
-- 
2.35.1



