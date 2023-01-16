Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B5B066C54B
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232018AbjAPQEZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:04:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232123AbjAPQDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:03:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A86325E29
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:02:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AA9561045
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 518B3C433EF;
        Mon, 16 Jan 2023 16:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884963;
        bh=yKveCU/hW6W4nNgauuF28gfEZ5f+yCW/4SfgMmD6XkU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pejw3G+rcXUE5tQp1BwXeHmWLAou6mpR5EoGu/zpmTavojB+OHC+tfxzelFR3Xczy
         xWT7z+PooppYANcyAvpzo6Ph2ttD04TJiGcAwR8sI1PH9Vr14wZpl71Cy3ttGW4g2f
         8m76NqyrvMveqyAz0ZxRyWSeOCpuxLYE25XFTwyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 22/86] platform/x86: dell-privacy: Fix SW_CAMERA_LENS_COVER reporting
Date:   Mon, 16 Jan 2023 16:50:56 +0100
Message-Id: <20230116154748.030498251@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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
@@ -307,6 +311,11 @@ static int dell_privacy_wmi_probe(struct
 
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
@@ -345,11 +354,12 @@ static int dell_privacy_wmi_probe(struct
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
 


