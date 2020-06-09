Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FA51F4364
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732973AbgFIRxC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:53:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732970AbgFIRxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:53:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93B8B20801;
        Tue,  9 Jun 2020 17:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725181;
        bh=ZMv3ezj23sl3iB5uhJe069xw5SiAAJNn15tfc3mWTyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X8fMTX9iOGLr3N/lSqQjwySemfLTGXGV89CO2h7gtwNeevFDakUqWmHBhP6RorDOV
         p5CMUNBZGJPvOMXUJAog8B5RKzDecnq4aF13Jgmr4s8WRrzfVwbaHxX6efzjgpqgR1
         94FHBiW8MtL9eklzWugcgB6Un2H+cTe1z6VSat3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mathieu Othacehe <m.othacehe@gmail.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 17/34] iio: vcnl4000: Fix i2c swapped word reading.
Date:   Tue,  9 Jun 2020 19:45:13 +0200
Message-Id: <20200609174054.797121315@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174052.628006868@linuxfoundation.org>
References: <20200609174052.628006868@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mathieu Othacehe <m.othacehe@gmail.com>

commit 18dfb5326370991c81a6d1ed6d1aeee055cb8c05 upstream.

The bytes returned by the i2c reading need to be swapped
unconditionally. Otherwise, on be16 platforms, an incorrect value will be
returned.

Taking the slow path via next merge window as its been around a while
and we have a patch set dependent on this which would be held up.

Fixes: 62a1efb9f868 ("iio: add vcnl4000 combined ALS and proximity sensor")
Signed-off-by: Mathieu Othacehe <m.othacehe@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/light/vcnl4000.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/iio/light/vcnl4000.c
+++ b/drivers/iio/light/vcnl4000.c
@@ -193,7 +193,6 @@ static int vcnl4000_measure(struct vcnl4
 				u8 rdy_mask, u8 data_reg, int *val)
 {
 	int tries = 20;
-	__be16 buf;
 	int ret;
 
 	mutex_lock(&data->vcnl4000_lock);
@@ -220,13 +219,12 @@ static int vcnl4000_measure(struct vcnl4
 		goto fail;
 	}
 
-	ret = i2c_smbus_read_i2c_block_data(data->client,
-		data_reg, sizeof(buf), (u8 *) &buf);
+	ret = i2c_smbus_read_word_swapped(data->client, data_reg);
 	if (ret < 0)
 		goto fail;
 
 	mutex_unlock(&data->vcnl4000_lock);
-	*val = be16_to_cpu(buf);
+	*val = ret;
 
 	return 0;
 


