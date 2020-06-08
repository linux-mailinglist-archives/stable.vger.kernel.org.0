Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE931F2D0F
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731721AbgFIAan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:36806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729046AbgFHXPm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A4C32076A;
        Mon,  8 Jun 2020 23:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658142;
        bh=k0fASL0Pv0bHmJ68PchARdT65FgmTMuBEqKx09B/Gs4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fjGc/qoK44jiff90+WGJFQnIaxXDmR1AZdVsvnBrgCd8RQmPVNeFIaVu554Mqa4Su
         QSaDjkdb+lf31f0ik1ekgsP/sWzd3R3Y24HYKxdUALtuz7c4TAMaN6bMdvvDw3CWkV
         wbppzrI7DVcziN9b6V1tnlj3sH1tiQ4M2PyOJgdY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 175/606] iio: sca3000: Remove an erroneous 'get_device()'
Date:   Mon,  8 Jun 2020 19:05:00 -0400
Message-Id: <20200608231211.3363633-175-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 928edefbc18cd8433f7df235c6e09a9306e7d580 upstream.

This looks really unusual to have a 'get_device()' hidden in a 'dev_err()'
call.
Remove it.

While at it add a missing \n at the end of the message.

Fixes: 574fb258d636 ("Staging: IIO: VTI sca3000 series accelerometer driver (spi)")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/sca3000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/sca3000.c b/drivers/iio/accel/sca3000.c
index 66d768d971e1..6e429072e44a 100644
--- a/drivers/iio/accel/sca3000.c
+++ b/drivers/iio/accel/sca3000.c
@@ -980,7 +980,7 @@ static int sca3000_read_data(struct sca3000_state *st,
 	st->tx[0] = SCA3000_READ_REG(reg_address_high);
 	ret = spi_sync_transfer(st->us, xfer, ARRAY_SIZE(xfer));
 	if (ret) {
-		dev_err(get_device(&st->us->dev), "problem reading register");
+		dev_err(&st->us->dev, "problem reading register\n");
 		return ret;
 	}
 
-- 
2.25.1

