Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12A0E461F1D
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379551AbhK2Sny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:43:54 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:44598 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379674AbhK2Slv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:41:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8820AB815DB;
        Mon, 29 Nov 2021 18:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F55C53FAD;
        Mon, 29 Nov 2021 18:38:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211111;
        bh=8TQiQF5wAUWqIZhPncuWfp4/Fwa5Zyv/dzddyFXo+G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2wTosMHklS6ZTrjvAUB3Yhc6DlgjwFjqd07ufTkvWBE83pTn00Enc2PfVXGEO+psM
         Zm5ywUHy5MpzWkSTSvcDReil+uAhER93d6iB1DYg5paFItaSmtvaW22To2touNTwKW
         kOjgX0JT0vRXQLjgvQjowzD033ATiSCfhHyXddmQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brent Roman <brent@mbari.org>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 096/179] HID: input: set usage type to key on keycode remap
Date:   Mon, 29 Nov 2021 19:18:10 +0100
Message-Id: <20211129181722.088037855@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 3e6a950d98366f5e716904e9a7e8ffc7ed638bd6 ]

When a scancode is manually remapped that previously was not handled as
key, then the old usage type was incorrectly reused.

This caused issues on a "04b3:301b IBM Corp. SK-8815 Keyboard" which has
marked some of its keys with an invalid HID usage.  These invalid usage
keys are being ignored since support for USB programmable buttons was
added.

The scancodes are however remapped explicitly by the systemd hwdb to the
keycodes that are printed on the physical buttons.  During this mapping
step the existing usage is retrieved which will be found with a default
type of 0 (EV_SYN) instead of EV_KEY.

The events with the correct code but EV_SYN type are not forwarded to
userspace.

This also leads to a kernel oops when trying to print the report descriptor
via debugfs.  hid_resolv_event() tries to resolve a EV_SYN event with an
EV_KEY code which leads to an out-of-bounds access in the EV_SYN names
array.

Fixes: bcfa8d1457 ("HID: input: Add support for Programmable Buttons")
Fixes: f5854fad39 ("Input: hid-input - allow mapping unknown usages")
Reported-by: Brent Roman <brent@mbari.org>
Tested-by: Brent Roman <brent@mbari.org>
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 4b3f4a5e23058..6561770f1af55 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -160,6 +160,7 @@ static int hidinput_setkeycode(struct input_dev *dev,
 	if (usage) {
 		*old_keycode = usage->type == EV_KEY ?
 				usage->code : KEY_RESERVED;
+		usage->type = EV_KEY;
 		usage->code = ke->keycode;
 
 		clear_bit(*old_keycode, dev->keybit);
-- 
2.33.0



