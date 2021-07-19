Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41DD3CDDBF
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:41:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243163AbhGSPAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:00:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:53792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343496AbhGSO7G (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 484A1613F7;
        Mon, 19 Jul 2021 15:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709007;
        bh=eEm72G8V7KlveK6mKI0MQVvwWrPp8W3SBpcrY+CGJPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r8YW3rjs5tHEilEQCTH7o6LCfcKCihXQYmnJFDoADnqWauO15pqevYauDclUlmAk5
         5GFkHzTiilIEhC+xu9NxKtkYxV2nT9o5q7wBQfp2E7NvpiQvGfVfo6SZLCpC6XwZYf
         GpNUFeq0NQJgZSjESRwM105R36uVw+Sls1ougFKg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 184/421] iio: potentiostat: lmp91000: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()
Date:   Mon, 19 Jul 2021 16:49:55 +0200
Message-Id: <20210719144952.802599953@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 8979b67ec61abc232636400ee8c758a16a73c95f ]

Add __aligned(8) to ensure the buffer passed to
iio_push_to_buffers_with_timestamp() is suitable for the naturally
aligned timestamp that will be inserted.

Here structure is not used, because this buffer is also used
elsewhere in the driver.

Fixes: 67e17300dc1d ("iio: potentiostat: add LMP91000 support")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
Link: https://lore.kernel.org/r/20210501171352.512953-8-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/potentiostat/lmp91000.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/potentiostat/lmp91000.c b/drivers/iio/potentiostat/lmp91000.c
index 90e895adf997..68f4f6fa27da 100644
--- a/drivers/iio/potentiostat/lmp91000.c
+++ b/drivers/iio/potentiostat/lmp91000.c
@@ -71,8 +71,8 @@ struct lmp91000_data {
 
 	struct completion completion;
 	u8 chan_select;
-
-	u32 buffer[4]; /* 64-bit data + 64-bit timestamp */
+	/* 64-bit data + 64-bit naturally aligned timestamp */
+	u32 buffer[4] __aligned(8);
 };
 
 static const struct iio_chan_spec lmp91000_channels[] = {
-- 
2.30.2



