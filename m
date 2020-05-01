Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D29221C1665
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731150AbgEANrt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:47:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731607AbgEANnN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:43:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8315208DB;
        Fri,  1 May 2020 13:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340593;
        bh=BUGZ/+RII62MViYkx/XiviL/cx9e/eDbNIIw0pTyWgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fSPeU1GWApFg2F4C1txieFaDGvG8kCnkBg7i+yYn5wj2O1myZdonsRDJ4iSRwN+Zs
         y6qOoZ5G7An7PPkcP3m2zJNCiqQiEEwHLGPSUq/+c+ErvO9C0RDElGFEdrpNNOjeP5
         a6ntBdlRyKR0XA1WLjsmsS4GFs4t5HDvE+F55ohE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raymond Pang <RaymondPang-oc@zhaoxin.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.6 045/106] PCI: Add ACS quirk for Zhaoxin multi-function devices
Date:   Fri,  1 May 2020 15:23:18 +0200
Message-Id: <20200501131549.104771513@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raymond Pang <RaymondPang-oc@zhaoxin.com>

commit 0325837c51cb7c9a5bd3e354ac0c0cda0667d50e upstream.

Some Zhaoxin endpoints are implemented as multi-function devices without an
ACS capability, but they actually don't support peer-to-peer transactions.
Add ACS quirks to declare DMA isolation.

Link: https://lore.kernel.org/r/20200327091148.5190-3-RaymondPang-oc@zhaoxin.com
Signed-off-by: Raymond Pang <RaymondPang-oc@zhaoxin.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4767,6 +4767,10 @@ static const struct pci_dev_acs_enabled
 	{ PCI_VENDOR_ID_BROADCOM, 0xD714, pci_quirk_brcm_acs },
 	/* Amazon Annapurna Labs */
 	{ PCI_VENDOR_ID_AMAZON_ANNAPURNA_LABS, 0x0031, pci_quirk_al_acs },
+	/* Zhaoxin multi-function devices */
+	{ PCI_VENDOR_ID_ZHAOXIN, 0x3038, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_ZHAOXIN, 0x3104, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_ZHAOXIN, 0x9083, pci_quirk_mf_endpoint_acs },
 	{ 0 }
 };
 


