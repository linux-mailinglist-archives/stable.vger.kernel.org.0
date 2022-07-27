Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5674582B51
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:31:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237576AbiG0Qbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:31:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237147AbiG0QbK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:31:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE9E52E45;
        Wed, 27 Jul 2022 09:25:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DEF6B821BB;
        Wed, 27 Jul 2022 16:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7EE3C433D6;
        Wed, 27 Jul 2022 16:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939122;
        bh=hLk9idVTGAKCBX/2RyA8w4Od30zWdtZkT7LgLKR6RRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EU/hixzLBuKDc5sN3J15fknPTO6unCyA04e7F2nqQoB3hW7WioQsRregv8bJhC/FY
         w4bLm1rK/i3J6xwyRVnlTbcJ8vCBco9zP3Dw/N6R9XnhTyULFYHn2d6HoT6DKu4r9w
         93S27HKvs0xkMeXxGFth8cDT+omxj9A+1WqljsLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/62] ip: Fix a data-race around sysctl_fwmark_reflect.
Date:   Wed, 27 Jul 2022 18:10:18 +0200
Message-Id: <20220727161004.538362937@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161004.175638564@linuxfoundation.org>
References: <20220727161004.175638564@linuxfoundation.org>
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

[ Upstream commit 85d0b4dbd74b95cc492b1f4e34497d3f894f5d9a ]

While reading sysctl_fwmark_reflect, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: e110861f8609 ("net: add a sysctl to reflect the fwmark on replies")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 471463bfe6f9..0f820e68bd8f 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -341,7 +341,7 @@ void ipfrag_init(void);
 void ip_static_sysctl_init(void);
 
 #define IP4_REPLY_MARK(net, mark) \
-	((net)->ipv4.sysctl_fwmark_reflect ? (mark) : 0)
+	(READ_ONCE((net)->ipv4.sysctl_fwmark_reflect) ? (mark) : 0)
 
 static inline bool ip_is_fragment(const struct iphdr *iph)
 {
-- 
2.35.1



