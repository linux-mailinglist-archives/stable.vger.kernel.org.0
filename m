Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF5EE2EE8C
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732917AbfE3DsJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:48:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732176AbfE3DUW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:20:22 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B315124929;
        Thu, 30 May 2019 03:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186421;
        bh=hLBNMSxSz/L4jAZKh/L2aL9dvFAHIK+33TJbtnPfNkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v6aponoBhS9j6qhfd5227MusfLsWtPGPEvcq911mrskiZ2ob5eruiu0S50+M+MCCu
         nNgai0f/CpXDVAN3WGOgxk1vPzc4ggtdyPQISKAKw861kn7C0HCf7apmXCG9eEaaZg
         GvQjT8IX+m663uCX7gKlcYcVxGKe/aLtreTbqQXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rouven Czerwinski <r.czerwinski@pengutronix.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 176/193] hwrng: omap - Set default quality
Date:   Wed, 29 May 2019 20:07:10 -0700
Message-Id: <20190530030512.241993153@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
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
index 74d11ae6abe9a..25173454efa32 100644
--- a/drivers/char/hw_random/omap-rng.c
+++ b/drivers/char/hw_random/omap-rng.c
@@ -442,6 +442,7 @@ static int omap_rng_probe(struct platform_device *pdev)
 	priv->rng.read = omap_rng_do_read;
 	priv->rng.init = omap_rng_init;
 	priv->rng.cleanup = omap_rng_cleanup;
+	priv->rng.quality = 900;
 
 	priv->rng.priv = (unsigned long)priv;
 	platform_set_drvdata(pdev, priv);
-- 
2.20.1



