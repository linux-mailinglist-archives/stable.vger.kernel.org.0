Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6AC1191072
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbgCXN2Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:28:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729626AbgCXNYP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:24:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64C2E208C3;
        Tue, 24 Mar 2020 13:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585056254;
        bh=8mS+FAB8IVF5c9q/iWbsjfm8yNBggi4EvZnRV6LkbJU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jCJtVRVQNyQc09xrlY4TCcSEMqZQzm/xSN9o+Xyqu/O5GPg9NzYvDV1yJ+IrLeWqV
         3pznB7b9JTsn6aySnwC0bD27FMcmOSbEqS1Vt9vdbWxIVGXRbFImIHbZk5vuNelmNB
         1uOiHOTK9XSsJuWHJwLFzbGveqXXOC5f6k29R5Ik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Guido=20G=C3=BCnther?= <agx@sigxcpu.org>,
        Tomas Novotny <tomas@novotny.cz>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.5 070/119] iio: light: vcnl4000: update sampling periods for vcnl4040
Date:   Tue, 24 Mar 2020 14:10:55 +0100
Message-Id: <20200324130815.212874676@linuxfoundation.org>
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

commit 2ca5a8792d617b4035aacd0a8be527f667fbf912 upstream.

Vishay has published a new version of "Designing the VCNL4200 Into an
Application" application note in October 2019. The new version specifies
that there is +-20% of part to part tolerance. Although the application
note is related to vcnl4200, according to support the vcnl4040's "ASIC
is quite similar to that one for the VCNL4200".

So update the sampling periods (and comment), including the correct
sampling period for proximity. Both sampling periods are lower. Users
relying on the blocking behaviour of reading will get proximity
measurements much earlier.

Fixes: 5a441aade5b3 ("iio: light: vcnl4000 add support for the VCNL4040 proximity and light sensor")
Reviewed-by: Guido Günther <agx@sigxcpu.org>
Tested-by: Guido Günther <agx@sigxcpu.org>
Signed-off-by: Tomas Novotny <tomas@novotny.cz>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/vcnl4000.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -174,9 +174,10 @@ static int vcnl4200_init(struct vcnl4000
 		data->al_scale = 24000;
 		break;
 	case VCNL4040_PROD_ID:
-		/* Integration time is 80ms, add 10ms. */
-		data->vcnl4200_al.sampling_rate = ktime_set(0, 100000 * 1000);
-		data->vcnl4200_ps.sampling_rate = ktime_set(0, 100000 * 1000);
+		/* Default wait time is 80ms, add 20% tolerance. */
+		data->vcnl4200_al.sampling_rate = ktime_set(0, 96000 * 1000);
+		/* Default wait time is 5ms, add 20% tolerance. */
+		data->vcnl4200_ps.sampling_rate = ktime_set(0, 6000 * 1000);
 		data->al_scale = 120000;
 		break;
 	}


