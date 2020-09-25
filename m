Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D4D2788DA
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:58:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbgIYMtC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:49:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:52452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728693AbgIYMtC (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:49:02 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 47FAB21D7A;
        Fri, 25 Sep 2020 12:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038141;
        bh=lw+eJqYJfKCQ/y9R5/WorwzIJmvHRAVKrCkAcu02maw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w7/qNSNg+5tqX6fTjJ81uoQdHinceaD1XSSSwEDuR9ofqDm40rUTKgKK/mKkJxDM+
         6mepRXCjouDUj7MgYKdEQD7IMdAHProsZer8nRu8iv2Bl6FlOYo0UGGdD4fZA0NDUF
         EX2BO8uk6lMVg9U1oZsdkDJA0Hhf2Vo1fpqbArgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Necip Fazil Yildiran <fazilyildiran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 19/56] net: ipv6: fix kconfig dependency warning for IPV6_SEG6_HMAC
Date:   Fri, 25 Sep 2020 14:48:09 +0200
Message-Id: <20200925124730.711949686@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Necip Fazil Yildiran <fazilyildiran@gmail.com>

[ Upstream commit db7cd91a4be15e1485d6b58c6afc8761c59c4efb ]

When IPV6_SEG6_HMAC is enabled and CRYPTO is disabled, it results in the
following Kbuild warning:

WARNING: unmet direct dependencies detected for CRYPTO_HMAC
  Depends on [n]: CRYPTO [=n]
  Selected by [y]:
  - IPV6_SEG6_HMAC [=y] && NET [=y] && INET [=y] && IPV6 [=y]

WARNING: unmet direct dependencies detected for CRYPTO_SHA1
  Depends on [n]: CRYPTO [=n]
  Selected by [y]:
  - IPV6_SEG6_HMAC [=y] && NET [=y] && INET [=y] && IPV6 [=y]

WARNING: unmet direct dependencies detected for CRYPTO_SHA256
  Depends on [n]: CRYPTO [=n]
  Selected by [y]:
  - IPV6_SEG6_HMAC [=y] && NET [=y] && INET [=y] && IPV6 [=y]

The reason is that IPV6_SEG6_HMAC selects CRYPTO_HMAC, CRYPTO_SHA1, and
CRYPTO_SHA256 without depending on or selecting CRYPTO while those configs
are subordinate to CRYPTO.

Honor the kconfig menu hierarchy to remove kconfig dependency warnings.

Fixes: bf355b8d2c30 ("ipv6: sr: add core files for SR HMAC support")
Signed-off-by: Necip Fazil Yildiran <fazilyildiran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -303,6 +303,7 @@ config IPV6_SEG6_LWTUNNEL
 config IPV6_SEG6_HMAC
 	bool "IPv6: Segment Routing HMAC support"
 	depends on IPV6
+	select CRYPTO
 	select CRYPTO_HMAC
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256


