Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CDC45BCA6
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:29:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242737AbhKXMbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:31:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:49554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343940AbhKXMaR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:30:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B5B16128A;
        Wed, 24 Nov 2021 12:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756306;
        bh=kGwhXI24Z1/O4TZFZLiCW7mKgYfnLyCqPYZBWjOjpgo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cBUICKltur0AhQHjyIELnmGqS2wPEU6wAaRNs8/FCpqmV2zFaxFTIoVi9Bd8z8+Wa
         sOyT3cVVQEYCSj9Snoefa5GBpRmf3utdnuQbXsz93IKctx2D1JL3O3C/qp+i0t7FxE
         33/LvBThDfcCEc42007ru1sEk+Uv508R9I9NamKQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingmar Klein <ingmar_klein@web.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Subject: [PATCH 4.14 041/251] PCI: Mark Atheros QCA6174 to avoid bus reset
Date:   Wed, 24 Nov 2021 12:54:43 +0100
Message-Id: <20211124115711.667874318@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
@@ -3414,6 +3414,7 @@ DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_A
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003c, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0033, quirk_no_bus_reset);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0034, quirk_no_bus_reset);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x003e, quirk_no_bus_reset);
 
 /*
  * Some TI KeyStone C667X devices do not support bus/hot reset.  The PCIESS


