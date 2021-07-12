Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452603C4A9E
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239863AbhGLGxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:53:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239100AbhGLGt2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:49:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9ADB761351;
        Mon, 12 Jul 2021 06:46:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072366;
        bh=T4SOJDAGaGvBB1zOWOd+Gwxx6lJYSYyimlTfcsBfXXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HCLD2PXggzxipGLeSGeg+//orWq+UoTvIzyNDhmjkJaz+BgP5MeSnOxjmE0oelFM+
         WbmskhRzOWio8TMfHWXUeJ1+0k2Anobgq3jcrMoqm1t83f6iDx6ZCoklU6HHzk4u58
         3800SeXtHaMjwkfEyS+O1zklO+OqBsMKeDFyCJcs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 466/593] iio: potentiostat: lmp91000: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:26 +0200
Message-Id: <20210712060941.134421885@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
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
index f34ca769dc20..d7ff74a798ba 100644
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



