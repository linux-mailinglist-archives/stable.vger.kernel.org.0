Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720DE2C9D80
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390754AbgLAJY0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:24:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388367AbgLAJGN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:06:13 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E31F92223F;
        Tue,  1 Dec 2020 09:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813532;
        bh=lqZRJVJAtiv01l+CYjt2C3UksiMzZFKzjkY40VVyF7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOvpiWR7UNQ9YU0A4/IiApat4iA6Zhn/Z8xuMIsJAxxLv85eC6CmuBIokZeiuAPpr
         c+bxeECDp/8kZohmXaFuGvEmM5pXj3baP0EKfzWWGr6Kv4e0ltM66NHbznCRm5Jvx9
         fQwDo6i9Unif0CVTDHlDLdb1G4ozwLJ7wtM8KOiE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Berg <bberg@redhat.com>,
        Henrique de Moraes Holschuh <hnh@hmh.eng.br>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 72/98] platform/x86: thinkpad_acpi: Send tablet mode switch at wakeup time
Date:   Tue,  1 Dec 2020 09:53:49 +0100
Message-Id: <20201201084658.600170370@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084652.827177826@linuxfoundation.org>
References: <20201201084652.827177826@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Berg <bberg@redhat.com>

[ Upstream commit e40cc1b476d60f22628741e53cf3446a29e6e6b9 ]

The lid state may change while the machine is suspended. As such, we may
need to re-check the state at wake-up time (at least when waking up from
hibernation).
Add the appropriate call to the resume handler in order to sync the
SW_TABLET_MODE switch state with the hardware state.

Fixes: dda3ec0aa631 ("platform/x86: thinkpad_acpi: Implement tablet mode using GMMS method")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=210269
Signed-off-by: Benjamin Berg <bberg@redhat.com>
Acked-by: Henrique de Moraes Holschuh <hnh@hmh.eng.br>
Link: https://lore.kernel.org/r/20201123132157.866303-1-benjamin@sipsolutions.net
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index abcb336a515a1..5081048f2356e 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -4238,6 +4238,7 @@ static void hotkey_resume(void)
 		pr_err("error while attempting to reset the event firmware interface\n");
 
 	tpacpi_send_radiosw_update();
+	tpacpi_input_send_tabletsw();
 	hotkey_tablet_mode_notify_change();
 	hotkey_wakeup_reason_notify_change();
 	hotkey_wakeup_hotunplug_complete_notify_change();
-- 
2.27.0



