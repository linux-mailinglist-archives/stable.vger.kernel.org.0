Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ACCC2471CC
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391001AbgHQSdr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:33:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731016AbgHQQA2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:00:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D1CC20748;
        Mon, 17 Aug 2020 16:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680027;
        bh=oT7jG9BfMuNBbdbJS0ruyTwj9Rgd1ewmiE3dkRyR6Bo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mLFY5EWhJnp0Rqt90+jdPry7I46tDob+PEzNKsE10bhnV1EOP9i8OpEkWUub54KUt
         ld1tZp2hZ2CJBcQzuTnrW4vSonTxJvdlWoAXfyHO4pTCKvTnoMo5UjrXo8yPjf15al
         PmAHEmgd1FOGxzxbNrZzXaXuaSjX8KF8tJXYndis=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Lu Wei <luwei32@huawei.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 024/270] platform/x86: intel-hid: Fix return value check in check_acpi_dev()
Date:   Mon, 17 Aug 2020 17:13:45 +0200
Message-Id: <20200817143756.988406984@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7a506c1d01134..ad1399dcb21f5 100644
--- a/drivers/platform/x86/intel-hid.c
+++ b/drivers/platform/x86/intel-hid.c
@@ -570,7 +570,7 @@ check_acpi_dev(acpi_handle handle, u32 lvl, void *context, void **rv)
 		return AE_OK;
 
 	if (acpi_match_device_ids(dev, ids) == 0)
-		if (acpi_create_platform_device(dev, NULL))
+		if (!IS_ERR_OR_NULL(acpi_create_platform_device(dev, NULL)))
 			dev_info(&dev->dev,
 				 "intel-hid: created platform device\n");
 
-- 
2.25.1



