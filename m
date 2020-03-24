Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE2F6190FF1
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729612AbgCXNYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:24:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:47686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729603AbgCXNYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:24:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9EBB208D6;
        Tue, 24 Mar 2020 13:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056252;
        bh=mB8hwxF60k8fq1kjgKp5j7nNZ/XLg8D4GNOSc+RwuRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oDn5ekAs+68ZUEyr78NHduYokkYBe5G1xy9h5FXKhLGc4cNExzG341h8P2yBYts5m
         MShV20ig9G3swYSkC61XXdXqJjtAIzlj146ylEVKmB5/gTImFfgBqo5kR7f947Sph2
         WeJpOMcHiI+w1/z3RuQtsg59K56NPvksfSjb8AFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Tomas Novotny <tomas@novotny.cz>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.5 069/119] iio: light: vcnl4000: update sampling periods for vcnl4200
Date:   Tue, 24 Mar 2020 14:10:54 +0100
Message-Id: <20200324130815.114746406@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130808.041360967@linuxfoundation.org>
References: <20200324130808.041360967@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomas Novotny <tomas@novotny.cz>

commit b42aa97ed5f1169cfd37175ef388ea62ff2dcf43 upstream.

Vishay has published a new version of "Designing the VCNL4200 Into an
Application" application note in October 2019. The new version specifies
that there is +-20% of part to part tolerance. This explains the drift
seen during experiments. The proximity pulse width is also changed from
32us to 30us. According to the support, the tolerance also applies to
ambient light.

So update the sampling periods. As the reading is blocking, current
users may notice slightly longer response time.

Fixes: be38866fbb97 ("iio: vcnl4000: add support for VCNL4200")
Reviewed-by: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Tomas Novotny <tomas@novotny.cz>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/vcnl4000.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -167,10 +167,10 @@ static int vcnl4200_init(struct vcnl4000
 	data->vcnl4200_ps.reg = VCNL4200_PS_DATA;
 	switch (id) {
 	case VCNL4200_PROD_ID:
-		/* Integration time is 50ms, but the experiments */
-		/* show 54ms in total. */
-		data->vcnl4200_al.sampling_rate = ktime_set(0, 54000 * 1000);
-		data->vcnl4200_ps.sampling_rate = ktime_set(0, 4200 * 1000);
+		/* Default wait time is 50ms, add 20% tolerance. */
+		data->vcnl4200_al.sampling_rate = ktime_set(0, 60000 * 1000);
+		/* Default wait time is 4.8ms, add 20% tolerance. */
+		data->vcnl4200_ps.sampling_rate = ktime_set(0, 5760 * 1000);
 		data->al_scale = 24000;
 		break;
 	case VCNL4040_PROD_ID:


