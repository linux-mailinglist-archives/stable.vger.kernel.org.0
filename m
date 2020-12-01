Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747E22C9BF5
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390126AbgLAJNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:13:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:51504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390114AbgLAJNe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:13:34 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4005021D7F;
        Tue,  1 Dec 2020 09:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813998;
        bh=b+wRIPEIEKcvpKepjkq2XcQK8RoYV11dKhX2lhJFhkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2vlGp3GsnlU/l4mGtkVn8LhtaEQSdbV+VKxPewXfI3os74CDoTgQGXSIky+YvL5Yx
         9iOsVOJ9wiU9lSmVKndOm5gwrIEUAb8HMG4wiBycQ9eNSL82hDAZYuavvBifnwG6Kx
         aJCGR8PjQlqBXhU1J35HTUn4YbGSc81XETADs2VI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Berg <bberg@redhat.com>,
        Henrique de Moraes Holschuh <hnh@hmh.eng.br>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 131/152] platform/x86: thinkpad_acpi: Send tablet mode switch at wakeup time
Date:   Tue,  1 Dec 2020 09:54:06 +0100
Message-Id: <20201201084728.973920972@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
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
index eae3579f106f3..017f090a90f68 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -4220,6 +4220,7 @@ static void hotkey_resume(void)
 		pr_err("error while attempting to reset the event firmware interface\n");
 
 	tpacpi_send_radiosw_update();
+	tpacpi_input_send_tabletsw();
 	hotkey_tablet_mode_notify_change();
 	hotkey_wakeup_reason_notify_change();
 	hotkey_wakeup_hotunplug_complete_notify_change();
-- 
2.27.0



