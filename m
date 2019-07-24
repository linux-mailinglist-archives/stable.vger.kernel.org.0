Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB79773F89
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfGXT1x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:27:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:45824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728770AbfGXT1w (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:27:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 524C6218EA;
        Wed, 24 Jul 2019 19:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996471;
        bh=/it1GCteT40XgRSWhv3xmwTSLL74B9D9MY67Mmiouc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFkF+9bd4qBpSBAnT6nTCflNBXw3lsqtZEXPjZlDE2KUF3oJkTurXKLAEijAxjORa
         vFfSqD+U+bgPdKhdsP8dH7PguRxlTh1j11uH0bYsRauWz5zXLXMplI6U2YGjRgI2uN
         Y6mZtmlmgv2K/lls1QJFNNHmQcKiBrD9eptwXyfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anirudh Gupta <anirudh.gupta@sophos.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 107/413] xfrm: fix sa selector validation
Date:   Wed, 24 Jul 2019 21:16:38 +0200
Message-Id: <20190724191742.938612665@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
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
index 76ad7e201626..b88ba45ff1ac 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -167,6 +167,9 @@ static int verify_newsa_info(struct xfrm_usersa_info *p,
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



