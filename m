Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76CE540C798
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 16:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237693AbhIOOj3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 10:39:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:43024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233771AbhIOOj2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Sep 2021 10:39:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 014DE61247;
        Wed, 15 Sep 2021 14:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631716689;
        bh=eUbxkU27jkxwHFTYD/2m7vbyefMulIGtUgXHvhkbKlk=;
        h=Subject:To:Cc:From:Date:From;
        b=a61xVgwQLH2NPnRrw6ofiSWfOwZ72wOTi+37otlpvqBRdjhplx7iYTwNCymJ1qoGu
         hCqcwshrc8sD8copubVo1MHDQbpT42aV7JQumzoz49/SXsceNgWGrO+XOsFunangsG
         8bQlpjOxlVZnlGVn3iyndJwjf0yMbC1VLDP6rz2w=
Subject: FAILED: patch "[PATCH] PCI: aardvark: Increase polling delay to 1.5s while waiting" failed to apply to 5.10-stable tree
To:     pali@kernel.org, kabel@kernel.org, lorenzo.pieralisi@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Sep 2021 16:38:07 +0200
Message-ID: <16317166872028@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 02bcec3ea5591720114f586960490b04b093a09e Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
Date: Thu, 22 Jul 2021 16:40:39 +0200
Subject: [PATCH] PCI: aardvark: Increase polling delay to 1.5s while waiting
 for PIO response
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index 8bd060e084f1..5b9e4e79c3ae 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -167,7 +167,7 @@
 #define PCIE_CONFIG_WR_TYPE0			0xa
 #define PCIE_CONFIG_WR_TYPE1			0xb
 
-#define PIO_RETRY_CNT			500
+#define PIO_RETRY_CNT			750000 /* 1.5 s */
 #define PIO_RETRY_DELAY			2 /* 2 us*/
 
 #define LINK_WAIT_MAX_RETRIES		10

