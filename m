Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11C5D79945
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbfG2T1z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:27:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729286AbfG2T1x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:27:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 52A3B217D4;
        Mon, 29 Jul 2019 19:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428472;
        bh=EnJyaztDHpgHcFJXzpgoGij0JItQ9VAd1x/OnT9tPgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWIayauy+nJLJAyBur1vIE/xMwZSpIVPiTu92jLCDGbkujpkVn4RzhfgofxLRm5cK
         n+Enj0MdpxQiOzV4cEqCrFB2AMDzFre/Uoyjz9FYUyjcmL7z+sVyJ/CfLguBRhWDvN
         ECbLmK0Qtpx2gqRdarkaMsX5vbdd8V1zJSqPSrSA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 060/293] ipsec: select crypto ciphers for xfrm_algo
Date:   Mon, 29 Jul 2019 21:19:11 +0200
Message-Id: <20190729190829.007823387@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 597179b0ba550bd83fab1a9d57c42a9343c58514 ]

kernelci.org reports failed builds on arc because of what looks
like an old missed 'select' statement:

net/xfrm/xfrm_algo.o: In function `xfrm_probe_algs':
xfrm_algo.c:(.text+0x1e8): undefined reference to `crypto_has_ahash'

I don't see this in randconfig builds on other architectures, but
it's fairly clear we want to select the hash code for it, like we
do for all its other users. As Herbert points out, CRYPTO_BLKCIPHER
is also required even though it has not popped up in build tests.

Fixes: 17bc19702221 ("ipsec: Use skcipher and ahash when probing algorithms")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
index 286ed25c1a69..2e747ae7dc89 100644
--- a/net/xfrm/Kconfig
+++ b/net/xfrm/Kconfig
@@ -14,6 +14,8 @@ config XFRM_ALGO
 	tristate
 	select XFRM
 	select CRYPTO
+	select CRYPTO_HASH
+	select CRYPTO_BLKCIPHER
 
 config XFRM_USER
 	tristate "Transformation user configuration interface"
-- 
2.20.1



