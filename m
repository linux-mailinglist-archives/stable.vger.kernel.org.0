Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBCD3119BED
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 23:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbfLJWMT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 17:12:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:33928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727956AbfLJWDj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 17:03:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1571E24653;
        Tue, 10 Dec 2019 22:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576015418;
        bh=gD1W76kL8X7UVNMDJci8laqVu1XV2u7VpXQq0xu/VwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z5EVC1oz98RYaacm3QDpN16JiIA8kwwgirm6m0NroQt74A178wldDvvH+LEvLUi2r
         3EJt/24a5wpKiVY5VRpsLSFCg/GhjxF6E2W2/12lg7VyJGJLGCdqcD0ZK0JwYlwZNl
         UjVFPUucDnNuZUkITTSkvjceT93ao3ACCFmsNzqc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>, linux-iio@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 031/130] iio: proximity: sx9500: fix iio_triggered_buffer_{predisable,postenable} positions
Date:   Tue, 10 Dec 2019 17:01:22 -0500
Message-Id: <20191210220301.13262-31-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210220301.13262-1-sashal@kernel.org>
References: <20191210220301.13262-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

[ Upstream commit 3cfd6464fe23deb45bb688df66184b3f32fefc16 ]

The iio_triggered_buffer_predisable() should be called last, to detach the
poll func after the devices has been suspended.

This change re-organizes things a bit so that the postenable & predisable
are symmetrical. It also converts the preenable() to a postenable().

Not stable material as there is no known problem with the current
code, it's just not consistent with the form we would like all the
IIO drivers to adopt so as to allow subsystem wide changes.

Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/proximity/sx9500.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/proximity/sx9500.c b/drivers/iio/proximity/sx9500.c
index dba796c06ba6c..ac25a0c2e99d7 100644
--- a/drivers/iio/proximity/sx9500.c
+++ b/drivers/iio/proximity/sx9500.c
@@ -683,11 +683,15 @@ static irqreturn_t sx9500_trigger_handler(int irq, void *private)
 	return IRQ_HANDLED;
 }
 
-static int sx9500_buffer_preenable(struct iio_dev *indio_dev)
+static int sx9500_buffer_postenable(struct iio_dev *indio_dev)
 {
 	struct sx9500_data *data = iio_priv(indio_dev);
 	int ret = 0, i;
 
+	ret = iio_triggered_buffer_postenable(indio_dev);
+	if (ret)
+		return ret;
+
 	mutex_lock(&data->mutex);
 
 	for (i = 0; i < SX9500_NUM_CHANNELS; i++)
@@ -704,6 +708,9 @@ static int sx9500_buffer_preenable(struct iio_dev *indio_dev)
 
 	mutex_unlock(&data->mutex);
 
+	if (ret)
+		iio_triggered_buffer_predisable(indio_dev);
+
 	return ret;
 }
 
@@ -712,8 +719,6 @@ static int sx9500_buffer_predisable(struct iio_dev *indio_dev)
 	struct sx9500_data *data = iio_priv(indio_dev);
 	int ret = 0, i;
 
-	iio_triggered_buffer_predisable(indio_dev);
-
 	mutex_lock(&data->mutex);
 
 	for (i = 0; i < SX9500_NUM_CHANNELS; i++)
@@ -730,12 +735,13 @@ static int sx9500_buffer_predisable(struct iio_dev *indio_dev)
 
 	mutex_unlock(&data->mutex);
 
+	iio_triggered_buffer_predisable(indio_dev);
+
 	return ret;
 }
 
 static const struct iio_buffer_setup_ops sx9500_buffer_setup_ops = {
-	.preenable = sx9500_buffer_preenable,
-	.postenable = iio_triggered_buffer_postenable,
+	.postenable = sx9500_buffer_postenable,
 	.predisable = sx9500_buffer_predisable,
 };
 
-- 
2.20.1

