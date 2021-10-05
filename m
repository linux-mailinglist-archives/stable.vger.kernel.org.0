Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC43E422229
	for <lists+stable@lfdr.de>; Tue,  5 Oct 2021 11:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhJEJXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Oct 2021 05:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:38114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233365AbhJEJXl (ORCPT <rfc822;Stable@vger.kernel.org>);
        Tue, 5 Oct 2021 05:23:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76D4F610C9;
        Tue,  5 Oct 2021 09:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633425710;
        bh=iWM19I5yVtMijPUmujoTKAyuVb78otWFmK1GIOrjGvc=;
        h=Subject:To:From:Date:From;
        b=gcc2ZIsE50c2qLH7fgog+tAbo0KswT3KEyRxH1IKk7gS/AsNDy4Fj+SIeJ4WuhjyG
         NqtJPb9zhAU9YLBaGrqznK7OXCMo9exFnujeS3WJ+sbbQnPcrYXrnzSf7EEfYpSIUX
         9K1p8m59EdDORCxY8w8PWFfnLTRvdwCac5zaB49M=
Subject: patch "iio: ssp_sensors: add more range checking in ssp_parse_dataframe()" added to staging-linus
To:     dan.carpenter@oracle.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 05 Oct 2021 11:21:25 +0200
Message-ID: <1633425685183210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: ssp_sensors: add more range checking in ssp_parse_dataframe()

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 8167c9a375ccceed19048ad9d68cb2d02ed276e0 Mon Sep 17 00:00:00 2001
From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Thu, 9 Sep 2021 12:13:36 +0300
Subject: iio: ssp_sensors: add more range checking in ssp_parse_dataframe()

The "idx" is validated at the start of the loop but it gets incremented
during the iteration so it needs to be checked again.

Fixes: 50dd64d57eee ("iio: common: ssp_sensors: Add sensorhub driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20210909091336.GA26312@kili
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/common/ssp_sensors/ssp_spi.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/common/ssp_sensors/ssp_spi.c b/drivers/iio/common/ssp_sensors/ssp_spi.c
index 77449b4f3df5..769bd9280524 100644
--- a/drivers/iio/common/ssp_sensors/ssp_spi.c
+++ b/drivers/iio/common/ssp_sensors/ssp_spi.c
@@ -273,6 +273,8 @@ static int ssp_parse_dataframe(struct ssp_data *data, char *dataframe, int len)
 	for (idx = 0; idx < len;) {
 		switch (dataframe[idx++]) {
 		case SSP_MSG2AP_INST_BYPASS_DATA:
+			if (idx >= len)
+				return -EPROTO;
 			sd = dataframe[idx++];
 			if (sd < 0 || sd >= SSP_SENSOR_MAX) {
 				dev_err(SSP_DEV,
@@ -282,10 +284,13 @@ static int ssp_parse_dataframe(struct ssp_data *data, char *dataframe, int len)
 
 			if (indio_devs[sd]) {
 				spd = iio_priv(indio_devs[sd]);
-				if (spd->process_data)
+				if (spd->process_data) {
+					if (idx >= len)
+						return -EPROTO;
 					spd->process_data(indio_devs[sd],
 							  &dataframe[idx],
 							  data->timestamp);
+				}
 			} else {
 				dev_err(SSP_DEV, "no client for frame\n");
 			}
@@ -293,6 +298,8 @@ static int ssp_parse_dataframe(struct ssp_data *data, char *dataframe, int len)
 			idx += ssp_offset_map[sd];
 			break;
 		case SSP_MSG2AP_INST_DEBUG_DATA:
+			if (idx >= len)
+				return -EPROTO;
 			sd = ssp_print_mcu_debug(dataframe, &idx, len);
 			if (sd) {
 				dev_err(SSP_DEV,
-- 
2.33.0


