Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52C441133D2
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:21:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730342AbfLDSIg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:08:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:60828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730018AbfLDSIf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 13:08:35 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9CA02089C;
        Wed,  4 Dec 2019 18:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482915;
        bh=bs5/xyBHOfej+Iw29Cr0qxNf9qYZqmH7Je52HSZx7Pg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AqgTkTwnsmVEkRNfiOy58zCCVjXQ7osseV400aDK8zmovWXPq/giPnPeFt2zNepsv
         pEhJRwrKqBx/6Ya9HkoiGi5D6N0pWPCFqmDPY/WzVCQcQT6S0TNBrZ4PSIdAsb1/BH
         kPMNPdROXZSCZHKxMsuDfN4nVS8ENc1OTXA8l62M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "huijin.park" <huijin.park@samsung.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 184/209] mtd: spi-nor: cast to u64 to avoid uint overflows
Date:   Wed,  4 Dec 2019 18:56:36 +0100
Message-Id: <20191204175336.157081208@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204175321.609072813@linuxfoundation.org>
References: <20191204175321.609072813@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: huijin.park <huijin.park@samsung.com>

commit 84a1c2109d23df3543d96231c4fee1757299bb1a upstream.

The "params->size" is defined as "u64".
And "info->sector_size" and "info->n_sectors" are defined as
unsigned int and u16.
Thus, u64 data might have strange data(loss data) if the result
overflows an unsigned int.
This patch casts "info->sector_size" to an u64.

Signed-off-by: huijin.park <huijin.park@samsung.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/spi-nor/spi-nor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -2382,7 +2382,7 @@ static int spi_nor_init_params(struct sp
 	memset(params, 0, sizeof(*params));
 
 	/* Set SPI NOR sizes. */
-	params->size = info->sector_size * info->n_sectors;
+	params->size = (u64)info->sector_size * info->n_sectors;
 	params->page_size = info->page_size;
 
 	/* (Fast) Read settings. */


