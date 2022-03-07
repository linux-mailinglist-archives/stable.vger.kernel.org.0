Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2C3F4CF946
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:04:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238949AbiCGKEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240360AbiCGKA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:00:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B00C7140A2;
        Mon,  7 Mar 2022 01:47:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3F94E60FB3;
        Mon,  7 Mar 2022 09:47:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A376C340E9;
        Mon,  7 Mar 2022 09:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646465;
        bh=igfJvNVfCrUaBjyCAbRfQsvYSmOThCSr/ZM/OJv2Zss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fggn6gi3mUXmix12agHvjPilsmlyY06orY9l7I/03BQVEZZ4Vij1YHO8v1aJ6T9HW
         DKKi5ZaIFmUzMmduqelewqDsAXgEw0emAcWlI/dRGS7UmBzbpVgIGnC1gDe5GGpWDh
         B8Pg10dcQ1/ZSIH9H+jQwVpjtgJ9ghfu/r5hCGk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, William Mahon <wmahon@chromium.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 251/262] HID: add mapping for KEY_ALL_APPLICATIONS
Date:   Mon,  7 Mar 2022 10:19:55 +0100
Message-Id: <20220307091710.716883909@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: William Mahon <wmahon@chromium.org>

commit 327b89f0acc4c20a06ed59e4d9af7f6d804dc2e2 upstream.

This patch adds a new key definition for KEY_ALL_APPLICATIONS
and aliases KEY_DASHBOARD to it.

It also maps the 0x0c/0x2a2 usage code to KEY_ALL_APPLICATIONS.

Signed-off-by: William Mahon <wmahon@chromium.org>
Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20220303035618.1.I3a7746ad05d270161a18334ae06e3b6db1a1d339@changeid
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-debug.c                |    4 +++-
 drivers/hid/hid-input.c                |    2 ++
 include/uapi/linux/input-event-codes.h |    3 ++-
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -825,7 +825,9 @@ static const char *keys[KEY_MAX + 1] = {
 	[KEY_F22] = "F22",			[KEY_F23] = "F23",
 	[KEY_F24] = "F24",			[KEY_PLAYCD] = "PlayCD",
 	[KEY_PAUSECD] = "PauseCD",		[KEY_PROG3] = "Prog3",
-	[KEY_PROG4] = "Prog4",			[KEY_SUSPEND] = "Suspend",
+	[KEY_PROG4] = "Prog4",
+	[KEY_ALL_APPLICATIONS] = "AllApplications",
+	[KEY_SUSPEND] = "Suspend",
 	[KEY_CLOSE] = "Close",			[KEY_PLAY] = "Play",
 	[KEY_FASTFORWARD] = "FastForward",	[KEY_BASSBOOST] = "BassBoost",
 	[KEY_PRINT] = "Print",			[KEY_HP] = "HP",
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -1083,6 +1083,8 @@ static void hidinput_configure_usage(str
 
 		case 0x29d: map_key_clear(KEY_KBD_LAYOUT_NEXT);	break;
 
+		case 0x2a2: map_key_clear(KEY_ALL_APPLICATIONS);	break;
+
 		case 0x2c7: map_key_clear(KEY_KBDINPUTASSIST_PREV);		break;
 		case 0x2c8: map_key_clear(KEY_KBDINPUTASSIST_NEXT);		break;
 		case 0x2c9: map_key_clear(KEY_KBDINPUTASSIST_PREVGROUP);		break;
--- a/include/uapi/linux/input-event-codes.h
+++ b/include/uapi/linux/input-event-codes.h
@@ -278,7 +278,8 @@
 #define KEY_PAUSECD		201
 #define KEY_PROG3		202
 #define KEY_PROG4		203
-#define KEY_DASHBOARD		204	/* AL Dashboard */
+#define KEY_ALL_APPLICATIONS	204	/* AC Desktop Show All Applications */
+#define KEY_DASHBOARD		KEY_ALL_APPLICATIONS
 #define KEY_SUSPEND		205
 #define KEY_CLOSE		206	/* AC Close */
 #define KEY_PLAY		207


