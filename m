Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2B9A73DBD
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:19:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390825AbfGXTrk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:47:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:54444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391270AbfGXTri (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:47:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B228214AF;
        Wed, 24 Jul 2019 19:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563997657;
        bh=AzA4WdxMpZtkrqqrdXJ2IkqzdDsBXqt6CBaqLJbCs7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIdn8Q9KFCJB0fDlo27TBfKuryjW9C8yhwFTWjgS+S55FHv5RuCaoh0M/DnAdsGQP
         EK1PNMKMvGDPT0bz88d1UA7FZhR/pyggaEbk6kfK/GEj0b1Dk0QGezArjs2rG3cPVt
         FFPUvY+x9XfVS096AONesUUinPdEv3v+BpfqfycI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anirudh Gupta <anirudh.gupta@sophos.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 099/371] xfrm: fix sa selector validation
Date:   Wed, 24 Jul 2019 21:17:31 +0200
Message-Id: <20190724191732.286751896@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b8d6d0079757cbd1b69724cfd1c08e2171c68cee ]

After commit b38ff4075a80, the following command does not work anymore:
$ ip xfrm state add src 10.125.0.2 dst 10.125.0.1 proto esp spi 34 reqid 1 \
  mode tunnel enc 'cbc(aes)' 0xb0abdba8b782ad9d364ec81e3a7d82a1 auth-trunc \
  'hmac(sha1)' 0xe26609ebd00acb6a4d51fca13e49ea78a72c73e6 96 flag align4

In fact, the selector is not mandatory, allow the user to provide an empty
selector.

Fixes: b38ff4075a80 ("xfrm: Fix xfrm sel prefix length validation")
CC: Anirudh Gupta <anirudh.gupta@sophos.com>
Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_user.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index ee91f939903e..6abf9625a401 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -166,6 +166,9 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
 	}
 
 	switch (p->sel.family) {
+	case AF_UNSPEC:
+		break;
+
 	case AF_INET:
 		if (p->sel.prefixlen_d > 32 || p->sel.prefixlen_s > 32)
 			goto out;
-- 
2.20.1



