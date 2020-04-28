Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189FD1BC827
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbgD1SaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:30:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:44332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729438AbgD1SaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:30:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DB9F20730;
        Tue, 28 Apr 2020 18:30:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098602;
        bh=1Fj3PTj5oghOrjkoXDbSvlZzFgLk4RdKysNplhgIQxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TB7Vm05XfXkcEdHw2DUbD9b0WHeohrlJTfbmOPNHYYGqOB8A7eDdhf3b+Buv3MxPl
         6Yk2q4Hl7aW9LLdUw5XNkw9LnlUZd0oHfaYruVGpVB9JXtdZE5eQ3O+PU4rHr1b1Uw
         6WX984KzDKc6hlKCJ7x8rndtTV109CGpUe4egtpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lary Gibaud <yarl-baudig@mailoo.org>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.6 083/167] iio: st_sensors: rely on odr mask to know if odr can be set
Date:   Tue, 28 Apr 2020 20:24:19 +0200
Message-Id: <20200428182235.492788197@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
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
@@ -79,7 +79,7 @@ int st_sensors_set_odr(struct iio_dev *i
 	struct st_sensor_odr_avl odr_out = {0, 0};
 	struct st_sensor_data *sdata = iio_priv(indio_dev);
 
-	if (!sdata->sensor_settings->odr.addr)
+	if (!sdata->sensor_settings->odr.mask)
 		return 0;
 
 	err = st_sensors_match_odr(sdata->sensor_settings, odr, &odr_out);


