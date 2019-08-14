Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95B138C8B6
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 04:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728262AbfHNCdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 22:33:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728840AbfHNCPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 22:15:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C5471208C2;
        Wed, 14 Aug 2019 02:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565748952;
        bh=mGv52XAZ3d+fAhOzX8m/aRfvStfvvZXLxF0cpc/IqOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ObR0Ptin4aRTgOsnJGHVvvtOkm1YX9grqyPTz3DruwnW4TmKY8OfsqAKEAdzEiV3X
         CXb+YMO97vj7u/iejK0rQsJq4Nq1V+5bRDXWCv5v0pwv5VhCiaqSxwox2r/dHyanIO
         Ix0Q0FYA4pyAI7NwPpBnfk0DHxig907OqTPCyF+w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gwendal Grignou <gwendal@chromium.org>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 02/68] iio: cros_ec_accel_legacy: Fix incorrect channel setting
Date:   Tue, 13 Aug 2019 22:14:40 -0400
Message-Id: <20190814021548.16001-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190814021548.16001-1-sashal@kernel.org>
References: <20190814021548.16001-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gwendal Grignou <gwendal@chromium.org>

[ Upstream commit 6cdff99c9f7d7d28b87cf05dd464f7c7736332ae ]

INFO_SCALE is set both for each channel and all channels.
iio is using all channel setting, so the error was not user visible.

Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/cros_ec_accel_legacy.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iio/accel/cros_ec_accel_legacy.c b/drivers/iio/accel/cros_ec_accel_legacy.c
index 063e89eff791a..c776a3509a717 100644
--- a/drivers/iio/accel/cros_ec_accel_legacy.c
+++ b/drivers/iio/accel/cros_ec_accel_legacy.c
@@ -328,7 +328,6 @@ static const struct iio_chan_spec_ext_info cros_ec_accel_legacy_ext_info[] = {
 		.modified = 1,					        \
 		.info_mask_separate =					\
 			BIT(IIO_CHAN_INFO_RAW) |			\
-			BIT(IIO_CHAN_INFO_SCALE) |			\
 			BIT(IIO_CHAN_INFO_CALIBBIAS),			\
 		.info_mask_shared_by_all = BIT(IIO_CHAN_INFO_SCALE),	\
 		.ext_info = cros_ec_accel_legacy_ext_info,		\
-- 
2.20.1

