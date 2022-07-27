Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06644582C1D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238863AbiG0QmQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:42:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239631AbiG0Qlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:41:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5F95B06B;
        Wed, 27 Jul 2022 09:29:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B9F261A39;
        Wed, 27 Jul 2022 16:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1BFC433D6;
        Wed, 27 Jul 2022 16:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939383;
        bh=QnJWWJokVEQTlFbsgEPyg0LjyFVVkCoMgMdLQdFzu3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ygqyBzPHabcXOatu9O9p65/2aP8wwRD2W1c66Xe9OYGbSLpkW39LyiAEdTYTfMvYf
         DxKIUtW4Y6lZonXsNRhxCpifLxn0OXhC5JidLn19QSa6Y//hhPAqv5cdFVdqrPyx7i
         7Uo62nAg7RrJwVhqJwDM7T8/Y4sNcGaadETrKJg4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 19/87] ip: Fix a data-race around sysctl_fwmark_reflect.
Date:   Wed, 27 Jul 2022 18:10:12 +0200
Message-Id: <20220727161009.797981561@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
References: <20220727161008.993711844@linuxfoundation.org>
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
index 21fc0a29a8d4..db841ab388c0 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -381,7 +381,7 @@ void ipfrag_init(void);
 void ip_static_sysctl_init(void);
 
 #define IP4_REPLY_MARK(net, mark) \
-	((net)->ipv4.sysctl_fwmark_reflect ? (mark) : 0)
+	(READ_ONCE((net)->ipv4.sysctl_fwmark_reflect) ? (mark) : 0)
 
 static inline bool ip_is_fragment(const struct iphdr *iph)
 {
-- 
2.35.1



