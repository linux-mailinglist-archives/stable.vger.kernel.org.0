Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E299F32891C
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239015AbhCARuj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:50:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:33838 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238942AbhCARn5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:43:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB73B650D4;
        Mon,  1 Mar 2021 16:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617904;
        bh=GGvn9oaFDzz4AeZw96VW7uUROdpZz/ZUlYAqdIy4lxQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZnjBpD+kNEnrrZhKuDcTueRbCI87qnMK3Zt7goG3lXCWFP7mmqG5qHhWQ0robbm6A
         FiIFVG2c9hFuqh0MbjAdf2utJw0EE3sZBPhpHCYnSv5ucF9ke+cWLfAxQKEsql+OfS
         z+iTtapi515W0PZM8BI8zxF77ysKPFpZ+HOhCOlo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Filipe=20La=C3=ADns?= <lains@riseup.net>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.4 238/340] HID: logitech-dj: add support for keyboard events in eQUAD step 4 Gaming
Date:   Mon,  1 Mar 2021 17:13:02 +0100
Message-Id: <20210301161100.007996643@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Filipe Laíns <lains@riseup.net>

commit ef07c116d98772952807492bd32a61f5af172a94 upstream.

In e400071a805d6229223a98899e9da8c6233704a1 I added support for the
receiver that comes with the G602 device, but unfortunately I screwed up
during testing and it seems the keyboard events were actually not being
sent to userspace.
This resulted in keyboard events being broken in userspace, please
backport the fix.

The receiver uses the normal 0x01 Logitech keyboard report descriptor,
as expected, so it is just a matter of flagging it as supported.

Reported in
https://github.com/libratbag/libratbag/issues/1124

Fixes: e400071a805d6 ("HID: logitech-dj: add the G602 receiver")
Cc: <stable@vger.kernel.org>
Signed-off-by: Filipe Laíns <lains@riseup.net>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-logitech-dj.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -980,6 +980,7 @@ static void logi_hidpp_recv_queue_notif(
 	case 0x07:
 		device_type = "eQUAD step 4 Gaming";
 		logi_hidpp_dev_conn_notif_equad(hdev, hidpp_report, &workitem);
+		workitem.reports_supported |= STD_KEYBOARD;
 		break;
 	case 0x08:
 		device_type = "eQUAD step 4 for gamepads";


