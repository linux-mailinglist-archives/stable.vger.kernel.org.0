Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A192839BB
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:28:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbgJEP2h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:28:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727407AbgJEP2f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:28:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C493120637;
        Mon,  5 Oct 2020 15:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911714;
        bh=/nu0O0rQcHPIq/kFl2Kqenl8EkZ+ZORv9Gwjr8rotoA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxvW2PlrlgMC3UT710an4kBrgzbCrmAoaG5wUBSSegxV4NNmZGHaprSXFUGzs5yv0
         f+bnmXvPgamwctJbuo7WRxC/JznLuSdWJSGhAzObYaj/LuV6+OhcB8S+hagkWA4j0T
         ermdNPaKGmaHH+Rks5MlzsAFJVha2m3s+iPuinSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        RussianNeuroMancer <russianneuromancer@ya.ru>
Subject: [PATCH 5.4 02/57] mmc: sdhci: Workaround broken command queuing on Intel GLK based IRBIS models
Date:   Mon,  5 Oct 2020 17:26:14 +0200
Message-Id: <20201005142109.917990839@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142109.796046410@linuxfoundation.org>
References: <20201005142109.796046410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit afd7f30886b0b445a4240a99020458a9772f2b89 upstream.

Commit bedf9fc01ff1 ("mmc: sdhci: Workaround broken command queuing on
Intel GLK"), disabled command-queuing on Intel GLK based LENOVO models
because of it being broken due to what is believed to be a bug in
the BIOS.

It seems that the BIOS of some IRBIS models, including the IRBIS NB111
model has the same issue, so disable command queuing there too.

Fixes: bedf9fc01ff1 ("mmc: sdhci: Workaround broken command queuing on Intel GLK")
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=209397
Reported-and-tested-by: RussianNeuroMancer <russianneuromancer@ya.ru>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20200927104821.5676-1-hdegoede@redhat.com
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-pci-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -798,7 +798,8 @@ static int byt_emmc_probe_slot(struct sd
 static bool glk_broken_cqhci(struct sdhci_pci_slot *slot)
 {
 	return slot->chip->pdev->device == PCI_DEVICE_ID_INTEL_GLK_EMMC &&
-	       dmi_match(DMI_BIOS_VENDOR, "LENOVO");
+	       (dmi_match(DMI_BIOS_VENDOR, "LENOVO") ||
+		dmi_match(DMI_SYS_VENDOR, "IRBIS"));
 }
 
 static int glk_emmc_probe_slot(struct sdhci_pci_slot *slot)


