Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBD547FE60
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:29:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237459AbhL0P2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:28:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:33730 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237480AbhL0P2W (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:28:22 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C0397B80E5A;
        Mon, 27 Dec 2021 15:28:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6427C36AE7;
        Mon, 27 Dec 2021 15:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640618900;
        bh=zQ8vvOoixBGGLwwy+ukLE3ZLYdW2CEhpCp6iJpG+xGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZRAEoL0ECjXuBZM4dVd8e90m002LdLFBq9DzL+AZ3bCFkYNPeTNFE/V9+cv0zzPDS
         88yuxDvsgGLNmRAjhT4Uu6oKRHtf8ME5Gojx78M//QerwQ7D9wLGJms7JU7eFVsQlI
         Tja7ImtW4Q/4ec/+zY0SJ4ZYQv/UzNxnyaAI4tcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 4.9 03/19] HID: holtek: fix mouse probing
Date:   Mon, 27 Dec 2021 16:27:05 +0100
Message-Id: <20211227151316.666094429@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151316.558965545@linuxfoundation.org>
References: <20211227151316.558965545@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Tissoires <benjamin.tissoires@redhat.com>

commit 93a2207c254ca102ebbdae47b00f19bbfbfa7ecd upstream.

An overlook from the previous commit: we don't even parse or start the
device, meaning that the device is not presented to user space.

Fixes: 93020953d0fa ("HID: check for valid USB device for many HID drivers")
Cc: stable@vger.kernel.org
Link: https://bugs.archlinux.org/task/73048
Link: https://bugzilla.kernel.org/show_bug.cgi?id=215341
Link: https://lore.kernel.org/r/e4efbf13-bd8d-0370-629b-6c80c0044b15@leemhuis.info/
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-holtek-mouse.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/hid/hid-holtek-mouse.c
+++ b/drivers/hid/hid-holtek-mouse.c
@@ -68,8 +68,23 @@ static __u8 *holtek_mouse_report_fixup(s
 static int holtek_mouse_probe(struct hid_device *hdev,
 			      const struct hid_device_id *id)
 {
+	int ret;
+
 	if (!hid_is_usb(hdev))
 		return -EINVAL;
+
+	ret = hid_parse(hdev);
+	if (ret) {
+		hid_err(hdev, "hid parse failed: %d\n", ret);
+		return ret;
+	}
+
+	ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT);
+	if (ret) {
+		hid_err(hdev, "hw start failed: %d\n", ret);
+		return ret;
+	}
+
 	return 0;
 }
 


