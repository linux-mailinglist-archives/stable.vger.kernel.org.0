Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3C6145541
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbgAVNUS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:20:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729368AbgAVNUS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:20:18 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C60DF2467A;
        Wed, 22 Jan 2020 13:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699217;
        bh=JSqun9nJBN4MdPIwWzdJTXE21YaHq+B7jgEJA9Z1utg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxSiGhvknzwG/JDARB6zdrxCTVVFwhCW/LbGNVIudzvGrMeaM1qzXOqzbb9DGQrzB
         gUsHZvN/DlypIo62+Kgm4t2T+V8xvGjRSxHZOyZ3SFF/4iVItSuWhzm+mhCJ1cRIqp
         MbxnOeQDuCSXlKcU2iWum2Xk4ICGFTvaEGZcB33I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Marco Felsch <m.felsch@pengutronix.de>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 040/222] iio: light: vcnl4000: Fix scale for vcnl4040
Date:   Wed, 22 Jan 2020 10:27:06 +0100
Message-Id: <20200122092836.405074922@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guido Günther <agx@sigxcpu.org>

commit bc80573ea25bb033a58da81b3ce27205b97c088e upstream.

According to the data sheet the ambient sensor's scale is 0.12 lux/step
(not 0.024 lux/step as used by vcnl4200) when the integration time is
80ms. The integration time is currently hardcoded in the driver to that
value.

See p. 8 in https://www.vishay.com/docs/84307/designingvcnl4040.pdf

Fixes: 5a441aade5b3 ("iio: light: vcnl4000 add support for the VCNL4040 proximity and light sensor")
Signed-off-by: Guido Günther <agx@sigxcpu.org>
Reviewed-by: Marco Felsch <m.felsch@pengutronix.de>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/vcnl4000.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -163,7 +163,6 @@ static int vcnl4200_init(struct vcnl4000
 	if (ret < 0)
 		return ret;
 
-	data->al_scale = 24000;
 	data->vcnl4200_al.reg = VCNL4200_AL_DATA;
 	data->vcnl4200_ps.reg = VCNL4200_PS_DATA;
 	switch (id) {
@@ -172,11 +171,13 @@ static int vcnl4200_init(struct vcnl4000
 		/* show 54ms in total. */
 		data->vcnl4200_al.sampling_rate = ktime_set(0, 54000 * 1000);
 		data->vcnl4200_ps.sampling_rate = ktime_set(0, 4200 * 1000);
+		data->al_scale = 24000;
 		break;
 	case VCNL4040_PROD_ID:
 		/* Integration time is 80ms, add 10ms. */
 		data->vcnl4200_al.sampling_rate = ktime_set(0, 100000 * 1000);
 		data->vcnl4200_ps.sampling_rate = ktime_set(0, 100000 * 1000);
+		data->al_scale = 120000;
 		break;
 	}
 	data->vcnl4200_al.last_measurement = ktime_set(0, 0);


