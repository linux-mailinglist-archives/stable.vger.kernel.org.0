Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3060A682997
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 10:53:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjAaJxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 04:53:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjAaJxd (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 31 Jan 2023 04:53:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EA3B5B9D
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 01:53:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 393CC6148B
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 09:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303BCC433EF;
        Tue, 31 Jan 2023 09:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675158796;
        bh=LQwRlfXaEBaO/eAhgJH+040Ay8RF1G+P/ZswmMJ5mpk=;
        h=Subject:To:From:Date:From;
        b=MEK6FkK+lPxti2kGOD7gf25ggyu1uwG07ovpHVohiSULKPLlNHIYkExkWG/l+Dny6
         PsvXUpkbSNRWE45iDanMEiqgX6Yk9lxvI9iAM86jcM0bTMvENZlkuK20NVg8kN88CD
         +rPUbsOLr23vjYyVehktWLVf5hyhMmK2jlmOpsU8=
Subject: patch "iio: hid: fix the retval in gyro_3d_capture_sample" added to char-misc-linus
To:     dmitry.perchanov@intel.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 31 Jan 2023 10:52:43 +0100
Message-ID: <167515876365151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: hid: fix the retval in gyro_3d_capture_sample

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From eb50cd5bfdac61627a5026566cf3b90ced7b141c Mon Sep 17 00:00:00 2001
From: Dmitry Perchanov <dmitry.perchanov@intel.com>
Date: Wed, 11 Jan 2023 14:24:25 +0200
Subject: iio: hid: fix the retval in gyro_3d_capture_sample

Return value should be zero for success. This was forgotten for timestamp
feature. Verified on RealSense cameras.

Fixes: 4648cbd8fb92 ("iio: hid-sensor-gyro-3d: Add timestamp channel")
Signed-off-by: Dmitry Perchanov <dmitry.perchanov@intel.com>
Link: https://lore.kernel.org/r/7c1809dc74eb2f58a20595f4d02e76934f8e9219.camel@intel.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/gyro/hid-sensor-gyro-3d.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/gyro/hid-sensor-gyro-3d.c b/drivers/iio/gyro/hid-sensor-gyro-3d.c
index 8f0ad022c7f1..698c50da1f10 100644
--- a/drivers/iio/gyro/hid-sensor-gyro-3d.c
+++ b/drivers/iio/gyro/hid-sensor-gyro-3d.c
@@ -231,6 +231,7 @@ static int gyro_3d_capture_sample(struct hid_sensor_hub_device *hsdev,
 		gyro_state->timestamp =
 			hid_sensor_convert_timestamp(&gyro_state->common_attributes,
 						     *(s64 *)raw_data);
+		ret = 0;
 	break;
 	default:
 		break;
-- 
2.39.1


