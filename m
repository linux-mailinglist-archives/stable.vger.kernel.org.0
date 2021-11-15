Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C36450AE2
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236737AbhKORP2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:15:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:45158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236787AbhKOROS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:14:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E870263245;
        Mon, 15 Nov 2021 17:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996257;
        bh=KtmSilp6BstahOv755BtAIa2ywvDkEIiaPhjuH3g3Yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fmhbWl1RI/spYqDXt9kme8Lt0L8UiFnbRbQht0VTGRIoLLzGucGRMPGOqYd4/7ydW
         86W+OnisvokHcPCHCDXdS0jf4fyhdwntLYG3fiYmEdV1p+/xsk/YRcc7QK5vIYRHrX
         BUVs+I3LLSrCJsUHognihtgGpRLMSdftG9iddoCc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingmar Klein <ingmar_klein@web.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 5.4 074/355] PCI: Mark Atheros QCA6174 to avoid bus reset
Date:   Mon, 15 Nov 2021 17:59:58 +0100
Message-Id: <20211115165316.200982182@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ingmar Klein <ingmar_klein@web.de>

commit e3f4bd3462f6f796594ecc0dda7144ed2d1e5a26 upstream.

When passing the Atheros QCA6174 through to a virtual machine, the VM hangs
at the point where the ath10k driver loads.

Add a quirk to avoid bus resets on this device, which avoids the hang.

[bhelgaas: commit log]
Link: https://lore.kernel.org/r/08982e05-b6e8-5a8d-24ab-da1488ee50a8@web.de
Signed-off-by: Ingmar Klein <ingmar_klein@web.de>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Pali Rohár <pali@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -3584,6 +3584,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_A
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003c, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0033, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0034, quirk_no_bus_reset);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003e, quirk_no_bus_reset);
 
 /*
  * Root port on some Cavium CN8xxx chips do not successfully complete a bus


