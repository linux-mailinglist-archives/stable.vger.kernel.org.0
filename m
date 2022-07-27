Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 290A5582B6C
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237685AbiG0QdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237844AbiG0Qc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:32:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06EB753D2A;
        Wed, 27 Jul 2022 09:26:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3832617EF;
        Wed, 27 Jul 2022 16:26:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9775C433D6;
        Wed, 27 Jul 2022 16:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939176;
        bh=QF7pyE183J3Q+46NmYFF2shA3xAIisb+KwOnK6MxcHc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=agHXFFMe9Zg8j+SrG1RRDS6a+z1suvfQ/Ip8kqvJ2s2IOzOllZINa+/1msjzwpnb3
         osYTEziTsbGwLQWqMLQ4kG9EY1m/pZLO1RDRiD61y0LZRrgrvvM91bzlnRXjkGhd3Z
         /RzijGqHWWfqlstWl1OZ8JAN4HZwmpW+Fqf0a9u0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Mikael=20Wikstr=C3=B6m?= <leakim.wikstrom@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/62] HID: multitouch: Lenovo X1 Tablet Gen3 trackpoint and buttons
Date:   Wed, 27 Jul 2022 18:10:48 +0200
Message-Id: <20220727161005.716889599@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161004.175638564@linuxfoundation.org>
References: <20220727161004.175638564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikael Wikström <leakim.wikstrom@gmail.com>

[ Upstream commit 8d5037dca7c2089f27e5903c2aecfc5bb10d7806 ]

Add support for the trackpoint and three mouse buttons on the type cover
of the Lenovo X1 Tablet Gen3.

This is the same as with the 2nd generation Lenovo X1 Tablet.

Signed-off-by: Mikael Wikström <leakim.wikstrom@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h        | 1 +
 drivers/hid/hid-multitouch.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 8d4153c73f5c..1c1de7e128d6 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -727,6 +727,7 @@
 #define USB_DEVICE_ID_LENOVO_TPPRODOCK	0x6067
 #define USB_DEVICE_ID_LENOVO_X1_COVER	0x6085
 #define USB_DEVICE_ID_LENOVO_X1_TAB	0x60a3
+#define USB_DEVICE_ID_LENOVO_X1_TAB3	0x60b5
 
 #define USB_VENDOR_ID_LG		0x1fd2
 #define USB_DEVICE_ID_LG_MULTITOUCH	0x0064
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 5509b09f8656..1c4426c60972 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -1797,6 +1797,12 @@ static const struct hid_device_id mt_devices[] = {
 			   USB_VENDOR_ID_LENOVO,
 			   USB_DEVICE_ID_LENOVO_X1_TAB) },
 
+	/* Lenovo X1 TAB Gen 3 */
+	{ .driver_data = MT_CLS_WIN_8_DUAL,
+		HID_DEVICE(BUS_USB, HID_GROUP_MULTITOUCH_WIN_8,
+			   USB_VENDOR_ID_LENOVO,
+			   USB_DEVICE_ID_LENOVO_X1_TAB3) },
+
 	/* Anton devices */
 	{ .driver_data = MT_CLS_EXPORT_ALL_INPUTS,
 		MT_USB_DEVICE(USB_VENDOR_ID_ANTON,
-- 
2.35.1



