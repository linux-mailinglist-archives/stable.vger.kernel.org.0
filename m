Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB813A0266
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236920AbhFHTDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236205AbhFHTB1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:01:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 90C3461354;
        Tue,  8 Jun 2021 18:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177891;
        bh=p+PHPQ6gKflyziuFLdEsRRGWi8Rdwr30naO7QUZpkd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VSO4zBwAm8VlKEHeOgC4dSuwH+8YGVHLDXkInZQbdmX2/lDIAJxew0VVWBNVxzUV1
         AAac99KGkZkBLRjCK1T+vHmO+jjNdsBUNIj1/ecTSeiJem2YffCBL7A6pA9qxN2tQh
         ZpU/rd4tpFLSwMaaO3VkL1ZiYWgKh136bpQKpmBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kasper Dupont <kasperd@gjkwv.06.feb.2021.kasperd.net>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 137/137] neighbour: allow NUD_NOARP entries to be forced GCed
Date:   Tue,  8 Jun 2021 20:27:57 +0200
Message-Id: <20210608175947.007513374@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Ahern <dsahern@kernel.org>

commit 7a6b1ab7475fd6478eeaf5c9d1163e7a18125c8f upstream.

IFF_POINTOPOINT interfaces use NUD_NOARP entries for IPv6. It's possible to
fill up the neighbour table with enough entries that it will overflow for
valid connections after that.

This behaviour is more prevalent after commit 58956317c8de ("neighbor:
Improve garbage collection") is applied, as it prevents removal from
entries that are not NUD_FAILED, unless they are more than 5s old.

Fixes: 58956317c8de (neighbor: Improve garbage collection)
Reported-by: Kasper Dupont <kasperd@gjkwv.06.feb.2021.kasperd.net>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/neighbour.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -239,6 +239,7 @@ static int neigh_forced_gc(struct neigh_
 
 			write_lock(&n->lock);
 			if ((n->nud_state == NUD_FAILED) ||
+			    (n->nud_state == NUD_NOARP) ||
 			    (tbl->is_multicast &&
 			     tbl->is_multicast(n->primary_key)) ||
 			    time_after(tref, n->updated))


