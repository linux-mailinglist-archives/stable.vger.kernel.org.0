Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3981238A7F6
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237630AbhETKpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:45:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:44304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237450AbhETKnM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:43:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C580D613BB;
        Thu, 20 May 2021 09:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504598;
        bh=kaakvcBm3EUSwPhuc6Q9/zGlpRcyDZIi9PKl0Y1AXHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X9uVK5gC4sB3qBUIJkvTok/YmeL6GWp3SsK/PiKjVBufHzd692Vx7ahjCbkIyMTtA
         uIlKaN9iWHs+BvkezFWmyTM3qw+OfxBCiVQW+5zwAopvBQvgAo1vEitBV5fc/7hEd/
         fw7N/bVXSm9TVfPmm6cRyyZEwib0nDEB0ocPrxbk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 284/323] ACPI: scan: Fix a memory leak in an error handling path
Date:   Thu, 20 May 2021 11:22:56 +0200
Message-Id: <20210520092129.958784547@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 0c8bd174f0fc131bc9dfab35cd8784f59045da87 ]

If 'acpi_device_set_name()' fails, we must free
'acpi_device_bus_id->bus_id' or there is a (potential) memory leak.

Fixes: eb50aaf960e3 ("ACPI: scan: Use unique number for instance_no")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/scan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 57a213466721..11f07f525b13 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -704,6 +704,7 @@ int acpi_device_add(struct acpi_device *device,
 
 		result = acpi_device_set_name(device, acpi_device_bus_id);
 		if (result) {
+			kfree_const(acpi_device_bus_id->bus_id);
 			kfree(acpi_device_bus_id);
 			goto err_unlock;
 		}
-- 
2.30.2



