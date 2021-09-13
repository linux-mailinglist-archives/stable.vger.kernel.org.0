Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74814408DD1
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240164AbhIMNaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:30:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240121AbhIMNTz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:19:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E320A610D1;
        Mon, 13 Sep 2021 13:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539054;
        bh=kfvp6RxnixOZswBUFl3mXIebYjbttY6adhaxG+mPoPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aXN0Grnl3tTSPirKcS71qC9lhLDABgpeBOVzFBw8mzQhbiHEp2ZN2e9+KxyraZjTG
         zKBN4PrwcAwGlWx6QhJVU4/Z+GXu80SFQUwVe+JIua8wyaneIw7P9TKVBIqVS74yLw
         FNh7aDWUDCFAhghztMfQ3M/IOSIJ41XfjlBZVzPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lokesh Vutla <lokeshvutla@ti.com>,
        Tero Kristo <kristo@kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 006/144] crypto: omap-sham - clear dma flags only after omap_sham_update_dma_stop()
Date:   Mon, 13 Sep 2021 15:13:07 +0200
Message-Id: <20210913131048.179097971@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131047.974309396@linuxfoundation.org>
References: <20210913131047.974309396@linuxfoundation.org>
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
index f80db1eb2994..f8a146554b1f 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -1734,7 +1734,7 @@ static void omap_sham_done_task(unsigned long data)
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



