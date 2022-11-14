Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B28627FE7
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237703AbiKNNCc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:02:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237687AbiKNNC2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:02:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF37129369
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:02:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E4A961173
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFDDC433C1;
        Mon, 14 Nov 2022 13:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430946;
        bh=NvaNtfmqUDMCeqFWjAfpqtmNkblW/VWYIQLZaiZQIgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2tJM8S/PBbaI6MvQMpm3W0TLtYiEFxbOnjwnMlhzjRKRi73oE5H1cycGdgNxlBTa
         QbnChz9kJU6oIPIXSQTJb9fsfnLrW2S87zk/1lchnY/4W2T2sJZTCUl1HSeZ9uJxRk
         kWsfeOyAeeYTFBRBQtRCoWQrp+qWqMq0nlqji2uE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Gerecke <jason.gerecke@wacom.com>,
        Joshua Dickens <joshua.dickens@wacom.com>,
        Ping Cheng <ping.cheng@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 6.0 014/190] HID: wacom: Fix logic used for 3rd barrel switch emulation
Date:   Mon, 14 Nov 2022 13:43:58 +0100
Message-Id: <20221114124459.407870128@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Jason Gerecke <killertofu@gmail.com>

commit f77810f744139572a63e5a85ab6a8c10c2d44fb1 upstream.

When support was added for devices using an explicit 3rd barrel switch,
the logic used by devices emulating this feature was broken. The 'if'
statement / block that was introduced only handles the case where the
button is pressed (i.e. 'barrelswitch' and 'barrelswitch2' are both set)
but not the case where it is released (i.e. one or both being cleared).
This results in a BTN_STYLUS3 "down" event being sent when the button
is pressed, but no "up" event ever being sent afterwards.

This patch restores the previously-used logic for determining button
states in the emulated case so that switches are reported correctly
again.

Link: https://github.com/linuxwacom/xf86-input-wacom/issues/292
Fixes: 6d09085b38e5 ("HID: wacom: Adding Support for new usages")
CC: stable@vger.kernel.org #v5.19+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Tested-by: Joshua Dickens <joshua.dickens@wacom.com>
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2522,11 +2522,12 @@ static void wacom_wac_pen_report(struct
 
 	if (!delay_pen_events(wacom_wac) && wacom_wac->tool[0]) {
 		int id = wacom_wac->id[0];
-		if (wacom_wac->features.quirks & WACOM_QUIRK_PEN_BUTTON3 &&
-		    wacom_wac->hid_data.barrelswitch & wacom_wac->hid_data.barrelswitch2) {
-			wacom_wac->hid_data.barrelswitch = 0;
-			wacom_wac->hid_data.barrelswitch2 = 0;
-			wacom_wac->hid_data.barrelswitch3 = 1;
+		if (wacom_wac->features.quirks & WACOM_QUIRK_PEN_BUTTON3) {
+			int sw_state = wacom_wac->hid_data.barrelswitch |
+				       (wacom_wac->hid_data.barrelswitch2 << 1);
+			wacom_wac->hid_data.barrelswitch = sw_state == 1;
+			wacom_wac->hid_data.barrelswitch2 = sw_state == 2;
+			wacom_wac->hid_data.barrelswitch3 = sw_state == 3;
 		}
 		input_report_key(input, BTN_STYLUS, wacom_wac->hid_data.barrelswitch);
 		input_report_key(input, BTN_STYLUS2, wacom_wac->hid_data.barrelswitch2);


