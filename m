Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC9D6141FB3
	for <lists+stable@lfdr.de>; Sun, 19 Jan 2020 20:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgASTKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jan 2020 14:10:41 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:25030 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbgASTKl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jan 2020 14:10:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1579461039;
        s=strato-dkim-0002; d=gerhold.net;
        h=In-Reply-To:References:Message-ID:Subject:Cc:To:From:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=zC31qw2QI8KGaxuMW1UZ0kzxGWEghz7fWmo04voBrAY=;
        b=XXgvDO9ZrUb+OHDje/vaIaTjrkS39ynxQV6qK28C/AQzjurGBIUAriWLM/9h/WjCDQ
        kcijm6DPvPljpKHugiEDr/5wdnsblu+/VnrRD5rD0FZ2OYtlm5GIwQNyrr0BZCEVg5iJ
        lBcZ+yWcRnzC3ffuJBqn846pUXfDbru/MVzOkZcLzWEGjBPSIL9FAfyabAPeeWKFgOj8
        8xjJ0rwxddwmKZ542MD4KFiayulg/rApmUMObjMS/emtkHhED+lstqC6NwhV5YIMFCCW
        KFDllKsjGsQeBoDBsvC0oCOXF1v4ywGTib669FhN+8tzSzdx6yBJniMnvk9Lw7ZCGszo
        NDbA==
X-RZG-AUTH: ":P3gBZUipdd93FF5ZZvYFPugejmSTVR2nRPhVOQ/OcYgojyw4j34+u266EZF6ORJAS+MuXEVD"
X-RZG-CLASS-ID: mo00
Received: from gerhold.net
        by smtp.strato.de (RZmta 46.1.4 AUTH)
        with ESMTPSA id h048a6w0JJAbw2y
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 19 Jan 2020 20:10:37 +0100 (CET)
Date:   Sun, 19 Jan 2020 20:10:32 +0100
From:   Stephan Gerhold <stephan@gerhold.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, Jonathan.Cameron@huawei.com,
        lorenzo@kernel.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] iio: imu: st_lsm6dsx: Fix selection of
 ST_LSM6DS3_ID" failed to apply to 4.19-stable tree
Message-ID: <20200119191032.GA170231@gerhold.net>
References: <1579440810243255@kroah.com>
 <20200119153253.GP1706@sasha-vm>
 <20200119161533.GA143951@gerhold.net>
 <20200119185530.GX1706@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200119185530.GX1706@sasha-vm>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 19, 2020 at 01:55:30PM -0500, Sasha Levin wrote:
> On Sun, Jan 19, 2020 at 05:15:33PM +0100, Stephan Gerhold wrote:
> > On Sun, Jan 19, 2020 at 10:32:53AM -0500, Sasha Levin wrote:
> > > On Sun, Jan 19, 2020 at 02:33:30PM +0100, gregkh@linuxfoundation.org wrote:
> > > >
> > > > The patch below does not apply to the 4.19-stable tree.
> > > > If someone wants it applied there, or to any other stable or longterm
> > > > tree, then please email the backport, including the original git commit
> > > > id to <stable@vger.kernel.org>.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > > >
> > > > ------------------ original commit in Linus's tree ------------------
> > > >
> > > > From fb4fbc8904e786537e29329d791147389e1465a2 Mon Sep 17 00:00:00 2001
> > > > From: Stephan Gerhold <stephan@gerhold.net>
> > > > Date: Mon, 16 Dec 2019 13:41:20 +0100
> > > > Subject: [PATCH] iio: imu: st_lsm6dsx: Fix selection of ST_LSM6DS3_ID
> > > >
> > > > At the moment, attempting to probe a device with ST_LSM6DS3_ID
> > > > (e.g. using the st,lsm6ds3 compatible) fails with:
> > > >
> > > >    st_lsm6dsx_i2c 1-006b: unsupported whoami [69]
> > > >
> > > > ... even though 0x69 is the whoami listed for ST_LSM6DS3_ID.
> > > >
> > > > This happens because st_lsm6dsx_check_whoami() also attempts
> > > > to match unspecified (zero-initialized) entries in the "id" array.
> > > > ST_LSM6DS3_ID = 0 will therefore match any entry in
> > > > st_lsm6dsx_sensor_settings (here: the first), because none of them
> > > > actually have all 12 entries listed in the "id" array.
> > > >
> > > > Avoid this by additionally checking if "name" is set,
> > > > which is only set for valid entries in the "id" array.
> > > >
> > > > Note: Although the problem was introduced earlier it did not surface until
> > > > commit 52f4b1f19679 ("iio: imu: st_lsm6dsx: add support for accel/gyro unit of lsm9ds1")
> > > > because ST_LSM6DS3_ID was the first entry in st_lsm6dsx_sensor_settings.
> > > >
> > > > Fixes: d068e4a0f921 ("iio: imu: st_lsm6dsx: add support to multiple devices with the same settings")
> > > > Cc: <stable@vger.kernel.org> # 5.4
> > > > Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > Signed-off-by: Stephan Gerhold <stephan@gerhold.net>
> > > > Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> > > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > 
> > > I don't think that this is needed on anything older than 5.4 because
> > > they don't have 801a6e0af0c6 ("iio: imu: st_lsm6dsx: add support to
> > > LSM6DSO"), the fixes tag might be misleading here a bit.
> > 
> > Correct. I didn't want to use 801a6e0af0c6 ("iio: imu: st_lsm6dsx: add
> > support to LSM6DSO") as Fixes tag because that commit did not do
> > anything wrong - the problem was introduced earlier, but there is no way
> > to trigger it on older kernels.
> > 
> > This is why I added # 5.5 to the Cc: stable tag.
> > Are these comments still used in any way?
> > Or is there a better way to encode this into the commit message?
> 
> Usually if there's a fixes: tag we'll look at that rather than the
> version appended to the stable tag.
> 
> Consider maybe using two "Fixes:" tags to point at the commits that were
> involved.

So basically this

Fixes: d068e4a0f921 ("iio: imu: st_lsm6dsx: add support to multiple devices with the same settings")
Fixes: 52f4b1f19679 ("iio: imu: st_lsm6dsx: add support for accel/gyro unit of lsm9ds1")

would mean "fixes the combination of these two commits"?
