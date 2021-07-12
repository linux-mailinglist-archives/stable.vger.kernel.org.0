Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCBBA3C471C
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbhGLGbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:47908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234710AbhGLG2Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:28:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D366461006;
        Mon, 12 Jul 2021 06:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071074;
        bh=lG0BcVGm0Yni+ENQ3WPe5ApQNVmGtUuSAAZplSQJSck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nn4X97Z2xTaMX19eIgH6DwVUdvwiwHqp60DRMjCkSKvzSBKu/P59S0XQR2snsHfxK
         T46vCt1BzGeLR2UAEKbKFdmGdr/Y+Q5zQ6ZhS6G3fry/gYvM+UIJfJZGcIu3UjkV8b
         InclFZA/YQHun84ngPbpvU0sRrOWcdAftDVis6XY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 264/348] iio:accel:mxc4005: Drop unnecessary explicit casts in regmap_bulk_read calls
Date:   Mon, 12 Jul 2021 08:10:48 +0200
Message-Id: <20210712060738.433300248@linuxfoundation.org>
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

[ Upstream commit b01401a228bc4997b0d4bcb669fced448f7a15ca ]

regmap_bulk_read takes a void * for its val parameter. It certainly
makes no sense to cast to a (u8 *) + no need to explicitly cast
at all when converting another pointer type to void *.

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/mxc4005.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/accel/mxc4005.c b/drivers/iio/accel/mxc4005.c
index 3d5bea651923..9d07642c0de1 100644
--- a/drivers/iio/accel/mxc4005.c
+++ b/drivers/iio/accel/mxc4005.c
@@ -135,7 +135,7 @@ static int mxc4005_read_xyz(struct mxc4005_data *data)
 	int ret;
 
 	ret = regmap_bulk_read(data->regmap, MXC4005_REG_XOUT_UPPER,
-			       (u8 *) data->buffer, sizeof(data->buffer));
+			       data->buffer, sizeof(data->buffer));
 	if (ret < 0) {
 		dev_err(data->dev, "failed to read axes\n");
 		return ret;
@@ -150,7 +150,7 @@ static int mxc4005_read_axis(struct mxc4005_data *data,
 	__be16 reg;
 	int ret;
 
-	ret = regmap_bulk_read(data->regmap, addr, (u8 *) &reg, sizeof(reg));
+	ret = regmap_bulk_read(data->regmap, addr, &reg, sizeof(reg));
 	if (ret < 0) {
 		dev_err(data->dev, "failed to read reg %02x\n", addr);
 		return ret;
-- 
2.30.2



