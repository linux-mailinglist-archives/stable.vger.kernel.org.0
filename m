Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3043C4FB7
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245580AbhGLH1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:27:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:36830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345383AbhGLHZZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:25:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E9296052B;
        Mon, 12 Jul 2021 07:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074556;
        bh=jRKv6eYizbrlcsTnp5IQn5e22UGVdEp1u8WKoEe1Yw0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tEZNmnHGUNcYroavZnm8ej0uM7SCwelCKAXE6WjoEBzM/jsA3O20e3NT5Unyc76oY
         t5dXZyxretvztHlplzyt6dIYWVQjiFvdQH4q+V3OXZF9hgHRaUP2ZmJTu+uJskMdc2
         HAKsYG5l94Uwsjt/Pwm2MnQbgza3016SMsif1HwU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Song Qiang <songqiang1304521@gmail.com>,
        =?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 617/700] iio: magn: rm3100: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:11:40 +0200
Message-Id: <20210712061041.513525795@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index 7242897a05e9..720234a91db1 100644
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



