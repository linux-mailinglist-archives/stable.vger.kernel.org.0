Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC4CA1BCA32
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730726AbgD1Sl3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:41:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:33020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730360AbgD1Sl2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:41:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E77CA2085B;
        Tue, 28 Apr 2020 18:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099288;
        bh=H7suLBITTIhAykDKLx/yQbiP5B4ZnhVwA8JTaHI6O6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RV+eNNQb+XEUzyO82gFWNBlclUE2BCMgodPRmdjsVJtjQc8nKgL6QuqF+QPnfncJz
         gqU1TVnA3PUYbSVfgBt4FS4+aKZN+dix0WDZ/hELPrBBtK47JyYEJ9qoxDGMhSVw55
         CSbPOTHPe0Guc8sM/eso8+D+M4VtkSQKAeFkPLVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lary Gibaud <yarl-baudig@mailoo.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 088/168] iio: st_sensors: rely on odr mask to know if odr can be set
Date:   Tue, 28 Apr 2020 20:24:22 +0200
Message-Id: <20200428182243.459800577@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lary Gibaud <yarl-baudig@mailoo.org>

commit e450e07c14abae563ad13b064cbce9fdccc6bc8d upstream.

Indeed, relying on addr being not 0 cannot work because some device have
their register to set odr at address 0. As a matter of fact, if the odr
can be set, then there is a mask.

Sensors with ODR register at address 0 are: lsm303dlh, lsm303dlhc, lsm303dlm

Fixes: 7d245172675a ("iio: common: st_sensors: check odr address value in st_sensors_set_odr()")
Signed-off-by: Lary Gibaud <yarl-baudig@mailoo.org>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/common/st_sensors/st_sensors_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/common/st_sensors/st_sensors_core.c
+++ b/drivers/iio/common/st_sensors/st_sensors_core.c
@@ -80,7 +80,7 @@ int st_sensors_set_odr(struct iio_dev *i
 	struct st_sensor_odr_avl odr_out = {0, 0};
 	struct st_sensor_data *sdata = iio_priv(indio_dev);
 
-	if (!sdata->sensor_settings->odr.addr)
+	if (!sdata->sensor_settings->odr.mask)
 		return 0;
 
 	err = st_sensors_match_odr(sdata->sensor_settings, odr, &odr_out);


