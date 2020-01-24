Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94138148280
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391595AbgAXL2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:28:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391701AbgAXL2h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:28:37 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D98B206D4;
        Fri, 24 Jan 2020 11:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579865317;
        bh=+x4BIgm+Rs6J0btz+KE1I3ThRuf5C+ViDg8xfrtN6jQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xf5vey7TeQ/aFtCUy61bX/YqeIc5ILtmWpRVbdxuUrHM+s9PAuSeqy35XuBlGNeYE
         nw7C32Gr9utP5BoAV+pi0eFVYF7uFhff1B39sMrG3hvrg9Ij63VWxKwJLSyY16Dwwo
         W21Gs5qbZb/SFZ73rqWEZck37gD9yzkd1NyP5jmk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Iuliana Prodan <iuliana.prodan@nxp.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 500/639] crypto: caam - free resources in case caam_rng registration failed
Date:   Fri, 24 Jan 2020 10:31:10 +0100
Message-Id: <20200124093151.429439072@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Iuliana Prodan <iuliana.prodan@nxp.com>

[ Upstream commit c59a1d41672a89b5cac49db1a472ff889e35a2d2 ]

Check the return value of the hardware registration for caam_rng and free
resources in case of failure.

Fixes: e24f7c9e87d4 ("crypto: caam - hwrng support")
Signed-off-by: Iuliana Prodan <iuliana.prodan@nxp.com>
Reviewed-by: Horia Geanta <horia.geanta@nxp.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/caam/caamrng.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/caam/caamrng.c b/drivers/crypto/caam/caamrng.c
index fde07d4ff0190..ff6718a11e9ec 100644
--- a/drivers/crypto/caam/caamrng.c
+++ b/drivers/crypto/caam/caamrng.c
@@ -353,7 +353,10 @@ static int __init caam_rng_init(void)
 		goto free_rng_ctx;
 
 	dev_info(dev, "registering rng-caam\n");
-	return hwrng_register(&caam_rng);
+
+	err = hwrng_register(&caam_rng);
+	if (!err)
+		return err;
 
 free_rng_ctx:
 	kfree(rng_ctx);
-- 
2.20.1



