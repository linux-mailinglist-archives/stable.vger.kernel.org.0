Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81BE34DB38
	for <lists+stable@lfdr.de>; Tue, 30 Mar 2021 00:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbhC2W0n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 18:26:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230444AbhC2WYW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 18:24:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13286619BD;
        Mon, 29 Mar 2021 22:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056617;
        bh=IX7JtpBmyJERSohCz5wxHSAX+bY9srr/PlNSCQrPYgQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p/nQoSgmFAQ4Mxaz+Z/hKiY5ARCxzmfAAfDauh7b1VXH244xGWG3QjVVEQoPA78OU
         g6Q7gqAD+KBuI/uEsCJvn6WcQxXUSaEQPTyn2ZNgiNvGxuiLk+k/zp7nthhZrkcaAu
         g5+wVWny9RetAoMcHOqI5awjbVUgv0E91u08x5XkHlsvPGXPiFPRV7mU2pnAvsHEvS
         DzQx1/ycMKoGzViQXuYgTt9fIJUggByJdGN2Rjr3FaCZDxhW8y2Vt0JDXWJDaT3iA2
         BRZkg19rAsYqI/brNOPG8pT6fumCLzPknAu/9f501kJxw9QEwLrfn7QsM8F6U/99NP
         HE+bFcaECMM3g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Esteve Varela Colominas <esteve.varela@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 09/15] platform/x86: thinkpad_acpi: Allow the FnLock LED to change state
Date:   Mon, 29 Mar 2021 18:23:20 -0400
Message-Id: <20210329222327.2383533-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222327.2383533-1-sashal@kernel.org>
References: <20210329222327.2383533-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index a6e69f2495d2..559698640fe2 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -4102,13 +4102,19 @@ static bool hotkey_notify_6xxx(const u32 hkey,
 
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
2.30.1

