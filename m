Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC1C14BBC2
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbgA1Os5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:48:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:48026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727210AbgA1OBw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:01:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7234E24685;
        Tue, 28 Jan 2020 14:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220111;
        bh=intayEvlwG5iSgRRqpJXqWohS2b+wWvz59B9dftJtAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0zg391c7GFC62/t3Y80OajSf5lrzWlONcZfwC03dZbBso2BA6j9xQfIqc2rIHGK50
         6BByKj3yy0Tj/4jI5dBJ6S6XH6tdjYXrDB1PJUUO4H+zwePWnLBvuDRi38sdt6Jknl
         sjNnuBjgnqUYhUj2ez10/Ia/s/T90AqXCfUIqc00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Kristian Evensen <kristian.evensen@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 022/104] fou: Fix IPv6 netlink policy
Date:   Tue, 28 Jan 2020 14:59:43 +0100
Message-Id: <20200128135820.333512491@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kristian Evensen <kristian.evensen@gmail.com>

[ Upstream commit bb48eb9b12a95db9d679025927269d4adda6dbd1 ]

When submitting v2 of "fou: Support binding FoU socket" (1713cb37bf67),
I accidentally sent the wrong version of the patch and one fix was
missing. In the initial version of the patch, as well as the version 2
that I submitted, I incorrectly used ".type" for the two V6-attributes.
The correct is to use ".len".

Reported-by: Dmitry Vyukov <dvyukov@google.com>
Fixes: 1713cb37bf67 ("fou: Support binding FoU socket")
Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fou.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -662,8 +662,8 @@ static const struct nla_policy fou_nl_po
 	[FOU_ATTR_REMCSUM_NOPARTIAL]	= { .type = NLA_FLAG, },
 	[FOU_ATTR_LOCAL_V4]		= { .type = NLA_U32, },
 	[FOU_ATTR_PEER_V4]		= { .type = NLA_U32, },
-	[FOU_ATTR_LOCAL_V6]		= { .type = sizeof(struct in6_addr), },
-	[FOU_ATTR_PEER_V6]		= { .type = sizeof(struct in6_addr), },
+	[FOU_ATTR_LOCAL_V6]		= { .len = sizeof(struct in6_addr), },
+	[FOU_ATTR_PEER_V6]		= { .len = sizeof(struct in6_addr), },
 	[FOU_ATTR_PEER_PORT]		= { .type = NLA_U16, },
 	[FOU_ATTR_IFINDEX]		= { .type = NLA_S32, },
 };


