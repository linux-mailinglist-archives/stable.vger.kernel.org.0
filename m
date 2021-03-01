Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895173285E9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:02:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbhCARAt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:00:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:55744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232032AbhCAQyf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:54:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B400464FC5;
        Mon,  1 Mar 2021 16:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616502;
        bh=ReAI+yvQjUFRAHcvPHSDQ9i9cEinuwq+ddTXc2KFHtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gUcvOhe+PXYmwep8vvb6PAkxEVaGlZkeyPerWCjN2TiBzRpH8yefjJ+j027nAW7TI
         vAgNK3fXrTOPOVAqXL2kUiFMN/UBrKEjLySXl/zsGg8qa6eq1VAS3rsR4vnxOGtRn9
         Qyt8INtCD4xFnQ2cBjxgyyAYc7oUI0rba/sg7l9I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 174/176] ipv6: silence compilation warning for non-IPV6 builds
Date:   Mon,  1 Mar 2021 17:14:07 +0100
Message-Id: <20210301161029.678393499@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

commit 1faba27f11c8da244e793546a1b35a9b1da8208e upstream.

The W=1 compilation of allmodconfig generates the following warning:

net/ipv6/icmp.c:448:6: warning: no previous prototype for 'icmp6_send' [-Wmissing-prototypes]
  448 | void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
      |      ^~~~~~~~~~

Fix it by providing function declaration for builds with ipv6 as a module.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/icmpv6.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -16,9 +16,9 @@ static inline struct icmp6hdr *icmp6_hdr
 
 typedef void ip6_icmp_send_t(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 			     const struct in6_addr *force_saddr);
-#if IS_BUILTIN(CONFIG_IPV6)
 void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 		const struct in6_addr *force_saddr);
+#if IS_BUILTIN(CONFIG_IPV6)
 static inline void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
 {
 	icmp6_send(skb, type, code, info, NULL);


