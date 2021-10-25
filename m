Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10026439F32
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234310AbhJYTSO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:18:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234123AbhJYTSE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:18:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D9FD60FE8;
        Mon, 25 Oct 2021 19:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635189342;
        bh=gNRHkcxNAhkS63JpCBusgv0NtAF1h969xehizz1tV6U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QuSsKuEUBVqv+7v72/CaRxcDMPlceRUnPwT5zneRidGy0HJs3xwItHuTcg2YUVc8/
         2ysIt8oJY37XQr5FaoQIoi+N3B419Wu4UEdnOQhnFCenobriwlU61pfuw1bOAhpY3S
         zCzX0o9oWK4yuca6caBqKIZCVv+OsSk16hdQfbZo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.4 11/44] iio: ssp_sensors: add more range checking in ssp_parse_dataframe()
Date:   Mon, 25 Oct 2021 21:13:52 +0200
Message-Id: <20211025190930.935892826@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190928.054676643@linuxfoundation.org>
References: <20211025190928.054676643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 8167c9a375ccceed19048ad9d68cb2d02ed276e0 upstream.

The "idx" is validated at the start of the loop but it gets incremented
during the iteration so it needs to be checked again.

Fixes: 50dd64d57eee ("iio: common: ssp_sensors: Add sensorhub driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20210909091336.GA26312@kili
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/ssp_sensors/ssp_spi.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/iio/common/ssp_sensors/ssp_spi.c
+++ b/drivers/iio/common/ssp_sensors/ssp_spi.c
@@ -286,6 +286,8 @@ static int ssp_parse_dataframe(struct ss
 	for (idx = 0; idx < len;) {
 		switch (dataframe[idx++]) {
 		case SSP_MSG2AP_INST_BYPASS_DATA:
+			if (idx >= len)
+				return -EPROTO;
 			sd = dataframe[idx++];
 			if (sd < 0 || sd >= SSP_SENSOR_MAX) {
 				dev_err(SSP_DEV,
@@ -295,10 +297,13 @@ static int ssp_parse_dataframe(struct ss
 
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
@@ -306,6 +311,8 @@ static int ssp_parse_dataframe(struct ss
 			idx += ssp_offset_map[sd];
 			break;
 		case SSP_MSG2AP_INST_DEBUG_DATA:
+			if (idx >= len)
+				return -EPROTO;
 			sd = ssp_print_mcu_debug(dataframe, &idx, len);
 			if (sd) {
 				dev_err(SSP_DEV,


