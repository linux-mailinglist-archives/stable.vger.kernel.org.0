Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17D51E2AE4
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390617AbgEZS74 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 14:59:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389977AbgEZS74 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 14:59:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59B3220849;
        Tue, 26 May 2020 18:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590519595;
        bh=NebaGoNend4UooMfkkfS/aWjy97aPsiF5iAluBswIgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FzS/gNIFFTUI7nCISV3Ig91/4H1DA0yXd65z6YfRiBHNAhNvv+enMSK5/LzeBMxKN
         cgYiyviXi8VBdQ3QeziPMIoEG3zVIMExoHqiIFAUNHQ3CNUnPl5S94QDdPFrmvzhDO
         wVg9yCPWH0d/zKfdYnHbof6WKQqup7CmcqGNcUyY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 64/64] iio: sca3000: Remove an erroneous get_device()
Date:   Tue, 26 May 2020 20:53:33 +0200
Message-Id: <20200526183931.808755173@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183913.064413230@linuxfoundation.org>
References: <20200526183913.064413230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 928edefbc18cd8433f7df235c6e09a9306e7d580 ]

This looks really unusual to have a 'get_device()' hidden in a 'dev_err()'
call.
Remove it.

While at it add a missing \n at the end of the message.

Fixes: 574fb258d636 ("Staging: IIO: VTI sca3000 series accelerometer driver (spi)")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/iio/accel/sca3000_ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/iio/accel/sca3000_ring.c b/drivers/staging/iio/accel/sca3000_ring.c
index d1cb9b9cf22b..391cbcc4ed77 100644
--- a/drivers/staging/iio/accel/sca3000_ring.c
+++ b/drivers/staging/iio/accel/sca3000_ring.c
@@ -56,7 +56,7 @@ static int sca3000_read_data(struct sca3000_state *st,
 	st->tx[0] = SCA3000_READ_REG(reg_address_high);
 	ret = spi_sync_transfer(st->us, xfer, ARRAY_SIZE(xfer));
 	if (ret) {
-		dev_err(get_device(&st->us->dev), "problem reading register");
+		dev_err(&st->us->dev, "problem reading register");
 		goto error_free_rx;
 	}
 
-- 
2.25.1



