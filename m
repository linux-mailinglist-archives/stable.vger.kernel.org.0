Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FAC3C4770
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:27:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235704AbhGLGco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:32:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235973AbhGLG3k (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 60FA161221;
        Mon, 12 Jul 2021 06:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071188;
        bh=qjYi6dlzdwkeUyJMDizN4xGrxDGiQNChSWKqxAa0i80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FviBlwWilkgblpuO73Ag8W9nIKNFAUePycWs71CJ/KJR1oZ2CWJ/xQfQVNJ2oTWqC
         hBzOPen2UMDl/JzGf78Ddno+cVXeE82THGEFSWPlT0bGt8So+dAcfxOHD4JARhRrJk
         sEBemJAyxdzHb6BRNEmk81jl2+xEmYv7JIGbhulU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Song Qiang <songqiang1304521@gmail.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 313/348] iio: magn: rm3100: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:11:37 +0200
Message-Id: <20210712060745.445343473@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit b8f939fd20690623cb24845a563e7bc1e4a21482 ]

Add __aligned(8) to ensure the buffer passed to
iio_push_to_buffers_with_timestamp() is suitable for the naturally
aligned timestamp that will be inserted.

Here an explicit structure is not used, because this buffer is used in
a non-trivial way for data repacking.

Fixes: 121354b2eceb ("iio: magnetometer: Add driver support for PNI RM3100")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Song Qiang <songqiang1304521@gmail.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20210613152301.571002-6-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/magnetometer/rm3100-core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/magnetometer/rm3100-core.c b/drivers/iio/magnetometer/rm3100-core.c
index 7c20918d8108..f31ff225fe61 100644
--- a/drivers/iio/magnetometer/rm3100-core.c
+++ b/drivers/iio/magnetometer/rm3100-core.c
@@ -76,7 +76,8 @@ struct rm3100_data {
 	bool use_interrupt;
 	int conversion_time;
 	int scale;
-	u8 buffer[RM3100_SCAN_BYTES];
+	/* Ensure naturally aligned timestamp */
+	u8 buffer[RM3100_SCAN_BYTES] __aligned(8);
 	struct iio_trigger *drdy_trig;
 
 	/*
-- 
2.30.2



