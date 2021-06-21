Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F093AEDC8
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhFUQWp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:22:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231766AbhFUQVf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:21:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 581B86135F;
        Mon, 21 Jun 2021 16:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292360;
        bh=16R7qIx4D0jO7rV6BIsTsavAh/ISqKXXZPdv4MpxpqQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fgIjpKSZFmz7NWZKr7vpJ7jkjevfuh9I2DgobmAhtsNtiSFbyNUjv90iYX5Qnq/vH
         EkGHdLPs0th3gmGYAmBzrdUqphRFb/bThK5TSU6546cz/epCtIuOZw0Wx5dXKPgtdi
         Zau9kFR/gmuwfB2cnWe+Xc7GxsntRKRxJDv1LDlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.4 62/90] PCI: Add ACS quirk for Broadcom BCM57414 NIC
Date:   Mon, 21 Jun 2021 18:15:37 +0200
Message-Id: <20210621154906.255852848@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154904.159672728@linuxfoundation.org>
References: <20210621154904.159672728@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>

commit db2f77e2bd99dbd2fb23ddde58f0fae392fe3338 upstream.

The Broadcom BCM57414 NIC may be a multi-function device.  While it does
not advertise an ACS capability, peer-to-peer transactions are not possible
between the individual functions, so it is safe to treat them as fully
isolated.

Add an ACS quirk for this device so the functions can be in independent
IOMMU groups and attached individually to userspace applications using
VFIO.

[bhelgaas: commit log]
Link: https://lore.kernel.org/r/1621645997-16251-1-git-send-email-michael.chan@broadcom.com
Signed-off-by: Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4843,6 +4843,8 @@ static const struct pci_dev_acs_enabled
 	{ PCI_VENDOR_ID_AMPERE, 0xE00A, pci_quirk_xgene_acs },
 	{ PCI_VENDOR_ID_AMPERE, 0xE00B, pci_quirk_xgene_acs },
 	{ PCI_VENDOR_ID_AMPERE, 0xE00C, pci_quirk_xgene_acs },
+	/* Broadcom multi-function device */
+	{ PCI_VENDOR_ID_BROADCOM, 0x16D7, pci_quirk_mf_endpoint_acs },
 	{ PCI_VENDOR_ID_BROADCOM, 0xD714, pci_quirk_brcm_acs },
 	/* Amazon Annapurna Labs */
 	{ PCI_VENDOR_ID_AMAZON_ANNAPURNA_LABS, 0x0031, pci_quirk_al_acs },


