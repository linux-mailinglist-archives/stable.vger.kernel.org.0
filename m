Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70B0138A54D
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235423AbhETKPn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:15:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235907AbhETKMz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:12:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2FA661978;
        Thu, 20 May 2021 09:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503845;
        bh=Lpq4Yp0P9usPQ2Fhgl0JwM+bC+1n/ZpVwxoqJAW/Wlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Otjq2l45alE44FET+isktsrnZli91UvobGGQi+7YvA5Y1kZxzfGR3xMNQCvV42Ti+
         RXFNzXlLnFervvbonQ2VByByhy2FsSgPGn76JhhYl1YgMYdoLAj/7dT2QPovXgrr8r
         uxXFMZYUYhVhKsOlScv/6XQl98HanlH8giRT9EdM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 371/425] ACPI: scan: Fix a memory leak in an error handling path
Date:   Thu, 20 May 2021 11:22:20 +0200
Message-Id: <20210520092143.594590376@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index d3c551bdc2da..1e7e2c438acf 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -705,6 +705,7 @@ int acpi_device_add(struct acpi_device *device,
 
 		result = acpi_device_set_name(device, acpi_device_bus_id);
 		if (result) {
+			kfree_const(acpi_device_bus_id->bus_id);
 			kfree(acpi_device_bus_id);
 			goto err_unlock;
 		}
-- 
2.30.2



