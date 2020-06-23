Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F1B6206577
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388118AbgFWUDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:03:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388111AbgFWUDu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:03:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D49B20EDD;
        Tue, 23 Jun 2020 20:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942630;
        bh=CrgVa/Gc9vKnKaRjzNJoH5yqlCiMSJw0IgPSlPn42iM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EggLVt0tyOUrFxzbtIYPUFyWlMSmOC5SX1363+2tLQRzaFvg3Dj2dmWXKbTHlMo5N
         0oxLoYGcIQkWEAvxb/7WG3RXje6vLfFqL4Wg77iFWIMn3JgFIY3g0i6inb2EQlDHyl
         BcQji47Hq6UZ3pSPnICzjij7DNBLIXiWAiQMxt+s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Klinger <ak@it-klinger.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 033/477] iio: bmp280: fix compensation of humidity
Date:   Tue, 23 Jun 2020 21:50:30 +0200
Message-Id: <20200623195409.164817493@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Klinger <ak@it-klinger.de>

[ Upstream commit dee2dabc0e4115b80945fe2c91603e634f4b4686 ]

Limit the output of humidity compensation to the range between 0 and 100
percent.

Depending on the calibration parameters of the individual sensor it
happens, that a humidity above 100 percent or below 0 percent is
calculated, which don't make sense in terms of relative humidity.

Add a clamp to the compensation formula as described in the datasheet of
the sensor in chapter 4.2.3.

Although this clamp is documented, it was never in the driver of the
kernel.

It depends on the circumstances (calibration parameters, temperature,
humidity) if one can see a value above 100 percent without the clamp.
The writer of this patch was working with this type of sensor without
noting this error. So it seems to be a rare event when this bug occures.

Signed-off-by: Andreas Klinger <ak@it-klinger.de>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/bmp280-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/pressure/bmp280-core.c b/drivers/iio/pressure/bmp280-core.c
index 2540e7c2358c1..973264a088f98 100644
--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -271,6 +271,8 @@ static u32 bmp280_compensate_humidity(struct bmp280_data *data,
 		+ (s32)2097152) * calib->H2 + 8192) >> 14);
 	var -= ((((var >> 15) * (var >> 15)) >> 7) * (s32)calib->H1) >> 4;
 
+	var = clamp_val(var, 0, 419430400);
+
 	return var >> 12;
 };
 
-- 
2.25.1



