Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826A96674EE
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235697AbjALOQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:16:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbjALOPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:15:23 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A341955653
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:07:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 197D8CE1E6E
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:07:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9A83C433EF;
        Thu, 12 Jan 2023 14:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532445;
        bh=LGOHPDBw1KAt+raTD7/6s1bLsfE+D6jrN6uafj/hFC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gRqf9kpzjyf66mLLKvivmAuAHS7JfsccuTt1de0MFCg2tBtjdZSFHNmsbnUPltNr7
         aRxzsznrYX+GyqAySPo4BdEasvbZ4d1XXXpuNdaEVBVuyMl3DLY6xgTPh0UbIe3GYK
         QevtjLkkf0MgRKVu7FQypTzKlOyVI6F+jWZGyeQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 164/783] HID: hid-sensor-custom: set fixed size for custom attributes
Date:   Thu, 12 Jan 2023 14:48:00 +0100
Message-Id: <20230112135531.935175666@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marcus Folkesson <marcus.folkesson@gmail.com>

[ Upstream commit 9d013910df22de91333a0acc81d1dbb115bd76f6 ]

This is no bugfix (so no Fixes: tag is necessary) as it is
taken care of in hid_sensor_custom_add_attributes().

The motivation for this patch is that:
hid_sensor_custom_field.attr_name and
hid_sensor_custom_field.attrs
has the size of HID_CUSTOM_TOTAL_ATTRS and used in same context.

We compare against HID_CUSTOM_TOTAL_ATTRS when
looping through hid_custom_attrs.

We will silent the smatch error:
hid_sensor_custom_add_attributes() error: buffer overflow
'hid_custom_attrs' 8 <= 10

Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-sensor-custom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/hid-sensor-custom.c b/drivers/hid/hid-sensor-custom.c
index 4d25577a8573..971600a6397a 100644
--- a/drivers/hid/hid-sensor-custom.c
+++ b/drivers/hid/hid-sensor-custom.c
@@ -59,7 +59,7 @@ struct hid_sensor_sample {
 	u32 raw_len;
 } __packed;
 
-static struct attribute hid_custom_attrs[] = {
+static struct attribute hid_custom_attrs[HID_CUSTOM_TOTAL_ATTRS] = {
 	{.name = "name", .mode = S_IRUGO},
 	{.name = "units", .mode = S_IRUGO},
 	{.name = "unit-expo", .mode = S_IRUGO},
-- 
2.35.1



