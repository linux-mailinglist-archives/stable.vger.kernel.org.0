Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E20431CDC
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233665AbhJRNpo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234037AbhJRNnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:43:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C372961527;
        Mon, 18 Oct 2021 13:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564085;
        bh=EUB55AvFWO8DodrRnQswPvZgR9JY2IDW6eTIF3qt21g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kuYDe/ysxhdjRg5zKrScsxsRkiXpS8iMNpqIj3SvKUHXj0MD2zw0UiYsLFpxvhsAG
         kzY8jzoiyD3rISoj7wMy6i8VoFUKFJ/4V/qB5/o8450UhBd1ZUpcjExwbtP4pLn/ME
         OdVpxhJv96UB89RfPr4KhtV3FBMqICXQEnoeZlC8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 060/103] iio: ssp_sensors: fix error code in ssp_print_mcu_debug()
Date:   Mon, 18 Oct 2021 15:24:36 +0200
Message-Id: <20211018132336.778101599@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 4170d3dd1467e9d78cb9af374b19357dc324b328 upstream.

The ssp_print_mcu_debug() function should return negative error codes on
error.  Returning "length" is meaningless.  This change does not affect
runtime because the callers only care about zero/non-zero.

Reported-by: Jonathan Cameron <jic23@kernel.org>
Fixes: 50dd64d57eee ("iio: common: ssp_sensors: Add sensorhub driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20210914105333.GA11657@kili
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/ssp_sensors/ssp_spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/common/ssp_sensors/ssp_spi.c
+++ b/drivers/iio/common/ssp_sensors/ssp_spi.c
@@ -137,7 +137,7 @@ static int ssp_print_mcu_debug(char *dat
 	if (length > received_len - *data_index || length <= 0) {
 		ssp_dbg("[SSP]: MSG From MCU-invalid debug length(%d/%d)\n",
 			length, received_len);
-		return length ? length : -EPROTO;
+		return -EPROTO;
 	}
 
 	ssp_dbg("[SSP]: MSG From MCU - %s\n", &data_frame[*data_index]);


