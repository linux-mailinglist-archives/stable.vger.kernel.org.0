Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D934383843
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:51:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244640AbhEQPvB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:51:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243418AbhEQPsK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:48:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE1A86195A;
        Mon, 17 May 2021 14:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262690;
        bh=vjRzk8bYKbakThoVaMc//KZ4NHSVmY1DMv1cBk4aWCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1BHtHn7PfvJ+MJnkSjCUcPrVCH2zJ+fyo0fFck0LDMeNN2sGs/VG7YnHpcSRxePug
         4awH5m70hkGWWoeSdZw6V6emSpwJxD2zAO4Dald2RC8XBYNeFx+wWUKbEAK1bAitzI
         wzqHDK4FH7Fk0bgED3dxyFWwlSdj1czoAt//3tMc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 229/289] ACPI: scan: Fix a memory leak in an error handling path
Date:   Mon, 17 May 2021 16:02:34 +0200
Message-Id: <20210517140312.872162859@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
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
index b47f14ac75ae..de0533bd4e08 100644
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



