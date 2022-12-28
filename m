Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2D0E657906
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbiL1O4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233271AbiL1O4p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:56:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F91B69
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 06:56:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 747E16151F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 14:56:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871F2C433EF;
        Wed, 28 Dec 2022 14:56:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672239403;
        bh=3zxdj9fRZxlIrvdw1ZwgYZhi4ueY1HbY+3DNRBCDTxA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tTzwAYz7W+yrkqoFXqLNHYFzuYPwMCxYaxDj3qx2NTz5oKiOuy/GHVrbqWbOn+mDx
         YmfOt7kQvfMq5g1aS1DDk80caD2BXareQuPsWLj6cwAR3/H+waW2WGq+wBh7GmOTNe
         I+Hzm9qB0LVCtcu9Guy5+JywGoJlhyof+5DRAm8Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Marcus Folkesson <marcus.folkesson@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 219/731] HID: hid-sensor-custom: set fixed size for custom attributes
Date:   Wed, 28 Dec 2022 15:35:26 +0100
Message-Id: <20221228144302.909085015@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index 32c2306e240d..602465ad2745 100644
--- a/drivers/hid/hid-sensor-custom.c
+++ b/drivers/hid/hid-sensor-custom.c
@@ -62,7 +62,7 @@ struct hid_sensor_sample {
 	u32 raw_len;
 } __packed;
 
-static struct attribute hid_custom_attrs[] = {
+static struct attribute hid_custom_attrs[HID_CUSTOM_TOTAL_ATTRS] = {
 	{.name = "name", .mode = S_IRUGO},
 	{.name = "units", .mode = S_IRUGO},
 	{.name = "unit-expo", .mode = S_IRUGO},
-- 
2.35.1



