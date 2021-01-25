Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F631302AC3
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:53:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbhAYSwA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:52:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:37086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726627AbhAYSvx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F189F22460;
        Mon, 25 Jan 2021 18:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600690;
        bh=vcxkj0PzaeTz6F09LNjmOg17GVBW/qzMLpzOrDd3OO4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TC9l3tiwOCj7LfnzF4JqyZxUSDgynNpm4SzMMVJlcv1jnZ5qCOa0XYGc7c7oaSmfI
         JgmKYPr950EVnVfITOlaKohqPjegzLYJnerOv4EVcIczeRXVNIK68Oxck9ef11ENjg
         bY/nbxVvh3Th7AdyRWCh7fiBCVf7bMstVC9lU/bI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Slaveyko Slaveykov <sis@melexis.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Crt Mori <cmo@melexis.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 113/199] drivers: iio: temperature: Add delay after the addressed reset command in mlx90632.c
Date:   Mon, 25 Jan 2021 19:38:55 +0100
Message-Id: <20210125183221.014055630@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Slaveyko Slaveykov <sis@melexis.com>

commit cf5b1385d748b2f91b0c05bb301fcaf9bdbad385 upstream.

After an I2C reset command, the mlx90632 needs some time before
responding to other I2C commands. Without that delay, there is a chance
that the I2C command(s) after the reset will not be accepted.

Signed-off-by: Slaveyko Slaveykov <sis@melexis.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Crt Mori <cmo@melexis.com>
Fixes: e02472f74a81 ("iio:temperature:mlx90632: Adding extended calibration option")
Link: https://lore.kernel.org/r/20201216115720.12404-2-sis@melexis.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/temperature/mlx90632.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/iio/temperature/mlx90632.c
+++ b/drivers/iio/temperature/mlx90632.c
@@ -248,6 +248,12 @@ static int mlx90632_set_meas_type(struct
 	if (ret < 0)
 		return ret;
 
+	/*
+	 * Give the mlx90632 some time to reset properly before sending a new I2C command
+	 * if this is not done, the following I2C command(s) will not be accepted.
+	 */
+	usleep_range(150, 200);
+
 	ret = regmap_write_bits(regmap, MLX90632_REG_CONTROL,
 				 (MLX90632_CFG_MTYP_MASK | MLX90632_CFG_PWR_MASK),
 				 (MLX90632_MTYP_STATUS(type) | MLX90632_PWR_STATUS_HALT));


