Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24A0CCABA9
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729699AbfJCP5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 11:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730989AbfJCP5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 11:57:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 465BA20830;
        Thu,  3 Oct 2019 15:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570118254;
        bh=0RTc05l2gYj4ZmdMElNObqKBp2zeliCT/z+ZyWPo8yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uWmTHRW23FgjPtnhTQTBmELizKD5j1ZQlupqGxwCSwo7odzzj9xtBmY+eOH2rpqfw
         ES1Y7Mnjb6Zwz/Hca2jLm7SSOQ9HnDo6i/vEhAMUIsamuHcYkii+g1Ar4cIJDEJB2u
         PY/D0jZvsLTC11cfBSarG2/C/IHNfURUWBZApoFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Christophe Leroy <christophe.leroy@c-s.fr>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 4.4 07/99] crypto: talitos - fix missing break in switch statement
Date:   Thu,  3 Oct 2019 17:52:30 +0200
Message-Id: <20191003154256.015612973@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154252.297991283@linuxfoundation.org>
References: <20191003154252.297991283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo A. R. Silva <gustavo@embeddedor.com>

commit 5fc194ea6d34dfad9833d3043ce41d6c52aff39a upstream.

Add missing break statement in order to prevent the code from falling
through to case CRYPTO_ALG_TYPE_AHASH.

Fixes: aeb4c132f33d ("crypto: talitos - Convert to new AEAD interface")
Cc: stable@vger.kernel.org
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/talitos.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2730,6 +2730,7 @@ static int talitos_remove(struct platfor
 			break;
 		case CRYPTO_ALG_TYPE_AEAD:
 			crypto_unregister_aead(&t_alg->algt.alg.aead);
+			break;
 		case CRYPTO_ALG_TYPE_AHASH:
 			crypto_unregister_ahash(&t_alg->algt.alg.hash);
 			break;


