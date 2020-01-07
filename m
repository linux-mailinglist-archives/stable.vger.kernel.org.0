Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8507F13333F
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728798AbgAGVGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:06:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:54142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729163AbgAGVGD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:06:03 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 99F362077B;
        Tue,  7 Jan 2020 21:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431163;
        bh=3YajkWlGnlVSLlsI8KWCB4f2UnTJCeARHNTYQIc7B3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Va9ksbbgY0PnNbBSNGCcuTIsO3HAOqUiswXW8kn0HcTf4s4D0/rlHgLPm1aee1DQo
         Nq6Al3g0eEhaHWy5Cj5FB6AdJKoa6fKHJqgXURRXaBB8NVdCxwourAbyDmgqUZ4zy3
         oik5Xk+aLSj1b9Wbsoh+RgdWLdIMNitM5NfFwkP8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 060/115] ata: libahci_platform: Export again ahci_platform_<en/dis>able_phys()
Date:   Tue,  7 Jan 2020 21:54:30 +0100
Message-Id: <20200107205303.221949031@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205240.283674026@linuxfoundation.org>
References: <20200107205240.283674026@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit 84b032dbfdf1c139cd2b864e43959510646975f8 upstream.

This reverts commit 6bb86fefa086faba7b60bb452300b76a47cde1a5
("libahci_platform: Staticize ahci_platform_<en/dis>able_phys()") we are
going to need ahci_platform_{enable,disable}_phys() in a subsequent
commit for ahci_brcm.c in order to properly control the PHY
initialization order.

Also make sure the function prototypes are declared in
include/linux/ahci_platform.h as a result.

Cc: stable@vger.kernel.org
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/libahci_platform.c |    6 ++++--
 include/linux/ahci_platform.h  |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -47,7 +47,7 @@ EXPORT_SYMBOL_GPL(ahci_platform_ops);
  * RETURNS:
  * 0 on success otherwise a negative error code
  */
-static int ahci_platform_enable_phys(struct ahci_host_priv *hpriv)
+int ahci_platform_enable_phys(struct ahci_host_priv *hpriv)
 {
 	int rc, i;
 
@@ -72,6 +72,7 @@ disable_phys:
 	}
 	return rc;
 }
+EXPORT_SYMBOL_GPL(ahci_platform_enable_phys);
 
 /**
  * ahci_platform_disable_phys - Disable PHYs
@@ -79,7 +80,7 @@ disable_phys:
  *
  * This function disables all PHYs found in hpriv->phys.
  */
-static void ahci_platform_disable_phys(struct ahci_host_priv *hpriv)
+void ahci_platform_disable_phys(struct ahci_host_priv *hpriv)
 {
 	int i;
 
@@ -88,6 +89,7 @@ static void ahci_platform_disable_phys(s
 		phy_exit(hpriv->phys[i]);
 	}
 }
+EXPORT_SYMBOL_GPL(ahci_platform_disable_phys);
 
 /**
  * ahci_platform_enable_clks - Enable platform clocks
--- a/include/linux/ahci_platform.h
+++ b/include/linux/ahci_platform.h
@@ -23,6 +23,8 @@ struct ahci_host_priv;
 struct platform_device;
 struct scsi_host_template;
 
+int ahci_platform_enable_phys(struct ahci_host_priv *hpriv);
+void ahci_platform_disable_phys(struct ahci_host_priv *hpriv);
 int ahci_platform_enable_clks(struct ahci_host_priv *hpriv);
 void ahci_platform_disable_clks(struct ahci_host_priv *hpriv);
 int ahci_platform_enable_regulators(struct ahci_host_priv *hpriv);


