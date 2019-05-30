Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3313C2F4FE
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbfE3EnW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:43:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:53754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728199AbfE3DML (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:12:11 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A1E8244EF;
        Thu, 30 May 2019 03:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185931;
        bh=0s+FdrxQyBQqyT7+UtTeo2sVNyCRXt20aXWkTRMk/MI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iA9/bT7Loi20LXhPBkOsfcPstjtboNPlXTS2ioB5gpLthzT7vKgOrr8k5iHATwsbF
         6bZhDWh+0ZkVOdCdF2n4Livkn+x9J04L9b4inl/2jt6MtnVRFpF+sG0HRYUcaBeHGf
         3chupx3rqi7o9QiO/l0Djj9Lix859WBN/JrxRQTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rouven Czerwinski <r.czerwinski@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 325/405] hwrng: omap - Set default quality
Date:   Wed, 29 May 2019 20:05:23 -0700
Message-Id: <20190530030557.190127753@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 62f95ae805fa9e1e84d47d3219adddd97b2654b7 ]

Newer combinations of the glibc, kernel and openssh can result in long initial
startup times on OMAP devices:

[    6.671425] systemd-rc-once[102]: Creating ED25519 key; this may take some time ...
[  142.652491] systemd-rc-once[102]: Creating ED25519 key; done.

due to the blocking getrandom(2) system call:

[  142.610335] random: crng init done

Set the quality level for the omap hwrng driver allowing the kernel to use the
hwrng as an entropy source at boot.

Signed-off-by: Rouven Czerwinski <r.czerwinski@pengutronix.de>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/omap-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/omap-rng.c b/drivers/char/hw_random/omap-rng.c
index b65ff69628995..e9b6ac61fb7f6 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -443,6 +443,7 @@ static int omap_rng_probe(struct platform_device *pdev)
 	priv->rng.read = omap_rng_do_read;
 	priv->rng.init = omap_rng_init;
 	priv->rng.cleanup = omap_rng_cleanup;
+	priv->rng.quality = 900;
 
 	priv->rng.priv = (unsigned long)priv;
 	platform_set_drvdata(pdev, priv);
-- 
2.20.1



