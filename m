Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 121D6682998
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 10:53:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjAaJxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 04:53:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjAaJxg (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 31 Jan 2023 04:53:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F020FF779
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 01:53:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 83D3DCE1CD1
        for <Stable@vger.kernel.org>; Tue, 31 Jan 2023 09:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F555C433A8;
        Tue, 31 Jan 2023 09:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675158799;
        bh=xjdTU0Qi4nbjXpTVG5cX9jBowMfHcg5wy7B28Nz4e2g=;
        h=Subject:To:From:Date:From;
        b=o1vByTIlRmFM/iqee8AQHchfdm66DwF/Hr9fOg4VGb+sz9Tf7dOI/4L6HkXF1wWRC
         eTbmslN9H6ngnOUUE9XlAkPjTXJyJvlFCvVX/AMn30VY+iJook0466MDmQQiCJ/Yt7
         Eo5ulMc+bmQtc62e0bm9Di7Fe36Dl+TKVM65aAbs=
Subject: patch "iio: hid: fix the retval in accel_3d_capture_sample" added to char-misc-linus
To:     dmitry.perchanov@intel.com, Jonathan.Cameron@huawei.com,
        Stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 31 Jan 2023 10:52:43 +0100
Message-ID: <1675158763210117@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    iio: hid: fix the retval in accel_3d_capture_sample

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From f7b23d1c35d8b8de1425bdfccaefd01f3b7c9d1c Mon Sep 17 00:00:00 2001
From: Dmitry Perchanov <dmitry.perchanov@intel.com>
Date: Wed, 11 Jan 2023 14:22:10 +0200
Subject: iio: hid: fix the retval in accel_3d_capture_sample

Return value should be zero for success. This was forgotten for timestamp
feature. Verified on RealSense cameras.

Fixes: a96cd0f901ee ("iio: accel: hid-sensor-accel-3d: Add timestamp")
Signed-off-by: Dmitry Perchanov <dmitry.perchanov@intel.com>
Link: https://lore.kernel.org/r/a6dc426498221c81fa71045b41adf782ebd42136.camel@intel.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/iio/accel/hid-sensor-accel-3d.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iio/accel/hid-sensor-accel-3d.c b/drivers/iio/accel/hid-sensor-accel-3d.c
index a2def6f9380a..5eac7ea19993 100644
--- a/drivers/iio/accel/hid-sensor-accel-3d.c
+++ b/drivers/iio/accel/hid-sensor-accel-3d.c
@@ -280,6 +280,7 @@ static int accel_3d_capture_sample(struct hid_sensor_hub_device *hsdev,
 			hid_sensor_convert_timestamp(
 					&accel_state->common_attributes,
 					*(int64_t *)raw_data);
+		ret = 0;
 	break;
 	default:
 		break;
-- 
2.39.1


