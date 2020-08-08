Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A0623FA48
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbgHHXlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728843AbgHHXkb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:40:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C85212053B;
        Sat,  8 Aug 2020 23:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596930031;
        bh=LthndcixR4U/nU7TTeLj3tEDBebmVUh9b9bTx4WDgoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ERIL3EIRVy1Q80DVGEZKQNYNncKOmslNzM/Xp0hSwHX29zRxi9EEacoiBFoAS7+i/
         Ik8zOSvuWTsuoBdqh6NcR3tkgHIa6XpQs16LkgNqS+fIFCNEyRlxxtQ8LZ4GgRhrZz
         NrJlnCfzAm5itnY9Mgvph7cfdVy5iOQ3Uop/dNOE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lu Wei <luwei32@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 10/14] platform/x86: intel-hid: Fix return value check in check_acpi_dev()
Date:   Sat,  8 Aug 2020 19:40:09 -0400
Message-Id: <20200808234013.3619541-10-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808234013.3619541-1-sashal@kernel.org>
References: <20200808234013.3619541-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Wei <luwei32@huawei.com>

[ Upstream commit 71fbe886ce6dd0be17f20aded9c63fe58edd2806 ]

In the function check_acpi_dev(), if it fails to create
platform device, the return value is ERR_PTR() or NULL.
Thus it must use IS_ERR_OR_NULL() to check return value.

Fixes: ecc83e52b28c ("intel-hid: new hid event driver for hotkeys")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Lu Wei <luwei32@huawei.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel-hid.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel-hid.c b/drivers/platform/x86/intel-hid.c
index e34fd70b67afe..3add7b3f9658b 100644
--- a/drivers/platform/x86/intel-hid.c
+++ b/drivers/platform/x86/intel-hid.c
@@ -366,7 +366,7 @@ check_acpi_dev(acpi_handle handle, u32 lvl, void *context, void **rv)
 		return AE_OK;
 
 	if (acpi_match_device_ids(dev, ids) == 0)
-		if (acpi_create_platform_device(dev, NULL))
+		if (!IS_ERR_OR_NULL(acpi_create_platform_device(dev, NULL)))
 			dev_info(&dev->dev,
 				 "intel-hid: created platform device\n");
 
-- 
2.25.1

