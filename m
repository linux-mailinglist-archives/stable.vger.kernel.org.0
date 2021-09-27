Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD9B7419C10
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236977AbhI0RZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:25:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:35212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236954AbhI0RWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:22:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39FDD61251;
        Mon, 27 Sep 2021 17:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762849;
        bh=EArap/CnkO1XqV9Y0mNUt3kBMxU0ppYGNUg2VYqODys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EzbYoAc7ckyBQlYXvySEeoNJShic1L7PBAUWF6dyH8Amu/5o+CvrLxr9QkbAz6E6W
         SLyLVCI7tMjRLJ50mdNT9hGJmKY0CsOXgF65nwRMFecqHK1si0Vaz2oBjcyCzk9SPi
         0znsakIgIcFP41IOQNPizD0Lr1sm5/bhBBjL+0/Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Perry Yuan <Perry.Yuan@dell.com>, Dell.Client.Kernel@dell.com,
        platform-driver-x86@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <mgross@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 074/162] platform/x86: dell: fix DELL_WMI_PRIVACY dependencies & build error
Date:   Mon, 27 Sep 2021 19:02:00 +0200
Message-Id: <20210927170236.021145945@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 5b72dafaca73b33416c82457ae615e6f2022e901 ]

When DELL_WMI=y, DELL_WMI_PRIVACY=y, and LEDS_TRIGGER_AUDIO=m, there
is a linker error since the LEDS trigger code is built as a loadable
module. This happens because DELL_WMI_PRIVACY is a bool that depends
on a tristate (LEDS_TRIGGER_AUDIO=m), which can be dangerous.

ld: drivers/platform/x86/dell/dell-wmi-privacy.o: in function `dell_privacy_wmi_probe':
dell-wmi-privacy.c:(.text+0x3df): undefined reference to `ledtrig_audio_get'

Fixes: 8af9fa37b8a3 ("platform/x86: dell-privacy: Add support for Dell hardware privacy")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Perry Yuan <Perry.Yuan@dell.com>
Cc: Dell.Client.Kernel@dell.com
Cc: platform-driver-x86@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Mark Gross <mgross@linux.intel.com>
Link: https://lore.kernel.org/r/20210918044829.19222-1-rdunlap@infradead.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/Kconfig | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell/Kconfig b/drivers/platform/x86/dell/Kconfig
index 9e7314d90bea..1e3da9700005 100644
--- a/drivers/platform/x86/dell/Kconfig
+++ b/drivers/platform/x86/dell/Kconfig
@@ -166,8 +166,7 @@ config DELL_WMI
 
 config DELL_WMI_PRIVACY
 	bool "Dell WMI Hardware Privacy Support"
-	depends on DELL_WMI
-	depends on LEDS_TRIGGER_AUDIO
+	depends on LEDS_TRIGGER_AUDIO = y || DELL_WMI = LEDS_TRIGGER_AUDIO
 	help
 	  This option adds integration with the "Dell Hardware Privacy"
 	  feature of Dell laptops to the dell-wmi driver.
-- 
2.33.0



