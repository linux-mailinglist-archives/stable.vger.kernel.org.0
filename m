Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5FD56DE07
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:26:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731698AbfGSEZ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:25:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731619AbfGSEIk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:08:40 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56E7F218D2;
        Fri, 19 Jul 2019 04:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509320;
        bh=248KId4oJ/UXTy259lxG0UgQmqYIht55telL23IqvEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fdTD+cHIAgJQQDDQHmTmpBqKdicfLxeJDYs9yx+fOO+0osZx/x92k+87rz4WPtMKJ
         q5EdZ4/4+xwUq4CAL7KKP4cLdglC3Uq1Nyf8ZpVxxO7V6gQbwCQRKz5xR4rKAPDTzt
         4Z5yzoxgnvsAZsIPM0cxYxPTvKcWEmDhjBQVZC5M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Young Xiao <92siuyang@gmail.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 032/101] iio:core: Fix bug in length of event info_mask and catch unhandled bits set in masks.
Date:   Fri, 19 Jul 2019 00:06:23 -0400
Message-Id: <20190719040732.17285-32-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040732.17285-1-sashal@kernel.org>
References: <20190719040732.17285-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Young Xiao <92siuyang@gmail.com>

[ Upstream commit 936d3e536dcf88ce80d27bdb637009b13dba6d8c ]

The incorrect limit for the for_each_set_bit loop was noticed whilst fixing
this other case.  Note that as we only have 3 possible entries a the moment
and the value was set to 4, the bug would not have any effect currently.
It will bite fairly soon though, so best fix it now.

See commit ef4b4856593f ("iio:core: Fix bug in length of event info_mask and
catch unhandled bits set in masks.") for details.

Signed-off-by: Young Xiao <92siuyang@gmail.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/industrialio-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 49d4b4f1a457..4bc9ea48da07 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1112,6 +1112,8 @@ static int iio_device_add_info_mask_type_avail(struct iio_dev *indio_dev,
 	char *avail_postfix;
 
 	for_each_set_bit(i, infomask, sizeof(*infomask) * 8) {
+		if (i >= ARRAY_SIZE(iio_chan_info_postfix))
+			return -EINVAL;
 		avail_postfix = kasprintf(GFP_KERNEL,
 					  "%s_available",
 					  iio_chan_info_postfix[i]);
-- 
2.20.1

