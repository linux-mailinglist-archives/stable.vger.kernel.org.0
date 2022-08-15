Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3B0593B15
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239111AbiHOUG6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346239AbiHOUGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:06:19 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3824F81B23;
        Mon, 15 Aug 2022 11:55:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D8D90CE1277;
        Mon, 15 Aug 2022 18:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0B10C433C1;
        Mon, 15 Aug 2022 18:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589702;
        bh=llpMxHGJXWP5cf7sbBkd+Qs7oAxQTdYK6TfLN8Q4UGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W9bib26XbqEtKdeUdCbNdlNK7pzPAQ0oos6O1T0etLamGVaz2zF0TkviN0K4xhXNg
         buEeEfSIiq36iE3xb+O4SAj9dqV5bdEbBX1w0HWNczjznZ/MfmbbeJNdtd6Bq8cpoW
         53aeL3rAvuOYeiS1oEFSmgOfRy2+zEtFn6WJSv2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ping Cheng <ping.cheng@wacom.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.18 0021/1095] HID: wacom: Only report rotation for art pen
Date:   Mon, 15 Aug 2022 19:50:20 +0200
Message-Id: <20220815180430.226829268@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Ping Cheng <pinglinux@gmail.com>

commit 7ccced33a0ba39b0103ae1dfbf7f1dffdc0a1bc2 upstream.

The generic routine, wacom_wac_pen_event, turns rotation value 90
degree anti-clockwise before posting the events. This non-zero
event trggers a non-zero ABS_Z event for non art pen tools. However,
HID_DG_TWIST is only supported by art pen.

[jkosina@suse.cz: fix build: add missing brace]
Cc: stable@vger.kernel.org
Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Reviewed-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |   29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -638,9 +638,26 @@ static int wacom_intuos_id_mangle(int to
 	return (tool_id & ~0xFFF) << 4 | (tool_id & 0xFFF);
 }
 
+static bool wacom_is_art_pen(int tool_id)
+{
+	bool is_art_pen = false;
+
+	switch (tool_id) {
+	case 0x885:	/* Intuos3 Marker Pen */
+	case 0x804:	/* Intuos4/5 13HD/24HD Marker Pen */
+	case 0x10804:	/* Intuos4/5 13HD/24HD Art Pen */
+		is_art_pen = true;
+		break;
+	}
+	return is_art_pen;
+}
+
 static int wacom_intuos_get_tool_type(int tool_id)
 {
-	int tool_type;
+	int tool_type = BTN_TOOL_PEN;
+
+	if (wacom_is_art_pen(tool_id))
+		return tool_type;
 
 	switch (tool_id) {
 	case 0x812: /* Inking pen */
@@ -655,12 +672,9 @@ static int wacom_intuos_get_tool_type(in
 	case 0x852:
 	case 0x823: /* Intuos3 Grip Pen */
 	case 0x813: /* Intuos3 Classic Pen */
-	case 0x885: /* Intuos3 Marker Pen */
 	case 0x802: /* Intuos4/5 13HD/24HD General Pen */
-	case 0x804: /* Intuos4/5 13HD/24HD Marker Pen */
 	case 0x8e2: /* IntuosHT2 pen */
 	case 0x022:
-	case 0x10804: /* Intuos4/5 13HD/24HD Art Pen */
 	case 0x10842: /* MobileStudio Pro Pro Pen slim */
 	case 0x14802: /* Intuos4/5 13HD/24HD Classic Pen */
 	case 0x16802: /* Cintiq 13HD Pro Pen */
@@ -718,10 +732,6 @@ static int wacom_intuos_get_tool_type(in
 	case 0x10902: /* Intuos4/5 13HD/24HD Airbrush */
 		tool_type = BTN_TOOL_AIRBRUSH;
 		break;
-
-	default: /* Unknown tool */
-		tool_type = BTN_TOOL_PEN;
-		break;
 	}
 	return tool_type;
 }
@@ -2323,6 +2333,9 @@ static void wacom_wac_pen_event(struct h
 		}
 		return;
 	case HID_DG_TWIST:
+		/* don't modify the value if the pen doesn't support the feature */
+		if (!wacom_is_art_pen(wacom_wac->id[0])) return;
+
 		/*
 		 * Userspace expects pen twist to have its zero point when
 		 * the buttons/finger is on the tablet's left. HID values


