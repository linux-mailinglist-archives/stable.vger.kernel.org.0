Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBE82E6447
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:50:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408271AbgL1Ptt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:49:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:42456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404121AbgL1NmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:42:10 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5EAA207C9;
        Mon, 28 Dec 2020 13:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162890;
        bh=6aw0Ec5VBeEJNMOIlaH+EmssqI9+b9gXK34JwtsXPjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FQZHD8llWVK/lkKtm+UdIT7SJD4lA0UwWXUMBpX3jA4L7bxGwS1rpuYv+1sYNtzH+
         qJtBIAZp3WiY0ITE8X5MoSdQUmQuH9/dsQlenk3GQnz655J+4X7wd1CNLeVWqyTuVJ
         TUgrDPxm7AxAZ/yQUB5qpCWlzX70np6HyiHEx3lY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Antoine Tenart <atenart@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 096/453] crypto: inside-secure - Fix sizeof() mismatch
Date:   Mon, 28 Dec 2020 13:45:32 +0100
Message-Id: <20201228124941.851200237@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit c98e233062cd9d0e2f10e445a671f0799daaef67 ]

An incorrect sizeof() is being used, sizeof(priv->ring[i].rdr_req) is
not correct, it should be sizeof(*priv->ring[i].rdr_req). Note that
since the size of ** is the same size as * this is not causing any
issues.

Addresses-Coverity: ("Sizeof not portable (SIZEOF_MISMATCH)")
Fixes: 9744fec95f06 ("crypto: inside-secure - remove request list to improve performance")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Acked-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/inside-secure/safexcel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/inside-secure/safexcel.c b/drivers/crypto/inside-secure/safexcel.c
index 991a4425f006a..4d9d97c59ee36 100644
--- a/drivers/crypto/inside-secure/safexcel.c
+++ b/drivers/crypto/inside-secure/safexcel.c
@@ -1467,7 +1467,7 @@ static int safexcel_probe_generic(void *pdev,
 
 		priv->ring[i].rdr_req = devm_kcalloc(dev,
 			EIP197_DEFAULT_RING_SIZE,
-			sizeof(priv->ring[i].rdr_req),
+			sizeof(*priv->ring[i].rdr_req),
 			GFP_KERNEL);
 		if (!priv->ring[i].rdr_req)
 			return -ENOMEM;
-- 
2.27.0



