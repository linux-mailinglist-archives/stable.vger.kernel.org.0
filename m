Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4AB72F22D
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbfE3ETU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:19:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730286AbfE3DP0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:15:26 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F74824563;
        Thu, 30 May 2019 03:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186126;
        bh=0s+FdrxQyBQqyT7+UtTeo2sVNyCRXt20aXWkTRMk/MI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WtRoLHl1tIDA14DYYG+s4DV7RA9p7cuKIle5TaqbuHkQoFs+l0btgQDTfNIJrqf0v
         1Usv5oLdjZwAl78n/YtcJUyAFeE0hh7/CThbvxJWPNkc3x2e23b64wWRdOuz6StaUD
         TXBO4dE5hPHt9PNiy+HbiA27Bg4O8OW1+xMuz3e4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rouven Czerwinski <r.czerwinski@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 285/346] hwrng: omap - Set default quality
Date:   Wed, 29 May 2019 20:05:58 -0700
Message-Id: <20190530030555.348375534@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.363386121@linuxfoundation.org>
References: <20190530030540.363386121@linuxfoundation.org>
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



