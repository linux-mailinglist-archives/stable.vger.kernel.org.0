Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D908266C546
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbjAPQET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbjAPQDl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:03:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D542384C
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:02:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0037E61045
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1735DC433F0;
        Mon, 16 Jan 2023 16:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884958;
        bh=9Ze9LIHHY6BwSB7dGnFn+PUCMl0LJ5jbNK/TSTZzAVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yNhv3p86Cb8HXeksGm/i4NcMf0WgrzfVAsnTH8vodrq0wJPbfoqDNujCwXkUvpVOd
         nWNeFezffLGEH5YQikUnhRqqEWD5VVnBh+ePLBi8u1K7Ha4ltrhGQGO6POV+fM8mDF
         qA7NCPjSWnBSSLbGqFulb24r4g8IxkFGtqFgpT1w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.15 20/86] platform/x86: dell-privacy: Only register SW_CAMERA_LENS_COVER if present
Date:   Mon, 16 Jan 2023 16:50:54 +0100
Message-Id: <20230116154747.936812983@linuxfoundation.org>
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

commit 6dc485f9940df8105ea729cbeb7a7d18d409dde5 upstream.

Unlike keys where userspace only reacts to keypresses, userspace may act
on switches in both (0 and 1) of their positions.

For example if a SW_TABLET_MODE switch is registered then GNOME will not
automatically show the onscreen keyboard when a text field gets focus on
touchscreen devices when SW_TABLET_MODE reports 0 and when SW_TABLET_MODE
reports 1 libinput will block (filter out) builtin keyboard and touchpad
events.

So to avoid unwanted side-effects EV_SW type inputs should only be
registered if they are actually present, only register SW_CAMERA_LENS_COVER
if it is actually there.

Fixes: 8af9fa37b8a3 ("platform/x86: dell-privacy: Add support for Dell hardware privacy")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20221221220724.119594-2-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/dell/dell-wmi-privacy.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/platform/x86/dell/dell-wmi-privacy.c
+++ b/drivers/platform/x86/dell/dell-wmi-privacy.c
@@ -295,7 +295,7 @@ static int dell_privacy_wmi_probe(struct
 {
 	struct privacy_wmi_data *priv;
 	struct key_entry *keymap;
-	int ret, i;
+	int ret, i, j;
 
 	ret = wmi_has_guid(DELL_PRIVACY_GUID);
 	if (!ret)
@@ -321,9 +321,20 @@ static int dell_privacy_wmi_probe(struct
 	/* remap the keymap code with Dell privacy key type 0x12 as prefix
 	 * KEY_MICMUTE scancode will be reported as 0x120001
 	 */
-	for (i = 0; i < ARRAY_SIZE(dell_wmi_keymap_type_0012); i++) {
-		keymap[i] = dell_wmi_keymap_type_0012[i];
-		keymap[i].code |= (0x0012 << 16);
+	for (i = 0, j = 0; i < ARRAY_SIZE(dell_wmi_keymap_type_0012); i++) {
+		/*
+		 * Unlike keys where only presses matter, userspace may act
+		 * on switches in both of their positions. Only register
+		 * SW_CAMERA_LENS_COVER if it is actually there.
+		 */
+		if (dell_wmi_keymap_type_0012[i].type == KE_VSW &&
+		    dell_wmi_keymap_type_0012[i].sw.code == SW_CAMERA_LENS_COVER &&
+		    !(priv->features_present & BIT(DELL_PRIVACY_TYPE_CAMERA)))
+			continue;
+
+		keymap[j] = dell_wmi_keymap_type_0012[i];
+		keymap[j].code |= (0x0012 << 16);
+		j++;
 	}
 	ret = sparse_keymap_setup(priv->input_dev, keymap, NULL);
 	kfree(keymap);


