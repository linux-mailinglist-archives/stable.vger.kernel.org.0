Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B652A584B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730924AbgKCUtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:49:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:39196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731479AbgKCUsF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:48:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C38822404;
        Tue,  3 Nov 2020 20:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436484;
        bh=Rl7KlvGNjgpipQ9OxJ/zByIUtYu+3qLpWUB+MrcImnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5Pm4/wdA7YAyy29NdKAEfXJgtwIYp0UHqbH/oHSGGCnWQbaqV1feXnIVzfjisCXh
         NbSuQpN8w2dnQeOqj7rd7rhVEotKFSnQYQQpsGQ+d+AzjnXJlPtA+A4VMzGQ7qXFFB
         ndhi/vPcqvIlNt+1S3+B4WjanjHeGTuLq+UrsRd4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.9 271/391] iio:imu:st_lsm6dsx: check st_lsm6dsx_shub_read_output return
Date:   Tue,  3 Nov 2020 21:35:22 +0100
Message-Id: <20201103203405.316967620@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

commit f71e41e23e129640f620b65fc362a6da02580310 upstream.

Potential error return is not checked.  This can lead to use
of undefined data.

Detected by clang static analysis.

st_lsm6dsx_shub.c:540:8: warning: Assigned value is garbage or undefined
        *val = (s16)le16_to_cpu(*((__le16 *)data));
             ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Fixes: c91c1c844ebd ("iio: imu: st_lsm6dsx: add i2c embedded controller support")
Signed-off-by: Tom Rix <trix@redhat.com
Cc: <Stable@vger.kernel.org>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Link: https://lore.kernel.org/r/20200809175551.6794-1-trix@redhat.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
@@ -313,6 +313,8 @@ st_lsm6dsx_shub_read(struct st_lsm6dsx_s
 
 	err = st_lsm6dsx_shub_read_output(hw, data,
 					  len & ST_LS6DSX_READ_OP_MASK);
+	if (err < 0)
+		return err;
 
 	st_lsm6dsx_shub_master_enable(sensor, false);
 


