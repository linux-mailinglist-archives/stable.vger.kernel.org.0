Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F171408E82
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241690AbhIMNfl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:35:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242487AbhIMN3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:29:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1ADEA6134F;
        Mon, 13 Sep 2021 13:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539452;
        bh=gHOyesAu68sPGrpUkzJYHyLALtuFHcCbITcL8Zix2Fw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a/Lh9/xkiSUydyHxVPfzxcrjBWrVlOPwEY0nu3eAFbx+l83PCXF9NbzTCCSFYpngR
         QAQ0Te8GCz4q/bZLJhMI+AZq5SdzpszpBH4TCtnC5DfgJ7F7tKlJ/dQrCv0E0RlX7y
         cYvzeS58ghP5mhiTXQ5PRPhRL/4evA6ooOvvdDpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lokesh Vutla <lokeshvutla@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/236] crypto: omap-sham - clear dma flags only after omap_sham_update_dma_stop()
Date:   Mon, 13 Sep 2021 15:11:52 +0200
Message-Id: <20210913131100.571436939@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



