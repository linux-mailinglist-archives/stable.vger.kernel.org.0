Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86162E4157
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439473AbgL1PFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:05:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:45648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439587AbgL1OLT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:11:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3641206E5;
        Mon, 28 Dec 2020 14:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164664;
        bh=6qwQLglfgXiG6hIKLfhI7to85cgl1rUQfGBaxBlH7c4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1mGSnwzZraGv6GlB+dKDnATIyjPYbs/MKgOrSWpl//MNhKg2VpZ7st9RrfnllJVJ
         4XMxWrNHdhvT9Lv2GzJUEZHFeZLJ0mJ9aJpEEgQfnEqxGlO9xeRx7GDVTRUa9z50+u
         j/yjZWIQb4WuUWZeRJE12UEtVWjUDizX1O6CUqnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 255/717] platform/x86: dell-smbios-base: Fix error return code in dell_smbios_init
Date:   Mon, 28 Dec 2020 13:44:13 +0100
Message-Id: <20201228125033.205917753@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 2425ccd30fd78ce35237350fe8baac31dc18bd45 ]

Fix to return the error code -ENODEV when fails to init wmi and
smm.

Fixes: 41e36f2f85af ("platform/x86: dell-smbios: Link all dell-smbios-* modules together")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Reviewed-by: Mario Limonciello <mario.limonciello@dell.com>
Link: https://lore.kernel.org/r/20201125065032.154125-1-miaoqinglang@huawei.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell-smbios-base.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/platform/x86/dell-smbios-base.c b/drivers/platform/x86/dell-smbios-base.c
index 2e2cd565926aa..3a1dbf1994413 100644
--- a/drivers/platform/x86/dell-smbios-base.c
+++ b/drivers/platform/x86/dell-smbios-base.c
@@ -594,6 +594,7 @@ static int __init dell_smbios_init(void)
 	if (wmi && smm) {
 		pr_err("No SMBIOS backends available (wmi: %d, smm: %d)\n",
 			wmi, smm);
+		ret = -ENODEV;
 		goto fail_create_group;
 	}
 
-- 
2.27.0



