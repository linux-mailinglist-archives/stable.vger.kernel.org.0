Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0440411DB5
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349372AbhITRW4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:22:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:49370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347114AbhITRU4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:20:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BE02961407;
        Mon, 20 Sep 2021 17:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157242;
        bh=ao+MrJuma75R7yYObbZCRQsgcvg414LhneotMhB1wFw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z9KwkX/k3BnoV/VDshoxK07Tuw9arxmNBH9RAIeyBr8yy/B1hl7DlJp4aWYzxnSum
         7E6z6ykhESqNMUtflqmWZ9xuV0MiUDfMzZ1hDDT6zB/9+hGqYGpSazNTsSx0yATZ4F
         y2NC0ecaQru1VJUpPouXpUCXlDoLoD8YaFYGrIb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 4.14 119/217] PCI: aardvark: Increase polling delay to 1.5s while waiting for PIO response
Date:   Mon, 20 Sep 2021 18:42:20 +0200
Message-Id: <20210920163928.693768716@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

commit 02bcec3ea5591720114f586960490b04b093a09e upstream.

Measurements in different conditions showed that aardvark hardware PIO
response can take up to 1.44s. Increase wait timeout from 1ms to 1.5s to
ensure that we do not miss responses from hardware. After 1.44s hardware
returns errors (e.g. Completer abort).

The previous two patches fixed checking for PIO status, so now we can use
it to also catch errors which are reported by hardware after 1.44s.

After applying this patch, kernel can detect and print PIO errors to dmesg:

    [    6.879999] advk-pcie d0070000.pcie: Non-posted PIO Response Status: CA, 0xe00 @ 0x100004
    [    6.896436] advk-pcie d0070000.pcie: Posted PIO Response Status: COMP_ERR, 0x804 @ 0x100004
    [    6.913049] advk-pcie d0070000.pcie: Posted PIO Response Status: COMP_ERR, 0x804 @ 0x100010
    [    6.929663] advk-pcie d0070000.pcie: Non-posted PIO Response Status: CA, 0xe00 @ 0x100010
    [    6.953558] advk-pcie d0070000.pcie: Posted PIO Response Status: COMP_ERR, 0x804 @ 0x100014
    [    6.970170] advk-pcie d0070000.pcie: Non-posted PIO Response Status: CA, 0xe00 @ 0x100014
    [    6.994328] advk-pcie d0070000.pcie: Posted PIO Response Status: COMP_ERR, 0x804 @ 0x100004

Without this patch kernel prints only a generic error to dmesg:

    [    5.246847] advk-pcie d0070000.pcie: config read/write timed out

Link: https://lore.kernel.org/r/20210722144041.12661-3-pali@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org # 7fbcb5da811b ("PCI: aardvark: Don't rely on jiffies while holding spinlock")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/host/pci-aardvark.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -185,7 +185,7 @@
 	(PCIE_CONF_BUS(bus) | PCIE_CONF_DEV(PCI_SLOT(devfn))	| \
 	 PCIE_CONF_FUNC(PCI_FUNC(devfn)) | PCIE_CONF_REG(where))
 
-#define PIO_RETRY_CNT			500
+#define PIO_RETRY_CNT			750000 /* 1.5 s */
 #define PIO_RETRY_DELAY			2 /* 2 us*/
 
 #define LINK_WAIT_MAX_RETRIES		10


