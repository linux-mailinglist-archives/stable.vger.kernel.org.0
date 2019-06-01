Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF0EC31D0D
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728900AbfFAN0p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:26:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:57234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729751AbfFAN0m (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:26:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65FB4273D6;
        Sat,  1 Jun 2019 13:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395602;
        bh=E44K6u0AaT1GBKv+qHskQRRbLlS+AhDW1bjxk7I26xY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1QvPnl5FZuzMdKgI8kxiOvmDJLx6BxbiggTbNSDJyuybrPt1OxI1AznMsHkRBOKNg
         mWFWcAS2zPxMAeJCMiad0K1iSRbH2jUOOkGiSJF1RvMhgsC4fWHtH6OdDzEvyKs022
         7O2J4f5um/BC5TDUSscy4fTzt0U+GR+f8xZVqXd0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 21/56] nvmem: core: fix read buffer in place
Date:   Sat,  1 Jun 2019 09:25:25 -0400
Message-Id: <20190601132600.27427-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>

[ Upstream commit 2fe518fecb3a4727393be286db9804cd82ee2d91 ]

When the bit_offset in the cell is zero, the pointer to the msb will
not be properly initialized (ie, will still be pointing to the first
byte in the buffer).

This being the case, if there are bits to clear in the msb, those will
be left untouched while the mask will incorrectly clear bit positions
on the first byte.

This commit also makes sure that any byte unused in the cell is
cleared.

Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 6fd4e5a5ef4a4..931cc33e46f02 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -789,7 +789,7 @@ static inline void nvmem_shift_read_buffer_in_place(struct nvmem_cell *cell,
 						    void *buf)
 {
 	u8 *p, *b;
-	int i, bit_offset = cell->bit_offset;
+	int i, extra, bit_offset = cell->bit_offset;
 
 	p = b = buf;
 	if (bit_offset) {
@@ -804,11 +804,16 @@ static inline void nvmem_shift_read_buffer_in_place(struct nvmem_cell *cell,
 			p = b;
 			*b++ >>= bit_offset;
 		}
-
-		/* result fits in less bytes */
-		if (cell->bytes != DIV_ROUND_UP(cell->nbits, BITS_PER_BYTE))
-			*p-- = 0;
+	} else {
+		/* point to the msb */
+		p += cell->bytes - 1;
 	}
+
+	/* result fits in less bytes */
+	extra = cell->bytes - DIV_ROUND_UP(cell->nbits, BITS_PER_BYTE);
+	while (--extra >= 0)
+		*p-- = 0;
+
 	/* clear msb bits if any leftover in the last byte */
 	*p &= GENMASK((cell->nbits%BITS_PER_BYTE) - 1, 0);
 }
-- 
2.20.1

