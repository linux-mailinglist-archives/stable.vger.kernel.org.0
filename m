Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1A703C556D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355710AbhGLIKO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353653AbhGLICo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 527C361607;
        Mon, 12 Jul 2021 07:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076598;
        bh=n6bSUlpng1DZ730pLoTG2r/SoD7W+ZmcSR6TbvuGNF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jHh3Rr/jr4wPanPibKfRrMUZCPzmiflnqiL6ylavsfRcrlyHVpTf0VRFPdXRhwKZg
         tP3kVUrTIV9Mk3mAGI/xdNJJW9EsCJ3YL6gRpxFIZM6WtMWmMK1Z5fr+n9Z7QmgCWr
         uylV9yPxfGFHn1Xw/zYkJs7Qz+tLOfuQ2CQXhbgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Song Qiang <songqiang1304521@gmail.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 713/800] iio: magn: rm3100: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:12:16 +0200
Message-Id: <20210712061042.598880139@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
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
index dd811da9cb6d..934da20781bb 100644
--- a/drivers/iio/magnetometer/rm3100-core.c
+++ b/drivers/iio/magnetometer/rm3100-core.c
@@ -78,7 +78,8 @@ struct rm3100_data {
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



