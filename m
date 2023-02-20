Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 063DC69CD19
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232228AbjBTNq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:46:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232276AbjBTNqZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:46:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAE5E1E1D3
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:46:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 555F660EA5
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61755C433D2;
        Mon, 20 Feb 2023 13:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900759;
        bh=lDb3a4n1+m7yiG4hrCi6sjlI4zceerWsskRi9lO9k/g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T202b7LpzNLNYHo34opOuAMulsBLN2ytAku6K5HR/+/7JLhxBJBYT0gDHIYljwKVO
         CCjD/CeDS3CMPcTekDxTXHnsCyAivvmv/p7u7OVTzBQMvfNiSOrJD2Vq1H7g660Y1y
         kBCitWsFFKwBPvlpe1TB6oHgMykt1Em+LFDyQWyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Perchanov <dmitry.perchanov@intel.com>,
        Stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 040/156] iio: hid: fix the retval in accel_3d_capture_sample
Date:   Mon, 20 Feb 2023 14:34:44 +0100
Message-Id: <20230220133604.047738639@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
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
@@ -279,6 +279,7 @@ static int accel_3d_capture_sample(struc
 			hid_sensor_convert_timestamp(
 					&accel_state->common_attributes,
 					*(int64_t *)raw_data);
+		ret = 0;
 	break;
 	default:
 		break;


