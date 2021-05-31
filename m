Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8D8395FF7
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbhEaORn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:17:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:43312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233795AbhEaOPk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:15:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D1E561482;
        Mon, 31 May 2021 13:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468581;
        bh=WYKlr1WpWyge+aGeXdCxj0ZJSnge1bGb/5m24pQGkeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IycZef0mqPCKgZGLij7kJlzdYkt1kSExgf2jNXl0PeR6HRC8pm9iLI4liP1ePjRbs
         f8hTqmR4old3cUKu/rquEWm5nNoCGK6lW0bB5w7iqqietknlXaYzV/AjvayNNYn1vp
         P/vFv3C6msYYEgfWz6Rd9/Imm5d06+GFjkzWzjDw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Rui Miguel Silva <rui.silva@linaro.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 044/177] iio: gyro: fxas21002c: balance runtime power in error path
Date:   Mon, 31 May 2021 15:13:21 +0200
Message-Id: <20210531130649.436435309@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rui Miguel Silva <rui.silva@linaro.org>

commit 2a54c8c9ebc2006bf72554afc84ffc67768979a0 upstream.

If we fail to read temperature or axis we need to decrement the
runtime pm reference count to trigger autosuspend.

Add the call to pm_put to do that in case of error.

Fixes: a0701b6263ae ("iio: gyro: add core driver for fxas21002c")
Suggested-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Rui Miguel Silva <rui.silva@linaro.org>
Link: https://lore.kernel.org/linux-iio/CBBZA9T1OY9C.2611WSV49DV2G@arch-thunder/
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/fxas21002c_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/gyro/fxas21002c_core.c
+++ b/drivers/iio/gyro/fxas21002c_core.c
@@ -333,6 +333,7 @@ static int fxas21002c_temp_get(struct fx
 	ret = regmap_field_read(data->regmap_fields[F_TEMP], &temp);
 	if (ret < 0) {
 		dev_err(dev, "failed to read temp: %d\n", ret);
+		fxas21002c_pm_put(data);
 		goto data_unlock;
 	}
 
@@ -366,6 +367,7 @@ static int fxas21002c_axis_get(struct fx
 			       &axis_be, sizeof(axis_be));
 	if (ret < 0) {
 		dev_err(dev, "failed to read axis: %d: %d\n", index, ret);
+		fxas21002c_pm_put(data);
 		goto data_unlock;
 	}
 


