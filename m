Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB5ED3A775
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 18:50:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729537AbfFIQtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:49:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731593AbfFIQtv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:49:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E07A206C3;
        Sun,  9 Jun 2019 16:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098990;
        bh=cgsLR0MP9TO4l+0FwmXy4OKV3YkT2NYbYQJA/LEHspU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vzW2SMmNknF8fp8W4m1pAIx6DfR6q6+4hwf8WZycLAclg52Ro2YuEKgRYlVg8O2k2
         42pMkhK3ZGGTqFKIKrJulZcAGZwlz4ZNIYElD+i3g+yt6XvPAg7tQcDsoASnFnwKbQ
         r9fT8k7aebcda/LcWSCYUEytgWl3BC6RCfcJAKHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianlin Shi <jishi@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 10/35] ipv6: fix the check before getting the cookie in rt6_get_cookie
Date:   Sun,  9 Jun 2019 18:42:16 +0200
Message-Id: <20190609164126.099374565@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164125.377368385@linuxfoundation.org>
References: <20190609164125.377368385@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit b7999b07726c16974ba9ca3bb9fe98ecbec5f81c ]

In Jianlin's testing, netperf was broken with 'Connection reset by peer',
as the cookie check failed in rt6_check() and ip6_dst_check() always
returned NULL.

It's caused by Commit 93531c674315 ("net/ipv6: separate handling of FIB
entries from dst based routes"), where the cookie can be got only when
'c1'(see below) for setting dst_cookie whereas rt6_check() is called
when !'c1' for checking dst_cookie, as we can see in ip6_dst_check().

Since in ip6_dst_check() both rt6_dst_from_check() (c1) and rt6_check()
(!c1) will check the 'from' cookie, this patch is to remove the c1 check
in rt6_get_cookie(), so that the dst_cookie can always be set properly.

c1:
  (rt->rt6i_flags & RTF_PCPU || unlikely(!list_empty(&rt->rt6i_uncached)))

Fixes: 93531c674315 ("net/ipv6: separate handling of FIB entries from dst based routes")
Reported-by: Jianlin Shi <jishi@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip6_fib.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -199,8 +199,7 @@ static inline u32 rt6_get_cookie(const s
 {
 	u32 cookie = 0;
 
-	if (rt->rt6i_flags & RTF_PCPU ||
-	    (unlikely(!list_empty(&rt->rt6i_uncached)) && rt->dst.from))
+	if (rt->dst.from)
 		rt = (struct rt6_info *)(rt->dst.from);
 
 	rt6_get_cookie_safe(rt, &cookie);


