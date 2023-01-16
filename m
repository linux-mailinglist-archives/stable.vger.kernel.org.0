Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40E2866C48E
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjAPP4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbjAPP4A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:56:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B1447ECB
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:55:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6BF2B8105C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:55:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BC36C433D2;
        Mon, 16 Jan 2023 15:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884555;
        bh=MU8wepNEKBoAoupapCSody0HU15y//59seMrIiAZ70E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0Av2XvtgYEmhBi5XRebMQHYwyMvFsEAoO0Ln2ealg1cs+xBK7ONe4ITJbaCo6kCIN
         8tNjNKrfB8yeUd7QgT+38GCjveTSNEow551RLmEOSON7gteTFerGWDFThdVtZ6isTF
         VRBvzLZ+VFVeAo6gJuBZJ14mxqBoEsH0hiaRW6mY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.1 051/183] platform/x86: dell-privacy: Fix SW_CAMERA_LENS_COVER reporting
Date:   Mon, 16 Jan 2023 16:49:34 +0100
Message-Id: <20230116154805.519705490@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Hans de Goede <hdegoede@redhat.com>

commit 1af7fef0d9d3fa075bf4e850f705df1fe97d33ce upstream.

Use KE_VSW instead of KE_SW for the SW_CAMERA_LENS_COVER key_entry
and get the value of the switch from the status field when handling
SW_CAMERA_LENS_COVER events, instead of always reporting 0.

Also correctly set the initial SW_CAMERA_LENS_COVER value.

Fixes: 8af9fa37b8a3 ("platform/x86: dell-privacy: Add support for Dell hardware privacy")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20221221220724.119594-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/dell-wmi-privacy.c |   22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

--- a/drivers/platform/x86/dell/dell-wmi-privacy.c
+++ b/drivers/platform/x86/dell/dell-wmi-privacy.c
@@ -61,7 +61,7 @@ static const struct key_entry dell_wmi_k
 	/* privacy mic mute */
 	{ KE_KEY, 0x0001, { KEY_MICMUTE } },
 	/* privacy camera mute */
-	{ KE_SW,  0x0002, { SW_CAMERA_LENS_COVER } },
+	{ KE_VSW, 0x0002, { SW_CAMERA_LENS_COVER } },
 	{ KE_END, 0},
 };
 
@@ -115,11 +115,15 @@ bool dell_privacy_process_event(int type
 
 	switch (code) {
 	case DELL_PRIVACY_AUDIO_EVENT: /* Mic mute */
-	case DELL_PRIVACY_CAMERA_EVENT: /* Camera mute */
 		priv->last_status = status;
 		sparse_keymap_report_entry(priv->input_dev, key, 1, true);
 		ret = true;
 		break;
+	case DELL_PRIVACY_CAMERA_EVENT: /* Camera mute */
+		priv->last_status = status;
+		sparse_keymap_report_entry(priv->input_dev, key, !(status & CAMERA_STATUS), false);
+		ret = true;
+		break;
 	default:
 		dev_dbg(&priv->wdev->dev, "unknown event type 0x%04x 0x%04x\n", type, code);
 	}
@@ -304,6 +308,11 @@ static int dell_privacy_wmi_probe(struct
 
 	dev_set_drvdata(&wdev->dev, priv);
 	priv->wdev = wdev;
+
+	ret = get_current_status(priv->wdev);
+	if (ret)
+		return ret;
+
 	/* create evdev passing interface */
 	priv->input_dev = devm_input_allocate_device(&wdev->dev);
 	if (!priv->input_dev)
@@ -342,11 +351,12 @@ static int dell_privacy_wmi_probe(struct
 	priv->input_dev->name = "Dell Privacy Driver";
 	priv->input_dev->id.bustype = BUS_HOST;
 
-	ret = input_register_device(priv->input_dev);
-	if (ret)
-		return ret;
+	/* Report initial camera-cover status */
+	if (priv->features_present & BIT(DELL_PRIVACY_TYPE_CAMERA))
+		input_report_switch(priv->input_dev, SW_CAMERA_LENS_COVER,
+				    !(priv->last_status & CAMERA_STATUS));
 
-	ret = get_current_status(priv->wdev);
+	ret = input_register_device(priv->input_dev);
 	if (ret)
 		return ret;
 


