Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 261B838EEE3
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234683AbhEXPzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:55:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:39954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234860AbhEXPyr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:54:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A9D5617ED;
        Mon, 24 May 2021 15:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870795;
        bh=lVF9Ze/S06Eg1A+PMOGSpVDkwzSF0NNTQ75Reo2VATk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0OK8IHh/8EkTiN/Ea0hqcbp0kef6MXZ8OWdjR/o05oP/YwGeTkM4Wx8irL+LsjAk9
         WjoGTjqBNRm3q6drJ3CWQ28LigHtKyUCEfQOllwwx4OlyNU1yeyI+DCdG2+poPLYf1
         Y7dVd+c5MNMK08Rrvz556OGIW08h0bsj/6Tex3Y4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@outlook.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/104] platform/x86: dell-smbios-wmi: Fix oops on rmmod dell_smbios
Date:   Mon, 24 May 2021 17:25:15 +0200
Message-Id: <20210524152333.495739224@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152332.844251980@linuxfoundation.org>
References: <20210524152332.844251980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 3a53587423d25c87af4b4126a806a0575104b45e ]

init_dell_smbios_wmi() only registers the dell_smbios_wmi_driver on systems
where the Dell WMI interface is supported. While exit_dell_smbios_wmi()
unregisters it unconditionally, this leads to the following oops:

[  175.722921] ------------[ cut here ]------------
[  175.722925] Unexpected driver unregister!
[  175.722939] WARNING: CPU: 1 PID: 3630 at drivers/base/driver.c:194 driver_unregister+0x38/0x40
...
[  175.723089] Call Trace:
[  175.723094]  cleanup_module+0x5/0xedd [dell_smbios]
...
[  175.723148] ---[ end trace 064c34e1ad49509d ]---

Make the unregister happen on the same condition the register happens
to fix this.

Cc: Mario Limonciello <mario.limonciello@outlook.com>
Fixes: 1a258e670434 ("platform/x86: dell-smbios-wmi: Add new WMI dispatcher driver")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Mario Limonciello <mario.limonciello@outlook.com>
Reviewed-by: Mark Gross <mgross@linux.intel.com>
Link: https://lore.kernel.org/r/20210518125027.21824-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell-smbios-wmi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/dell-smbios-wmi.c b/drivers/platform/x86/dell-smbios-wmi.c
index 27a298b7c541..c97bd4a45242 100644
--- a/drivers/platform/x86/dell-smbios-wmi.c
+++ b/drivers/platform/x86/dell-smbios-wmi.c
@@ -271,7 +271,8 @@ int init_dell_smbios_wmi(void)
 
 void exit_dell_smbios_wmi(void)
 {
-	wmi_driver_unregister(&dell_smbios_wmi_driver);
+	if (wmi_supported)
+		wmi_driver_unregister(&dell_smbios_wmi_driver);
 }
 
 MODULE_DEVICE_TABLE(wmi, dell_smbios_wmi_id_table);
-- 
2.30.2



