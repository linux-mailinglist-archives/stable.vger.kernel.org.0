Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5905868D8E9
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232386AbjBGNOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232441AbjBGNNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:13:48 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6486420D02
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:13:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1EF33CE1D84
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:12:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0717DC4339B;
        Tue,  7 Feb 2023 13:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775558;
        bh=R8yxPxswQfdVA4vNsGwfUaT5orb6tITM5WhgNHlhtt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BkJxrvTviiKNWtNyxGV/+WEpLQdxrMXd42fmvn0DfVTvWXf5GfFL6cXEEini0VoGd
         l6Q11dGwDE5UhrKrvsMQVxmZwvsCFtPH2M9katznPDsjZ0APDHshWk58ZMubgrQni3
         RV89/4DMIwpQmQkdsw+zTU8z5hRBk+Et1o+vH1kE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Perchanov <dmitry.perchanov@intel.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 073/120] iio: hid: fix the retval in accel_3d_capture_sample
Date:   Tue,  7 Feb 2023 13:57:24 +0100
Message-Id: <20230207125621.864061336@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Perchanov <dmitry.perchanov@intel.com>

commit f7b23d1c35d8b8de1425bdfccaefd01f3b7c9d1c upstream.

Return value should be zero for success. This was forgotten for timestamp
feature. Verified on RealSense cameras.

Fixes: a96cd0f901ee ("iio: accel: hid-sensor-accel-3d: Add timestamp")
Signed-off-by: Dmitry Perchanov <dmitry.perchanov@intel.com>
Link: https://lore.kernel.org/r/a6dc426498221c81fa71045b41adf782ebd42136.camel@intel.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/hid-sensor-accel-3d.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/accel/hid-sensor-accel-3d.c
+++ b/drivers/iio/accel/hid-sensor-accel-3d.c
@@ -280,6 +280,7 @@ static int accel_3d_capture_sample(struc
 			hid_sensor_convert_timestamp(
 					&accel_state->common_attributes,
 					*(int64_t *)raw_data);
+		ret = 0;
 	break;
 	default:
 		break;


