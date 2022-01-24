Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B69149A335
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386351AbiAXX5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1845985AbiAXXOJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:14:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5778C0A02BD;
        Mon, 24 Jan 2022 13:20:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5538C60C44;
        Mon, 24 Jan 2022 21:20:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2C2C340E4;
        Mon, 24 Jan 2022 21:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059250;
        bh=tGwi8PGuwVZUsl3xSmCHNuQbiPSwT1D+Ohe2sWsCveo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bcST5ddlk6I+q9OyHUlUpSpFuUjGand1Op8QUcsQa0u5uc0xBCeA+oiC6PyZdKkhi
         YUsXbsJ7dkyL3gWUj56fFHzvyf45DWhUNM4YT8Ob7VIm1hZY0D3FAi8/UK0FageYDX
         ywnnfYTq/uzU4X6ALgLuo5/Pwu6t4aI8d8AoJoMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Rix <trix@redhat.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0510/1039] iio: chemical: sunrise_co2: set val parameter only on success
Date:   Mon, 24 Jan 2022 19:38:19 +0100
Message-Id: <20220124184142.432735565@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Rix <trix@redhat.com>

[ Upstream commit 38ac2f038666521f94d4fa37b5a9441cef832ccf ]

Clang static analysis reports this representative warning

sunrise_co2.c:410:9: warning: Assigned value is garbage or undefined
  *val = value;
       ^ ~~~~~

The ealier call to sunrise_read_word can fail without setting
value.  So defer setting val until we know the read was successful.

Fixes: c397894e24f1 ("iio: chemical: Add Senseair Sunrise 006-0-007 driver")
Signed-off-by: Tom Rix <trix@redhat.com>
Link: https://lore.kernel.org/r/20211224150833.3278236-1-trix@redhat.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/chemical/sunrise_co2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/chemical/sunrise_co2.c b/drivers/iio/chemical/sunrise_co2.c
index 233bd0f379c93..8440dc0c77cfe 100644
--- a/drivers/iio/chemical/sunrise_co2.c
+++ b/drivers/iio/chemical/sunrise_co2.c
@@ -407,24 +407,24 @@ static int sunrise_read_raw(struct iio_dev *iio_dev,
 			mutex_lock(&sunrise->lock);
 			ret = sunrise_read_word(sunrise, SUNRISE_CO2_FILTERED_COMP_REG,
 						&value);
-			*val = value;
 			mutex_unlock(&sunrise->lock);
 
 			if (ret)
 				return ret;
 
+			*val = value;
 			return IIO_VAL_INT;
 
 		case IIO_TEMP:
 			mutex_lock(&sunrise->lock);
 			ret = sunrise_read_word(sunrise, SUNRISE_CHIP_TEMPERATURE_REG,
 						&value);
-			*val = value;
 			mutex_unlock(&sunrise->lock);
 
 			if (ret)
 				return ret;
 
+			*val = value;
 			return IIO_VAL_INT;
 
 		default:
-- 
2.34.1



