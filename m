Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A3A2A56D4
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732765AbgKCVbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:31:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731750AbgKCU5p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:57:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BAE32053B;
        Tue,  3 Nov 2020 20:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437064;
        bh=OF1UzrEkpvQY/H024MBR+tM08Hv99WeM2oKPJDlgaAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wQWPJsbZzHMmSV3XXyVQV50GHj3X2LimmqASXpTCu8EMgwrqSbLIA7qEuGopNauGq
         Xkd/m21wVYD5EszOrFlQk0awr4YU3AmOTsuphfrL14jAr46BiXfS7j2laZBDcq3H1w
         R+qgWgcF4pPESwsBUJ6w24W1Dz4jb0hVUyGvQwpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aaron Zakhrov <aaron.zakhrov@gmail.com>,
        Michal Rostecki <mrostecki@suse.com>,
        Shai Coleman <git@shaicoleman.com>,
        Lukas Wunner <lukas@wunner.de>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Arthur Borsboom <arthurborsboom@gmail.com>,
        matoro <matoro@airmail.cc>
Subject: [PATCH 5.4 114/214] PCI/ACPI: Whitelist hotplug ports for D3 if power managed by ACPI
Date:   Tue,  3 Nov 2020 21:36:02 +0100
Message-Id: <20201103203301.578517893@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit c6e331312ebfb52b7186e5d82d517d68b4d2f2d8 upstream.

Recent laptops with dual AMD GPUs fail to suspend the discrete GPU, thus
causing lockups on system sleep and high power consumption at runtime.
The discrete GPU would normally be suspended to D3cold by turning off
ACPI _PR3 Power Resources of the Root Port above the GPU.

However on affected systems, the Root Port is hotplug-capable and
pci_bridge_d3_possible() only allows hotplug ports to go to D3 if they
belong to a Thunderbolt device or if the Root Port possesses a
"HotPlugSupportInD3" ACPI property.  Neither is the case on affected
laptops.  The reason for whitelisting only specific, known to work
hotplug ports for D3 is that there have been reports of SkyLake Xeon-SP
systems raising Hardware Error NMIs upon suspending their hotplug ports:
https://lore.kernel.org/linux-pci/20170503180426.GA4058@otc-nc-03/

But if a hotplug port is power manageable by ACPI (as can be detected
through presence of Power Resources and corresponding _PS0 and _PS3
methods) then it ought to be safe to suspend it to D3.  To this end,
amend acpi_pci_bridge_d3() to whitelist such ports for D3.

Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1222
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1252
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1304
Reported-and-tested-by: Arthur Borsboom <arthurborsboom@gmail.com>
Reported-and-tested-by: matoro <matoro@airmail.cc>
Reported-by: Aaron Zakhrov <aaron.zakhrov@gmail.com>
Reported-by: Michal Rostecki <mrostecki@suse.com>
Reported-by: Shai Coleman <git@shaicoleman.com>
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Cc: 5.4+ <stable@vger.kernel.org> # 5.4+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pci-acpi.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/pci/pci-acpi.c
+++ b/drivers/pci/pci-acpi.c
@@ -944,6 +944,16 @@ static bool acpi_pci_bridge_d3(struct pc
 	if (!dev->is_hotplug_bridge)
 		return false;
 
+	/* Assume D3 support if the bridge is power-manageable by ACPI. */
+	adev = ACPI_COMPANION(&dev->dev);
+	if (!adev && !pci_dev_is_added(dev)) {
+		adev = acpi_pci_find_companion(&dev->dev);
+		ACPI_COMPANION_SET(&dev->dev, adev);
+	}
+
+	if (adev && acpi_device_power_manageable(adev))
+		return true;
+
 	/*
 	 * Look for a special _DSD property for the root port and if it
 	 * is set we know the hierarchy behind it supports D3 just fine.


