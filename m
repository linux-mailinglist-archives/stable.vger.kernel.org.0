Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06148119E2C
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbfLJWbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:31:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728107AbfLJWbM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:31:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2872B2073D;
        Tue, 10 Dec 2019 22:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576017071;
        bh=B1QIwygrLOhokb6wIsVKv19GcVnKSWWMr+sjIqDHfZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aS5ih6bHImVN+LpAodVrPU7Vwym2QLfb4LyusboWsVsnVzWORyhH+QZLeQO6SXC7W
         cetolBhGfhbBvDdqg9GFDlfEO9cK6sN36HLCAFfKJg9/yK5ziq52B/Ol/ySOFfESxy
         dg90+vgrJHKPaUnPuT3YTV7i0oejwU3oNcslU/nA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Matt Ranostay <matt.ranostay@konsulko.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 30/91] iio: chemical: atlas-ph-sensor: fix iio_triggered_buffer_predisable() position
Date:   Tue, 10 Dec 2019 17:29:34 -0500
Message-Id: <20191210223035.14270-30-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210223035.14270-1-sashal@kernel.org>
References: <20191210223035.14270-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

[ Upstream commit 0c8a6e72f3c04bfe92a64e5e0791bfe006aabe08 ]

The iio_triggered_buffer_{predisable,postenable} functions attach/detach
the poll functions.

The iio_triggered_buffer_predisable() should be called last, to detach the
poll func after the devices has been suspended.

The position of iio_triggered_buffer_postenable() is correct.

Note this is not stable material. It's a fix in the logical
model rather fixing an actual bug.  These are being tidied up
throughout the subsystem to allow more substantial rework that
was blocked by variations in how things were done.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Acked-by: Matt Ranostay <matt.ranostay@konsulko.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/chemical/atlas-ph-sensor.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/chemical/atlas-ph-sensor.c b/drivers/iio/chemical/atlas-ph-sensor.c
index dad2a8be68308..f5859c118a44a 100644
--- a/drivers/iio/chemical/atlas-ph-sensor.c
+++ b/drivers/iio/chemical/atlas-ph-sensor.c
@@ -331,16 +331,16 @@ static int atlas_buffer_predisable(struct iio_dev *indio_dev)
 	struct atlas_data *data = iio_priv(indio_dev);
 	int ret;
 
-	ret = iio_triggered_buffer_predisable(indio_dev);
+	ret = atlas_set_interrupt(data, false);
 	if (ret)
 		return ret;
 
-	ret = atlas_set_interrupt(data, false);
+	pm_runtime_mark_last_busy(&data->client->dev);
+	ret = pm_runtime_put_autosuspend(&data->client->dev);
 	if (ret)
 		return ret;
 
-	pm_runtime_mark_last_busy(&data->client->dev);
-	return pm_runtime_put_autosuspend(&data->client->dev);
+	return iio_triggered_buffer_predisable(indio_dev);
 }
 
 static const struct iio_trigger_ops atlas_interrupt_trigger_ops = {
-- 
2.20.1

