Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 629B7561C56
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 16:00:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235517AbiF3N7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236593AbiF3N7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:59:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9E95C9DC;
        Thu, 30 Jun 2022 06:52:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C17DCB82AF0;
        Thu, 30 Jun 2022 13:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18B49C34115;
        Thu, 30 Jun 2022 13:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656597094;
        bh=9pFnt4Tljffl4natwPHL1q2QboxEpLx0K3ObN0lkqLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lQhcLbdN3KM33Gij4sNWE+v4p/pVImZSOfVVlFF8rp15ZRoT+I19qtfXEuxAoQF8t
         zoZ1Dy53oqgVGjr7/RAo0H1/CYZ7Mnj7RohuLInER2kEhi91BuWdra/H5R49LgJFAX
         rOrkDsx/01a9XqrIgZFgF9qCA6y1BGF1KQRp383U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haibo Chen <haibo.chen@nxp.com>,
        Hans de Goede <hdegoede@redhat.com>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 26/49] iio: accel: mma8452: ignore the return value of reset operation
Date:   Thu, 30 Jun 2022 15:46:39 +0200
Message-Id: <20220630133234.668762216@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220630133233.910803744@linuxfoundation.org>
References: <20220630133233.910803744@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haibo Chen <haibo.chen@nxp.com>

commit bf745142cc0a3e1723f9207fb0c073c88464b7b4 upstream.

On fxls8471, after set the reset bit, the device will reset immediately,
will not give ACK. So ignore the return value of this reset operation,
let the following code logic to check whether the reset operation works.

Signed-off-by: Haibo Chen <haibo.chen@nxp.com>
Fixes: ecabae713196 ("iio: mma8452: Initialise before activating")
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/1655292718-14287-1-git-send-email-haibo.chen@nxp.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/mma8452.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/iio/accel/mma8452.c
+++ b/drivers/iio/accel/mma8452.c
@@ -1486,10 +1486,14 @@ static int mma8452_reset(struct i2c_clie
 	int i;
 	int ret;
 
-	ret = i2c_smbus_write_byte_data(client,	MMA8452_CTRL_REG2,
+	/*
+	 * Find on fxls8471, after config reset bit, it reset immediately,
+	 * and will not give ACK, so here do not check the return value.
+	 * The following code will read the reset register, and check whether
+	 * this reset works.
+	 */
+	i2c_smbus_write_byte_data(client, MMA8452_CTRL_REG2,
 					MMA8452_CTRL_REG2_RST);
-	if (ret < 0)
-		return ret;
 
 	for (i = 0; i < 10; i++) {
 		usleep_range(100, 200);


