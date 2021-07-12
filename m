Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E473C4A9D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239836AbhGLGxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:53:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:45530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239116AbhGLGt3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:49:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E09D9611CC;
        Mon, 12 Jul 2021 06:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626072361;
        bh=ONp5s8e9lBqNJQX/FqHlhfSjBwaICUWY6VJlA7i7pwE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kPv7G4qnJ7dwAwDhJNyHMHf9kOSUUH+eFBusf+ja79VTX/+EFO+ZBA+qzFaRFgOzT
         eX43NDsvIzgMmNVVVHzvDlqAEVcidCruk+JC6lo3g90SIJBGEFCewmFNIqGBb7xs/c
         VV8bDNt2NQcWOjcrr1iyeBW+56XJPdu6AR6Myd5k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 464/593] iio: chemical: atlas: Fix buffer alignment in iio_push_to_buffers_with_timestamp()
Date:   Mon, 12 Jul 2021 08:10:24 +0200
Message-Id: <20210712060940.785119440@linuxfoundation.org>
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

[ Upstream commit b0f5d8db7348a6ce5cdd79fba46ebc91eebc8fd9 ]

Variable location for the timestamp, so just use __aligned(8)
to ensure it is always possible to naturally align it.

Found during an audit of all calls of uses of
iio_push_to_buffers_with_timestamp()

Fixes tag is not accurate, but it will need manual backporting beyond
that point if anyone cares.

Fixes: 0d15190f53b4 ("iio: chemical: atlas-ph-sensor: rename atlas-ph-sensor to atlas-sensor")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Matt Ranostay <matt.ranostay@konsulko.com>
Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
Link: https://lore.kernel.org/r/20210501171352.512953-6-jic23@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/chemical/atlas-sensor.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/chemical/atlas-sensor.c b/drivers/iio/chemical/atlas-sensor.c
index cdab9d04dedd..0c8a50de8940 100644
--- a/drivers/iio/chemical/atlas-sensor.c
+++ b/drivers/iio/chemical/atlas-sensor.c
@@ -91,8 +91,8 @@ struct atlas_data {
 	struct regmap *regmap;
 	struct irq_work work;
 	unsigned int interrupt_enabled;
-
-	__be32 buffer[6]; /* 96-bit data + 32-bit pad + 64-bit timestamp */
+	/* 96-bit data + 32-bit pad + 64-bit timestamp */
+	__be32 buffer[6] __aligned(8);
 };
 
 static const struct regmap_config atlas_regmap_config = {
-- 
2.30.2



