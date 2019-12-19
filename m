Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B0B126D27
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:09:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbfLSSlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:41:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:60238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727764AbfLSSlP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:41:15 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B7CB206D7;
        Thu, 19 Dec 2019 18:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780875;
        bh=2wwxcX9JNVn3hALx+KjwATnrP0ljQZEHAVh7JGVs7ZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/kocsN7/7JWyJSs4bl52KKjNfPDaj13fEysUz+9fH6n1PaUekKd0XguNO+YJ0pdv
         WCJK5J+5W7HQLyqvjRxQG2Yfz/IIxhVmYkjduAWRBVRG5dBwryYYMMocDRnctxcv34
         9Yo1O+v67TMYlu0qAW0jZEFc874rfhAshi1kkc7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 4.4 115/162] ACPI: bus: Fix NULL pointer check in acpi_bus_get_private_data()
Date:   Thu, 19 Dec 2019 19:33:43 +0100
Message-Id: <20191219183214.761567085@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>

commit 627ead724eff33673597216f5020b72118827de4 upstream.

kmemleak reported backtrace:
    [<bbee0454>] kmem_cache_alloc_trace+0x128/0x260
    [<6677f215>] i2c_acpi_install_space_handler+0x4b/0xe0
    [<1180f4fc>] i2c_register_adapter+0x186/0x400
    [<6083baf7>] i2c_add_adapter+0x4e/0x70
    [<a3ddf966>] intel_gmbus_setup+0x1a2/0x2c0 [i915]
    [<84cb69ae>] i915_driver_probe+0x8d8/0x13a0 [i915]
    [<81911d4b>] i915_pci_probe+0x48/0x160 [i915]
    [<4b159af1>] pci_device_probe+0xdc/0x160
    [<b3c64704>] really_probe+0x1ee/0x450
    [<bc029f5a>] driver_probe_device+0x142/0x1b0
    [<d8829d20>] device_driver_attach+0x49/0x50
    [<de71f045>] __driver_attach+0xc9/0x150
    [<df33ac83>] bus_for_each_dev+0x56/0xa0
    [<80089bba>] driver_attach+0x19/0x20
    [<cc73f583>] bus_add_driver+0x177/0x220
    [<7b29d8c7>] driver_register+0x56/0xf0

In i2c_acpi_remove_space_handler(), a leak occurs whenever the
"data" parameter is initialized to 0 before being passed to
acpi_bus_get_private_data().

This is because the NULL pointer check in acpi_bus_get_private_data()
(condition->if(!*data)) returns EINVAL and, in consequence, memory is
never freed in i2c_acpi_remove_space_handler().

Fix the NULL pointer check in acpi_bus_get_private_data() to follow
the analogous check in acpi_get_data_full().

Signed-off-by: Vamshi K Sthambamkadi <vamshi.k.sthambamkadi@gmail.com>
[ rjw: Subject & changelog ]
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -154,7 +154,7 @@ int acpi_bus_get_private_data(acpi_handl
 {
 	acpi_status status;
 
-	if (!*data)
+	if (!data)
 		return -EINVAL;
 
 	status = acpi_get_data(handle, acpi_bus_private_data_handler, data);


