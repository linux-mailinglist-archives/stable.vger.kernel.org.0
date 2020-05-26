Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0131E2C91
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404617AbgEZTQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:16:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404614AbgEZTQC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:16:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4D3B20776;
        Tue, 26 May 2020 19:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520561;
        bh=ImbgU2xokOmZs1bDtUO42FVkv3QOPGizr5NgN42j6zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eghelXPdQxExKXVzFiRnZbaC9dAjGbqJv80R2untXXi9sEB59J88Tujh0p95e2Pee
         H+3Q1vCaqWlNAMD5gfoZ3qd4wsuUUonnI784vX3smpA+3A0VUJVVcXcB6jyYBkxBDy
         ocO1jFBgaA5F0JDzK9arjnCLnlmwWebY/GVeiVfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.6 114/126] iio: imu: st_lsm6dsx: unlock on error in st_lsm6dsx_shub_write_raw()
Date:   Tue, 26 May 2020 20:54:11 +0200
Message-Id: <20200526183947.078654309@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 115c215a7e5753ddf982c8760ce7904dd3fbb8ae upstream.

We need to release a lock if st_lsm6dsx_check_odr() fails, we can't
return directly.

Fixes: 76551a3c3df1 ("iio: imu: st_lsm6dsx: specify slave odr in slv_odr")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_shub.c
@@ -544,8 +544,10 @@ st_lsm6dsx_shub_write_raw(struct iio_dev
 
 			ref_sensor = iio_priv(hw->iio_devs[ST_LSM6DSX_ID_ACC]);
 			odr = st_lsm6dsx_check_odr(ref_sensor, val, &odr_val);
-			if (odr < 0)
-				return odr;
+			if (odr < 0) {
+				err = odr;
+				goto release;
+			}
 
 			sensor->ext_info.slv_odr = val;
 			sensor->odr = odr;
@@ -557,6 +559,7 @@ st_lsm6dsx_shub_write_raw(struct iio_dev
 		break;
 	}
 
+release:
 	iio_device_release_direct_mode(iio_dev);
 
 	return err;


