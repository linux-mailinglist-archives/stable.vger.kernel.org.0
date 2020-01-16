Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDC5513FD30
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730656AbgAPXXF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:23:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:51100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731268AbgAPXXE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:23:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 488642073A;
        Thu, 16 Jan 2020 23:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216983;
        bh=NwfYSZRZH0kb1dydif8obU3YW+j3+UU9L10pLsDIZwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=le5dEZcbTRbXzlhvnxoFWm/MHTltHZ2f0c7PBiVUSJZ6DE9vNbDHTdc7RiuUxvyK2
         GXWNovWRWAkTZwgUroRFoC4oOhiND8Y5mRWAUfnERuxPdwUwgRy/NTrCXkBdRPMj2N
         YvLa+htAISoSza5h8LTg/sqXnd45X/F0kS3E3EX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunfeng Ye <yeyunfeng@huawei.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 100/203] crypto: arm64/aes-neonbs - add return value of skcipher_walk_done() in __xts_crypt()
Date:   Fri, 17 Jan 2020 00:16:57 +0100
Message-Id: <20200116231754.355010543@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunfeng Ye <yeyunfeng@huawei.com>

commit 9b537997b669c42cec67893538037e8d1c83c91c upstream.

A warning is found by the static code analysis tool:
  "Identical condition 'err', second condition is always false"

Fix this by adding return value of skcipher_walk_done().

Fixes: 67cfa5d3b721 ("crypto: arm64/aes-neonbs - implement ciphertext stealing for XTS")
Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/crypto/aes-neonbs-glue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/crypto/aes-neonbs-glue.c
+++ b/arch/arm64/crypto/aes-neonbs-glue.c
@@ -384,7 +384,7 @@ static int __xts_crypt(struct skcipher_r
 			goto xts_tail;
 
 		kernel_neon_end();
-		skcipher_walk_done(&walk, nbytes);
+		err = skcipher_walk_done(&walk, nbytes);
 	}
 
 	if (err || likely(!tail))


