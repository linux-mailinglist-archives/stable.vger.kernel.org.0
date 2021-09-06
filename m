Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B44401475
	for <lists+stable@lfdr.de>; Mon,  6 Sep 2021 03:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347570AbhIFBdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 21:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351757AbhIFBbB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 5 Sep 2021 21:31:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7891761244;
        Mon,  6 Sep 2021 01:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630891461;
        bh=+u8srXkV50xvZ+pOwWTWX4CNnPYo9/ep1rAd/KVOufQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CighZaNCYwrsMdyrao7SA71TNGJDlMwgWwmwyBzqYOeuXX6AlDl6tj4jmN7hu3la5
         95fuHl62OEtn25YMNA66+BzU9Y7G4ZPqpNONhB0PMXi7mnBhXbSkLQCpuCeu8hAZuI
         Mu5IhQ5TKpqkrAYrCiaYz68Z+cc+LWjBRCwdGAY4F0krS8kxHZzoFa+Gu1bhAzFRDc
         cP/NAfuKr8bqoDS7Si8mO39bw9ur5NFKimNZmI1jafhsfgeuygbPEHozSVNU3DKVLo
         Q8J7miMm3GVT8pzFcaM5AIvlVnAlT9gjJloLdjhwFcSf4R+F66S0xy1wXYtudz1tNl
         7sqWwGes90xaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tony Lindgren <tony@atomide.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 04/14] crypto: omap-sham - clear dma flags only after omap_sham_update_dma_stop()
Date:   Sun,  5 Sep 2021 21:24:05 -0400
Message-Id: <20210906012415.931147-4-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210906012415.931147-1-sashal@kernel.org>
References: <20210906012415.931147-1-sashal@kernel.org>
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
index 4adcf89add25..801ae958b0ad 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1745,7 +1745,7 @@ static void omap_sham_done_task(unsigned long data)
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

