Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5256C4C76CC
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239692AbiB1SHO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:07:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239702AbiB1SFc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:05:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE9E5418A;
        Mon, 28 Feb 2022 09:48:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 636BAB81187;
        Mon, 28 Feb 2022 17:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3577C340E7;
        Mon, 28 Feb 2022 17:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070467;
        bh=HtR2CxzOO8ZDLXGj1j6x+l8s1x2I1wdNHqufAAZ25hU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=08p+Cdcp+OWd1eI5caZe/6Oh8b2mR10xv9BZgc6dc8jGWUC7CIGbcDVivar5oKa4Z
         VRG0gFdRNKBDpxVGqCnRKumA24xbhTolhwl3og+QwMF0mOxGwg8e09A+T5FixIQJ51
         d1EYF16CEhtL5KzAU7S61Qa9NczWwH6bvaOI45Qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mario Tesi <mario.tesi@st.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.16 119/164] iio: imu: st_lsm6dsx: wait for settling time in st_lsm6dsx_read_oneshot
Date:   Mon, 28 Feb 2022 18:24:41 +0100
Message-Id: <20220228172411.078345606@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

commit ea85bf906466191b58532bb19f4fbb4591f0a77e upstream.

We need to wait for sensor settling time (~ 3/ODR) before reading data
in st_lsm6dsx_read_oneshot routine in order to avoid corrupted samples.

Fixes: 290a6ce11d93 ("iio: imu: add support to lsm6dsx driver")
Reported-by: Mario Tesi <mario.tesi@st.com>
Tested-by: Mario Tesi <mario.tesi@st.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://lore.kernel.org/r/b41ebda5535895298716c76d939f9f165fcd2d13.1644098120.git.lorenzo@kernel.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx_core.c
@@ -1374,8 +1374,12 @@ static int st_lsm6dsx_read_oneshot(struc
 	if (err < 0)
 		return err;
 
+	/*
+	 * we need to wait for sensor settling time before
+	 * reading data in order to avoid corrupted samples
+	 */
 	delay = 1000000000 / sensor->odr;
-	usleep_range(delay, 2 * delay);
+	usleep_range(3 * delay, 4 * delay);
 
 	err = st_lsm6dsx_read_locked(hw, addr, &data, sizeof(data));
 	if (err < 0)


