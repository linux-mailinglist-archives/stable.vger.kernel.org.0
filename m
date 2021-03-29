Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94CC34CA8D
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234612AbhC2Ii4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:38:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234880AbhC2Iha (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:37:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D5BB619AD;
        Mon, 29 Mar 2021 08:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617007018;
        bh=L7Fwug4gfuftkbhU3TAzQvA8hI675+RQP9+lRw31ZSo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z1RY5jV6fwaLiD/8ncoDNNrPKCCp/EHeGlDEVciqHJQWO9GmmTMqOSRSCfXlNZh4n
         Wh15NiWgLvMY93FoXx1Yfz2xhpqwjO0XC/VGdse16o2Yv0SJ9h8nTxZNsMhVmZhuN5
         3Dyo0GNecftGzhU30WrKrhpALQZvW/CzkJazi/PY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Divya Bharathi <Divya_Bharathi@dell.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 189/254] platform/x86: dell-wmi-sysman: Fix crash caused by calling kset_unregister twice
Date:   Mon, 29 Mar 2021 09:58:25 +0200
Message-Id: <20210329075639.333705534@linuxfoundation.org>
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

[ Upstream commit d939cd96b9df6dcde1605fab23bbd6307e11f930 ]

On some system the WMI GUIDs used by dell-wmi-sysman are present but there
are no enum type attributes, this causes init_bios_attributes() to return
-ENODEV, after which sysman_init() does a "goto fail_create_group" and then
calls release_attributes_data().

release_attributes_data() calls kset_unregister(wmi_priv.main_dir_kset);
but before this commit it was missing a "wmi_priv.main_dir_kset = NULL;"
statement; and after calling release_attributes_data() the sysman_init()
error handling does this:

        if (wmi_priv.main_dir_kset) {
                kset_unregister(wmi_priv.main_dir_kset);
                wmi_priv.main_dir_kset = NULL;
        }

Which causes a second kset_unregister(wmi_priv.main_dir_kset), leading to
a double-free, which causes a crash.

Add the missing "wmi_priv.main_dir_kset = NULL;" statement to
release_attributes_data() to fix this double-free crash.

Fixes: e8a60aa7404b ("platform/x86: Introduce support for Systems Management Driver over WMI for Dell Systems")
Cc: Divya Bharathi <Divya_Bharathi@dell.com>
Cc: Mario Limonciello <mario.limonciello@dell.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20210321115901.35072-2-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell-wmi-sysman/sysman.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/dell-wmi-sysman/sysman.c b/drivers/platform/x86/dell-wmi-sysman/sysman.c
index cb81010ba1a2..c1997db74cca 100644
--- a/drivers/platform/x86/dell-wmi-sysman/sysman.c
+++ b/drivers/platform/x86/dell-wmi-sysman/sysman.c
@@ -388,6 +388,7 @@ static void release_attributes_data(void)
 	if (wmi_priv.main_dir_kset) {
 		destroy_attribute_objs(wmi_priv.main_dir_kset);
 		kset_unregister(wmi_priv.main_dir_kset);
+		wmi_priv.main_dir_kset = NULL;
 	}
 	mutex_unlock(&wmi_priv.mutex);
 
-- 
2.30.1



