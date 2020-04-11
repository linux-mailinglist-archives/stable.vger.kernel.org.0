Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C42D81A515D
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgDKMRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:17:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727092AbgDKMRX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:17:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB67A20644;
        Sat, 11 Apr 2020 12:17:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607443;
        bh=cxaqw+gj13L48qPCR+g9Lk8enKGNLTboZwEzcZD5KLs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KqKiTU8cW1D3eJW6H+qmxqfdWXv2JxM2+D6wzN2VFdj7gNTHVsMJ+Bm/n/Z3QQKCI
         zJp1SqgMdOGhNfwtfyYRffm/BMsM4CIuKsSvBsikVxFI6aMWMMAnOI2cw5QvQapE3D
         iWPdbDkLTi/XA/r0Z4dZJoiXSGx3O4e+j492JAQ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Martin Kaiser <martin@kaiser.cx>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.4 21/41] hwrng: imx-rngc - fix an error path
Date:   Sat, 11 Apr 2020 14:09:30 +0200
Message-Id: <20200411115505.564083016@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115504.124035693@linuxfoundation.org>
References: <20200411115504.124035693@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Kaiser <martin@kaiser.cx>

commit 47a1f8e8b3637ff5f7806587883d7d94068d9ee8 upstream.

Make sure that the rngc interrupt is masked if the rngc self test fails.
Self test failure means that probe fails as well. Interrupts should be
masked in this case, regardless of the error.

Cc: stable@vger.kernel.org
Fixes: 1d5449445bd0 ("hwrng: mx-rngc - add a driver for Freescale RNGC")
Reviewed-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Signed-off-by: Martin Kaiser <martin@kaiser.cx>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/char/hw_random/imx-rngc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/char/hw_random/imx-rngc.c
+++ b/drivers/char/hw_random/imx-rngc.c
@@ -105,8 +105,10 @@ static int imx_rngc_self_test(struct imx
 		return -ETIMEDOUT;
 	}
 
-	if (rngc->err_reg != 0)
+	if (rngc->err_reg != 0) {
+		imx_rngc_irq_mask_clear(rngc);
 		return -EIO;
+	}
 
 	return 0;
 }


