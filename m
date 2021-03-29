Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3166B34CAD7
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhC2IkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:40:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:34080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234639AbhC2IjU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:39:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6923A60C3D;
        Mon, 29 Mar 2021 08:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007149;
        bh=JxVYiWqHneHdJDkkpquqAtgbGEcks6zWVo/NuiU6eV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r5vMOmuVwbcCClkaiwXKTjgDCVKpVxHKOFgTHjP91+9qTjYyyymj+6MXeQ+9+pFIF
         cXTnm2oUbwbA7FPq70x9Fu7qZ25g79N7W1MCfLNJ4pUyPqxWRz98ycNPuoQKOpnjTZ
         UE64y3PRwJZzSFb1TRR1zuT59xZGRb3ZRd6woKM4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Divya Bharathi <Divya_Bharathi@dell.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Alexander Naumann <alexandernaumann@gmx.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 194/254] platform/x86: dell-wmi-sysman: Make sysman_init() return -ENODEV of the interfaces are not found
Date:   Mon, 29 Mar 2021 09:58:30 +0200
Message-Id: <20210329075639.484312106@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 32418dd58c957f8fef25b97450d00275967604f1 ]

When either the attributes or the password interface is not found, then
unregister the 2 wmi drivers again and return -ENODEV from sysman_init().

Fixes: e8a60aa7404b ("platform/x86: Introduce support for Systems Management Driver over WMI for Dell Systems")
Cc: Divya Bharathi <Divya_Bharathi@dell.com>
Cc: Mario Limonciello <mario.limonciello@dell.com>
Reported-by: Alexander Naumann <alexandernaumann@gmx.de>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210321115901.35072-7-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell-wmi-sysman/sysman.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/dell-wmi-sysman/sysman.c b/drivers/platform/x86/dell-wmi-sysman/sysman.c
index 99dc2f3bdf49..5dd9b29d939c 100644
--- a/drivers/platform/x86/dell-wmi-sysman/sysman.c
+++ b/drivers/platform/x86/dell-wmi-sysman/sysman.c
@@ -506,15 +506,17 @@ static int __init sysman_init(void)
 	}
 
 	ret = init_bios_attr_set_interface();
-	if (ret || !wmi_priv.bios_attr_wdev) {
-		pr_debug("failed to initialize set interface\n");
+	if (ret)
 		return ret;
-	}
 
 	ret = init_bios_attr_pass_interface();
-	if (ret || !wmi_priv.password_attr_wdev) {
-		pr_debug("failed to initialize pass interface\n");
+	if (ret)
 		goto err_exit_bios_attr_set_interface;
+
+	if (!wmi_priv.bios_attr_wdev || !wmi_priv.password_attr_wdev) {
+		pr_debug("failed to find set or pass interface\n");
+		ret = -ENODEV;
+		goto err_exit_bios_attr_pass_interface;
 	}
 
 	ret = class_register(&firmware_attributes_class);
-- 
2.30.1



