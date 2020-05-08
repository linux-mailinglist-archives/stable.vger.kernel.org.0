Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5C51CAB35
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728822AbgEHMl0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:41:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728820AbgEHMl0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:41:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E15FB2495F;
        Fri,  8 May 2020 12:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941685;
        bh=AaVBMed/jK2tTG+Zl65dMFrH0jP3Wozb96iodgcBeLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iqt18IfLeao4MTKZ/+gAq0xrwJwyi4r+K3kLC1a/YpUhji2TFlXwFHbQOlYxwehM0
         GqTjYEhMPcJMpofYitve6iNFFgGTGwWosFWIWqQn+uD9Kwx3z5xCQUuJTGR7AtGdGP
         YREFPklQqfedKgoaLcPqbAgiaFWUZXrfqYIbSNbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 131/312] net: get rid of an signed integer overflow in ip_idents_reserve()
Date:   Fri,  8 May 2020 14:32:02 +0200
Message-Id: <20200508123133.721321591@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit adb03115f4590baa280ddc440a8eff08a6be0cb7 upstream.

Jiri Pirko reported an UBSAN warning happening in ip_idents_reserve()

[] UBSAN: Undefined behaviour in ./arch/x86/include/asm/atomic.h:156:11
[] signed integer overflow:
[] -2117905507 + -695755206 cannot be represented in type 'int'

Since we do not have uatomic_add_return() yet, use atomic_cmpxchg()
so that the arithmetics can be done using unsigned int.

Fixes: 04ca6973f7c1 ("ip: make IP identifiers less predictable")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jiri Pirko <jiri@resnulli.us>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/ipv4/route.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -477,12 +477,18 @@ u32 ip_idents_reserve(u32 hash, int segs
 	atomic_t *p_id = ip_idents + hash % IP_IDENTS_SZ;
 	u32 old = ACCESS_ONCE(*p_tstamp);
 	u32 now = (u32)jiffies;
-	u32 delta = 0;
+	u32 new, delta = 0;
 
 	if (old != now && cmpxchg(p_tstamp, old, now) == old)
 		delta = prandom_u32_max(now - old);
 
-	return atomic_add_return(segs + delta, p_id) - segs;
+	/* Do not use atomic_add_return() as it makes UBSAN unhappy */
+	do {
+		old = (u32)atomic_read(p_id);
+		new = old + delta + segs;
+	} while (atomic_cmpxchg(p_id, old, new) != old);
+
+	return new - segs;
 }
 EXPORT_SYMBOL(ip_idents_reserve);
 


