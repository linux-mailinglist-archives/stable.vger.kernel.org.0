Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABD3395B6E
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbhEaNU1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:20:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:55470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232009AbhEaNTb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:19:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB8B76124C;
        Mon, 31 May 2021 13:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467071;
        bh=c7LAnNImmbmD5FoTJxvj7L73x8QcJ/gmdK+hMOJSk30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XgMOmbb6wzCUhUpha7c98b2jZOhoh+h8vFL1tV2EhZcxyhHAWSqpNf6Ue5ay9cAh1
         g0W7hQBf57DmDM1UcMjJJ7pOT4QaBu4l8XVLhK3kb5i8qFZGuaHzsuFDdTff1AofF4
         YKF1VEAU/IxVRZ3cW+SmMexjYhfLpRPoAb3MLWLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stankus <lucas.p.stankus@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Stable@vger.kernel.org
Subject: [PATCH 4.4 12/54] staging: iio: cdc: ad7746: avoid overwrite of num_channels
Date:   Mon, 31 May 2021 15:13:38 +0200
Message-Id: <20210531130635.477567102@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130635.070310929@linuxfoundation.org>
References: <20210531130635.070310929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stankus <lucas.p.stankus@gmail.com>

commit 04f5b9f539ce314f758d919a14dc7a669f3b7838 upstream.

AD7745 devices don't have the CIN2 pins and therefore can't handle related
channels. Forcing the number of AD7746 channels may lead to enabling more
channels than what the hardware actually supports.
Avoid num_channels being overwritten after first assignment.

Signed-off-by: Lucas Stankus <lucas.p.stankus@gmail.com>
Fixes: 83e416f458d53 ("staging: iio: adc: Replace, rewrite ad7745 from scratch.")
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/iio/cdc/ad7746.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/staging/iio/cdc/ad7746.c
+++ b/drivers/staging/iio/cdc/ad7746.c
@@ -714,7 +714,6 @@ static int ad7746_probe(struct i2c_clien
 		indio_dev->num_channels = ARRAY_SIZE(ad7746_channels);
 	else
 		indio_dev->num_channels =  ARRAY_SIZE(ad7746_channels) - 2;
-	indio_dev->num_channels = ARRAY_SIZE(ad7746_channels);
 	indio_dev->modes = INDIO_DIRECT_MODE;
 
 	if (pdata) {


