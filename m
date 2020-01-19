Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E94B141EDF
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 16:32:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgASPc5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 10:32:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:54858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726860AbgASPc5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 19 Jan 2020 10:32:57 -0500
Received: from localhost (96-81-74-198-static.hfc.comcastbusiness.net [96.81.74.198])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2905A20678;
        Sun, 19 Jan 2020 15:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579447977;
        bh=lfxyY4jN1mq2ZGJGcLxM6Nn8lcL0+tBX8VNDc6iPrPU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TcNm19+0sU2/3VADQjhjrMc1WvBjz7/lFcR4bhslrwTpNuUksuatumUgONBWj6Apv
         nUCN0jREFiHogmiaLGrCgocnWoV3SGxFb/7n5/EI+d14BSzsmN45xJ+0CB8wpY9i61
         1+tGEWE7V+NCyuSH6Bh8URzfICAglTIPkhIBsgpE=
Date:   Sun, 19 Jan 2020 10:32:53 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     stephan@gerhold.net, Jonathan.Cameron@huawei.com,
        lorenzo@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: imu: st_lsm6dsx: Fix selection of
 ST_LSM6DS3_ID" failed to apply to 4.19-stable tree
Message-ID: <20200119153253.GP1706@sasha-vm>
References: <1579440810243255@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1579440810243255@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 19, 2020 at 02:33:30PM +0100, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.19-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.
>
>thanks,
>
>greg k-h
>
>------------------ original commit in Linus's tree ------------------
>
>From fb4fbc8904e786537e29329d791147389e1465a2 Mon Sep 17 00:00:00 2001
>From: Stephan Gerhold <stephan@gerhold.net>
>Date: Mon, 16 Dec 2019 13:41:20 +0100
>Subject: [PATCH] iio: imu: st_lsm6dsx: Fix selection of ST_LSM6DS3_ID
>
>At the moment, attempting to probe a device with ST_LSM6DS3_ID
>(e.g. using the st,lsm6ds3 compatible) fails with:
>
>    st_lsm6dsx_i2c 1-006b: unsupported whoami [69]
>
>... even though 0x69 is the whoami listed for ST_LSM6DS3_ID.
>
>This happens because st_lsm6dsx_check_whoami() also attempts
>to match unspecified (zero-initialized) entries in the "id" array.
>ST_LSM6DS3_ID = 0 will therefore match any entry in
>st_lsm6dsx_sensor_settings (here: the first), because none of them
>actually have all 12 entries listed in the "id" array.
>
>Avoid this by additionally checking if "name" is set,
>which is only set for valid entries in the "id" array.
>
>Note: Although the problem was introduced earlier it did not surface until
>commit 52f4b1f19679 ("iio: imu: st_lsm6dsx: add support for accel/gyro unit of lsm9ds1")
>because ST_LSM6DS3_ID was the first entry in st_lsm6dsx_sensor_settings.
>
>Fixes: d068e4a0f921 ("iio: imu: st_lsm6dsx: add support to multiple devices with the same settings")
>Cc: <stable@vger.kernel.org> # 5.4
>Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
>Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
>Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
>Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I don't think that this is needed on anything older than 5.4 because
they don't have 801a6e0af0c6 ("iio: imu: st_lsm6dsx: add support to
LSM6DSO"), the fixes tag might be misleading here a bit.

-- 
Thanks,
Sasha
