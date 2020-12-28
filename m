Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757502E65A1
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393333AbgL1QD0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:03:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:57558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390082AbgL1N3U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:29:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3AC712072C;
        Mon, 28 Dec 2020 13:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162144;
        bh=q3msN9zDzbMfCKfuiSODGOUC58Tq2Jao2COOmaSZsWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ukpao/vGhdz0aF1Btr5c+cWiOvv+b4YxqVNrHKaDJiwCgNqwwy4lZ5j2XPbmrAbtV
         QDZEq3G3l8E/w2u3Tf5ncG/lTr591RwFuFdbCA5I3o+9GxU8UP3qcPAdZAqnrcUJlc
         mvdnLfex/7N9YzP353mHq3OK+Wjr3W19mC770COk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 185/346] platform/x86: dell-smbios-base: Fix error return code in dell_smbios_init
Date:   Mon, 28 Dec 2020 13:48:24 +0100
Message-Id: <20201228124928.729409882@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
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
index 0537d44d45a6e..9e9fc51557892 100644
--- a/drivers/platform/x86/dell-smbios-base.c
+++ b/drivers/platform/x86/dell-smbios-base.c
@@ -597,6 +597,7 @@ static int __init dell_smbios_init(void)
 	if (wmi && smm) {
 		pr_err("No SMBIOS backends available (wmi: %d, smm: %d)\n",
 			wmi, smm);
+		ret = -ENODEV;
 		goto fail_create_group;
 	}
 
-- 
2.27.0



