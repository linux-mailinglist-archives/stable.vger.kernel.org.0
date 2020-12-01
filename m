Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59A832C9AE9
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387509AbgLAJCS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:02:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387994AbgLAJCQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:02:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2197D22252;
        Tue,  1 Dec 2020 09:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813289;
        bh=esfKVzGDfYzkj7L+9e4oZSnTVgydKBnm7+UNunbg2+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=igYZ5TOXVgc5wbQJgHIz9KZ8owyHGACpb7VHYMW+hHd/aLCKfaRS5I3WNHULX9tGJ
         ZdeZAIkupLidtVC8SMA8oxY7NPI4Zt5YdhbFMhgJQBQxwQOUISLHEGrvcdceNDxjwW
         MAU5FZDLfo0PRScHO16DBecrYp9cH77DHL65uMCU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Berg <bberg@redhat.com>,
        Henrique de Moraes Holschuh <hnh@hmh.eng.br>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 46/57] platform/x86: thinkpad_acpi: Send tablet mode switch at wakeup time
Date:   Tue,  1 Dec 2020 09:53:51 +0100
Message-Id: <20201201084651.367647472@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084647.751612010@linuxfoundation.org>
References: <20201201084647.751612010@linuxfoundation.org>
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
index 98bd8213b0378..8cc01857bc5c0 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -4251,6 +4251,7 @@ static void hotkey_resume(void)
 		pr_err("error while attempting to reset the event firmware interface\n");
 
 	tpacpi_send_radiosw_update();
+	tpacpi_input_send_tabletsw();
 	hotkey_tablet_mode_notify_change();
 	hotkey_wakeup_reason_notify_change();
 	hotkey_wakeup_hotunplug_complete_notify_change();
-- 
2.27.0



