Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DECF3289BB
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:03:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhCASDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:03:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:49708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239173AbhCAR6k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:58:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EDF5D65123;
        Mon,  1 Mar 2021 17:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618181;
        bh=ReAI+yvQjUFRAHcvPHSDQ9i9cEinuwq+ddTXc2KFHtM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IeUa2xeiqHKHZxXD1rehhyk+Mu5mij/byrS21OLVEHa5fpTOlBm0UEybn8j0wsdQ3
         IMfT3XPWh038nIMFd0dmR3LCIVA/CY7pFM8ITDjJSIovXDmPMGqNxt+uFqBrjyZoqq
         9/2ABClag5Kqmmwtu57kMKyhgodBVyJcIwTuIUxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 336/340] ipv6: silence compilation warning for non-IPV6 builds
Date:   Mon,  1 Mar 2021 17:14:40 +0100
Message-Id: <20210301161104.828046373@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
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


