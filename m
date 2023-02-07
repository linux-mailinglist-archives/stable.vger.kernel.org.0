Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A152568D8EA
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:14:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbjBGNOF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:14:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbjBGNNt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:13:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C952C3A873
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:13:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B10161411
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:13:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E690C4339E;
        Tue,  7 Feb 2023 13:13:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775590;
        bh=goxfcl1FFRAEnODy5PYLrPZbgVVInMCfajJ9h9X4jTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d6aDDR+T4zYRRZLpMTBvrfR9WbfkCyYaeV28NDXhhVl2Fh4cSm0N4iHdOdt/d9YiG
         Ta6nJaN/zZkhcyZGOZuJ3jcr6Uc2WeuyGoR/YOih/7fZrvAw4J4RQC2l5DBtusapHb
         nlIdRSXYbqKmOuzqSR6WaePxQO1tDj0DFyXOGA1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Perchanov <dmitry.perchanov@intel.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 074/120] iio: hid: fix the retval in gyro_3d_capture_sample
Date:   Tue,  7 Feb 2023 13:57:25 +0100
Message-Id: <20230207125621.911839410@linuxfoundation.org>
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

commit eb50cd5bfdac61627a5026566cf3b90ced7b141c upstream.

Return value should be zero for success. This was forgotten for timestamp
feature. Verified on RealSense cameras.

Fixes: 4648cbd8fb92 ("iio: hid-sensor-gyro-3d: Add timestamp channel")
Signed-off-by: Dmitry Perchanov <dmitry.perchanov@intel.com>
Link: https://lore.kernel.org/r/7c1809dc74eb2f58a20595f4d02e76934f8e9219.camel@intel.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/hid-sensor-gyro-3d.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/gyro/hid-sensor-gyro-3d.c
+++ b/drivers/iio/gyro/hid-sensor-gyro-3d.c
@@ -231,6 +231,7 @@ static int gyro_3d_capture_sample(struct
 		gyro_state->timestamp =
 			hid_sensor_convert_timestamp(&gyro_state->common_attributes,
 						     *(s64 *)raw_data);
+		ret = 0;
 	break;
 	default:
 		break;


