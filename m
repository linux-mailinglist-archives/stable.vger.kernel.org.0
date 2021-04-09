Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C3A359AB4
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 12:02:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232835AbhDIKB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 06:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233501AbhDIJ73 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:59:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 576F261182;
        Fri,  9 Apr 2021 09:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962328;
        bh=sHs/FS97B+N5judHhstV9Hj7XS0cduzfZr0kKXnAiXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAa+M5JDJql98V3d/O+2lfTr6aCFOQAAUYJrL5tIjBBZM8+AkVBIgexVxbvPOowsy
         LdqfpDTGK1jZ6go2q/B1s5dbsHnpisbsIoBtkX9k6phIzEDPYFzick9MphN+4VKpOO
         y/dQpoChcQf1sj+gZMOjG7fHqAxif8QJDNfaieTs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Esteve Varela Colominas <esteve.varela@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 17/41] platform/x86: thinkpad_acpi: Allow the FnLock LED to change state
Date:   Fri,  9 Apr 2021 11:53:39 +0200
Message-Id: <20210409095305.391635151@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095304.818847860@linuxfoundation.org>
References: <20210409095304.818847860@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Esteve Varela Colominas <esteve.varela@gmail.com>

[ Upstream commit 3d677f12ea3a2097a16ded570623567403dea959 ]

On many recent ThinkPad laptops, there's a new LED next to the ESC key,
that indicates the FnLock status.
When the Fn+ESC combo is pressed, FnLock is toggled, which causes the
Media Key functionality to change, making it so that the media keys
either perform their media key function, or function as an F-key by
default. The Fn key can be used the access the alternate function at any
time.

With the current linux kernel, the LED doens't change state if you press
the Fn+ESC key combo. However, the media key functionality *does*
change. This is annoying, since the LED will stay on if it was on during
bootup, and it makes it hard to keep track what the current state of the
FnLock is.

This patch calls an ACPI function, that gets the current media key
state, when the Fn+ESC key combo is pressed. Through testing it was
discovered that this function causes the LED to update correctly to
reflect the current state when this function is called.

The relevant ACPI calls are the following:
\_SB_.PCI0.LPC0.EC0_.HKEY.GMKS: Get media key state, returns 0x603 if the FnLock mode is enabled, and 0x602 if it's disabled.
\_SB_.PCI0.LPC0.EC0_.HKEY.SMKS: Set media key state, sending a 1 will enable FnLock mode, and a 0 will disable it.

Relevant discussion:
https://bugzilla.kernel.org/show_bug.cgi?id=207841
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1881015

Signed-off-by: Esteve Varela Colominas <esteve.varela@gmail.com>
Link: https://lore.kernel.org/r/20210315195823.23212-1-esteve.varela@gmail.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 69402758b99c..3b0acaeb20cf 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -4079,13 +4079,19 @@ static bool hotkey_notify_6xxx(const u32 hkey,
 
 	case TP_HKEY_EV_KEY_NUMLOCK:
 	case TP_HKEY_EV_KEY_FN:
-	case TP_HKEY_EV_KEY_FN_ESC:
 		/* key press events, we just ignore them as long as the EC
 		 * is still reporting them in the normal keyboard stream */
 		*send_acpi_ev = false;
 		*ignore_acpi_ev = true;
 		return true;
 
+	case TP_HKEY_EV_KEY_FN_ESC:
+		/* Get the media key status to foce the status LED to update */
+		acpi_evalf(hkey_handle, NULL, "GMKS", "v");
+		*send_acpi_ev = false;
+		*ignore_acpi_ev = true;
+		return true;
+
 	case TP_HKEY_EV_TABLET_CHANGED:
 		tpacpi_input_send_tabletsw();
 		hotkey_tablet_mode_notify_change();
-- 
2.30.2



