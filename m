Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6C3B4BDF81
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349014AbiBUJXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:23:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349870AbiBUJVw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:21:52 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888E1369F9;
        Mon, 21 Feb 2022 01:09:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 058F4CE0E77;
        Mon, 21 Feb 2022 09:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA350C340E9;
        Mon, 21 Feb 2022 09:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434549;
        bh=Pn+e5CQp2HkV2HlvCbZDTNJZ4gGw6N/ypn6UzL9jeAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mP15QBsDHqQqF6xrW8XxMKunXpSj52Woc6po+MMoeIBpv1GlZ88orV4blxrQFJJEV
         8Opm+V6CDZq+COAyMlX5N0inhXWkeQMIGEdEr7owySCm4GmM67ySERl8k6wQ7gfCVZ
         6YJyzgWvu1tGQ54hwcIN6kzezSSMQSq2rO/XZ7sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.15 014/196] HID: amd_sfh: Add illuminance mask to limit ALS max value
Date:   Mon, 21 Feb 2022 09:47:26 +0100
Message-Id: <20220221084931.367555413@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

commit 91aaea527bc3b707c5d3208cde035421ed54f79c upstream.

ALS illuminance value present only in first 15 bits from SFH firmware
for V2 platforms. Hence added a mask of 15 bit to limit ALS max
illuminance values to get correct illuminance value.

Fixes: 0aad9c95eb9a ("HID: amd_sfh: Extend ALS support for newer AMD platform")
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/amd-sfh-hid/hid_descriptor/amd_sfh_hid_desc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hid/amd-sfh-hid/hid_descriptor/amd_sfh_hid_desc.c
+++ b/drivers/hid/amd-sfh-hid/hid_descriptor/amd_sfh_hid_desc.c
@@ -26,6 +26,7 @@
 #define HID_USAGE_SENSOR_STATE_READY_ENUM                             0x02
 #define HID_USAGE_SENSOR_STATE_INITIALIZING_ENUM                      0x05
 #define HID_USAGE_SENSOR_EVENT_DATA_UPDATED_ENUM                      0x04
+#define ILLUMINANCE_MASK					GENMASK(14, 0)
 
 int get_report_descriptor(int sensor_idx, u8 *rep_desc)
 {
@@ -245,7 +246,8 @@ u8 get_input_report(u8 current_index, in
 		get_common_inputs(&als_input.common_property, report_id);
 		/* For ALS ,V2 Platforms uses C2P_MSG5 register instead of DRAM access method */
 		if (supported_input == V2_STATUS)
-			als_input.illuminance_value = (int)readl(privdata->mmio + AMD_C2P_MSG(5));
+			als_input.illuminance_value =
+				readl(privdata->mmio + AMD_C2P_MSG(5)) & ILLUMINANCE_MASK;
 		else
 			als_input.illuminance_value =
 				(int)sensor_virt_addr[0] / AMD_SFH_FW_MULTIPLIER;


