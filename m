Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B9C5401364
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240522AbhIFBZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:25:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:39352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239977AbhIFBYJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:24:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 763D56103C;
        Mon,  6 Sep 2021 01:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891322;
        bh=gHOyesAu68sPGrpUkzJYHyLALtuFHcCbITcL8Zix2Fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mmDU6ESXacpJ4lg5fb2QsckipD6SlMQr8FnCYsB1oo5VEvqMCWtJV0K6qze8l8UDh
         WlkGI/KWgWCfYCOlkpySvLRNPk+t1yJv4+pH5jssM2COTE3GT085EjfKHB0dTlmxmR
         zeKxUEyOfIfD6Hfm2ZFxFhiQWP/RPh7j0OA/zF+fIjidyAHkwcFpHRNzdPsH9RUWzt
         hTwW4gWIZMOqtOnH+1ZkQurLTxai9232rNWpiAmQrRNLTXf8GMhI0x9xE8qOGrVy0U
         h3IWjRdZn9vYebBXiwWX+SN+f+Gkb9pdjvuwYxxIMLgkpNE8o3bXKUZKRbZhnMRrBX
         kSh79tJUYu0tA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 07/39] crypto: omap-sham - clear dma flags only after omap_sham_update_dma_stop()
Date:   Sun,  5 Sep 2021 21:21:21 -0400
Message-Id: <20210906012153.929962-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012153.929962-1-sashal@kernel.org>
References: <20210906012153.929962-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit fe28140b3393b0ba1eb95cc109f974a7e58b26fd ]

We should not clear FLAGS_DMA_ACTIVE before omap_sham_update_dma_stop() is
done calling dma_unmap_sg(). We already clear FLAGS_DMA_ACTIVE at the
end of omap_sham_update_dma_stop().

The early clearing of FLAGS_DMA_ACTIVE is not causing issues as we do not
need to defer anything based on FLAGS_DMA_ACTIVE currently. So this can be
applied as clean-up.

Cc: Lokesh Vutla <lokeshvutla@ti.com>
Cc: Tero Kristo <kristo@kernel.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-sham.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 39d17ed1db2f..f6a8ae8a18c2 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1735,7 +1735,7 @@ static void omap_sham_done_task(unsigned long data)
 		if (test_and_clear_bit(FLAGS_OUTPUT_READY, &dd->flags))
 			goto finish;
 	} else if (test_bit(FLAGS_DMA_READY, &dd->flags)) {
-		if (test_and_clear_bit(FLAGS_DMA_ACTIVE, &dd->flags)) {
+		if (test_bit(FLAGS_DMA_ACTIVE, &dd->flags)) {
 			omap_sham_update_dma_stop(dd);
 			if (dd->err) {
 				err = dd->err;
-- 
2.30.2

