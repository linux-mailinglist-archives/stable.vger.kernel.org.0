Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C396328EDE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238211AbhCATjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:39:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:48632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241950AbhCATaA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:30:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C6E0564E09;
        Mon,  1 Mar 2021 17:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619527;
        bh=SAfqGVoDVV7vGzd+ShP/ahMF4bUwHmopoaMbIMk9GZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2GXdPojdwu8CEQyT7q4ijCNqiMWSrfCBiuL3Sq9VmkQzAfLzxc9nTznhkiXQcEJr
         HjTMrZRZDAnte9G7gMSy9k18BRDw4B0gasjyiYLCw0r2tidC5doj2CsR0xqIV9xeFt
         Fl5FsThBjPWdmuIMjD8uFTl8pniDeapVI/wFqXmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.10 485/663] HID: wacom: Ignore attempts to overwrite the touch_max value from HID
Date:   Mon,  1 Mar 2021 17:12:13 +0100
Message-Id: <20210301161205.855240073@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <killertofu@gmail.com>

commit 88f38846bfb1a452a3d47e38aeab20a4ceb74294 upstream.

The `wacom_feature_mapping` function is careful to only set the the
touch_max value a single time, but this care does not extend to the
`wacom_wac_finger_event` function. In particular, if a device sends
multiple HID_DG_CONTACTMAX items in a single feature report, the
driver will end up retaining the value of last item.

The HID descriptor for the Cintiq Companion 2 does exactly this. It
incorrectly sets a "Report Count" of 2, which will cause the driver
to process two HID_DG_CONTACTCOUNT items. The first item has the actual
count, while the second item should have been declared as a constant
zero. The constant zero is the value the driver ends up using, however,
since it is the last HID_DG_CONTACTCOUNT in the report.

    Report ID (16),
    Usage (Contact Count Maximum),  ; Contact count maximum (55h, static value)
    Report Count (2),
    Logical Maximum (10),
    Feature (Variable),

To address this, we add a check that the touch_max is not already set
within the `wacom_wac_finger_event` function that processes the
HID_DG_TOUCHMAX item. We emit a warning if the value is set and ignore
the updated value.

This could potentially cause problems if there is a tablet which has
a similar issue but requires the last item to be used. This is unlikely,
however, since it would have to have a different non-zero value for
HID_DG_CONTACTMAX earlier in the same report, which makes no sense
except in the case of a firmware bug. Note that cases where the
HID_DG_CONTACTMAX items are in different reports is already handled
(and similarly ignored) by `wacom_feature_mapping` as mentioned above.

Link: https://github.com/linuxwacom/input-wacom/issues/223
Fixes: 184eccd40389 ("HID: wacom: generic: read HID_DG_CONTACTMAX from any feature report")
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
CC: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2600,7 +2600,12 @@ static void wacom_wac_finger_event(struc
 		wacom_wac->is_invalid_bt_frame = !value;
 		return;
 	case HID_DG_CONTACTMAX:
-		features->touch_max = value;
+		if (!features->touch_max) {
+			features->touch_max = value;
+		} else {
+			hid_warn(hdev, "%s: ignoring attempt to overwrite non-zero touch_max "
+				 "%d -> %d\n", __func__, features->touch_max, value);
+		}
 		return;
 	}
 


