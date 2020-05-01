Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8679E1C1613
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730551AbgEANjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:39:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731164AbgEANjO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:39:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95CC420757;
        Fri,  1 May 2020 13:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340354;
        bh=0QOOZyDBsNIBBaxOKBFDj9IiySFeZjBr3MHLtaSCaoU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GotZwUSXHN0jPdGkjnoKpBbJVgCx/7ad6Q8kZ342Iuuv4Dtc2i8H2QdKQyNzMH5kp
         g60u4wSHr14PwQuuDkQmtiqH61XwPtBXEyamJaXUX95mD6vdU4tKxrwAk37ppQYRQK
         CyNPttBYZv5W+iVCvcJ9uKbtOaWnEaIyQ9bhPRqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raymond Pang <RaymondPang-oc@zhaoxin.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.4 31/83] PCI: Add ACS quirk for Zhaoxin multi-function devices
Date:   Fri,  1 May 2020 15:23:10 +0200
Message-Id: <20200501131531.585369185@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131524.004332640@linuxfoundation.org>
References: <20200501131524.004332640@linuxfoundation.org>
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
@@ -4759,6 +4759,10 @@ static const struct pci_dev_acs_enabled
 	{ PCI_VENDOR_ID_BROADCOM, 0xD714, pci_quirk_brcm_acs },
 	/* Amazon Annapurna Labs */
 	{ PCI_VENDOR_ID_AMAZON_ANNAPURNA_LABS, 0x0031, pci_quirk_al_acs },
+	/* Zhaoxin multi-function devices */
+	{ PCI_VENDOR_ID_ZHAOXIN, 0x3038, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_ZHAOXIN, 0x3104, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_ZHAOXIN, 0x9083, pci_quirk_mf_endpoint_acs },
 	{ 0 }
 };
 


