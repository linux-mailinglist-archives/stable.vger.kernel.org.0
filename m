Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD2720DF33
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 23:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389055AbgF2UdJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 16:33:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732302AbgF2TZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:25:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BDC12535E;
        Mon, 29 Jun 2020 15:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593445223;
        bh=XSTF3fm7DRjOxknTkfjWDogjJ1+ZAG3jH+aOYLkF0Mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWTgJZuSm35s/zN5SandQKQ9pikRdarPFKjUSqoLLW+0wZjzbE7A8nZ3+2ua7rGve
         GMhBqura4I1SxMhKaSNinO6iW8RWL7ZDL6xDFrzSkZmUjGV8IxO9t4T/WtNGkwjhUr
         a/sd7FNW9nEVPHL21oSfTFxUUSN5ucvWOWF/vvLM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Andreas Klinger <ak@it-klinger.de>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 010/191] iio: bmp280: fix compensation of humidity
Date:   Mon, 29 Jun 2020 11:37:06 -0400
Message-Id: <20200629154007.2495120-11-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629154007.2495120-1-sashal@kernel.org>
References: <20200629154007.2495120-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:39+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
index 36f03fdf4d4f9..85b90b5939db2 100644
--- a/drivers/iio/pressure/bmp280-core.c
+++ b/drivers/iio/pressure/bmp280-core.c
@@ -182,6 +182,8 @@ static u32 bmp280_compensate_humidity(struct bmp280_data *data,
 		+ (s32)2097152) * H2 + 8192) >> 14);
 	var -= ((((var >> 15) * (var >> 15)) >> 7) * (s32)H1) >> 4;
 
+	var = clamp_val(var, 0, 419430400);
+
 	return var >> 12;
 };
 
-- 
2.25.1

