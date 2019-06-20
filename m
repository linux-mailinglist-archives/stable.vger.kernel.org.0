Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38E554D8E2
	for <lists+stable@lfdr.de>; Thu, 20 Jun 2019 20:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfFTSDV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jun 2019 14:03:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:54412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727581AbfFTSDT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Jun 2019 14:03:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEDF521479;
        Thu, 20 Jun 2019 18:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561053798;
        bh=S5vSnau8veV4jnNwBCLbUvZEBtP89lQiDn0A+dqi00E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mU2zoeRIpZNg1sovYVawqXoag3Ri+s48wWGQeR93ajiRJ2mhMm6wfxbO2Sgg3yWM2
         QQ1ROvToD3y/CGej2Q02IfNraewV+yjCVS5lut99yuFr3z3SVP6Hno9g4xYHXwjrIF
         INFzNhBgyMpCYIv/ySudjI71iT07Ow/dMNXLivTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 030/117] nvmem: core: fix read buffer in place
Date:   Thu, 20 Jun 2019 19:56:04 +0200
Message-Id: <20190620174353.789250695@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
References: <20190620174351.964339809@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
index 824e282cd80e..bb2f79933b17 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -934,7 +934,7 @@ static inline void nvmem_shift_read_buffer_in_place(struct nvmem_cell *cell,
 						    void *buf)
 {
 	u8 *p, *b;
-	int i, bit_offset = cell->bit_offset;
+	int i, extra, bit_offset = cell->bit_offset;
 
 	p = b = buf;
 	if (bit_offset) {
@@ -949,11 +949,16 @@ static inline void nvmem_shift_read_buffer_in_place(struct nvmem_cell *cell,
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



