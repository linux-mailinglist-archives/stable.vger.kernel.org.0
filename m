Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C1C47FFFB
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:42:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239395AbhL0PmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:42:19 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:42342 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239912AbhL0Pkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:40:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0635ACE10CC;
        Mon, 27 Dec 2021 15:40:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF14CC36AFB;
        Mon, 27 Dec 2021 15:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619639;
        bh=XQGVRJHZHyeiaoSHEu//I3/GPk0uHMx+t2yWR9aF2GA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e8NcfQ37/PLO7mCZOD6uxKTBPsE5JCkmQEJsw9xypwxDzvobRqOgvz2oJgwu+25BR
         1yGfC+xBgXcxVF1iy2P051BI3hVbx9HGxoiyKIVxbauPq46w6MaMM4Ez2EIrsYTT1g
         ZI8C33H1piNWd/tYs6nbZt2k4eu6Wc6rt7dJi0/8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.15 007/128] HID: holtek: fix mouse probing
Date:   Mon, 27 Dec 2021 16:29:42 +0100
Message-Id: <20211227151331.747727899@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
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
@@ -65,8 +65,23 @@ static __u8 *holtek_mouse_report_fixup(s
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
 


