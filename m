Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028E6431D4D
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbhJRNuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:50:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:50494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233967AbhJRNsQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:48:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C263617E3;
        Mon, 18 Oct 2021 13:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564209;
        bh=hdVSouO5q40i5sExSswgZBr9F2tSWw0r0jMFgRHJJXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U11Tiu4fq9u8dIEiXNaAhgJZyrwrX+f8P6/mM/QUd5MC+0WMSKo7RbdlZ2t2tjI/m
         BE2s8P8n6vIN6S6QU6Y4s16ehsldObWA2mY0sFvsgfZejLTgZ7G4bjG2WFu4VDif81
         c/NE07hyClLzGVmTEZwkE+bIWF574PQDzCq2A+yM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 5.10 083/103] ata: ahci_platform: fix null-ptr-deref in ahci_platform_enable_regulators()
Date:   Mon, 18 Oct 2021 15:24:59 +0200
Message-Id: <20211018132337.545305044@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132334.702559133@linuxfoundation.org>
References: <20211018132334.702559133@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

commit 776c75010803849c1cc4f11031a2b3960ab05202 upstream.

I got a null-ptr-deref report:

KASAN: null-ptr-deref in range [0x0000000000000090-0x0000000000000097]
...
RIP: 0010:regulator_enable+0x84/0x260
...
Call Trace:
 ahci_platform_enable_regulators+0xae/0x320
 ahci_platform_enable_resources+0x1a/0x120
 ahci_probe+0x4f/0x1b9
 platform_probe+0x10b/0x280
...
 entry_SYSCALL_64_after_hwframe+0x44/0xae

If devm_regulator_get() in ahci_platform_get_resources() fails,
hpriv->phy_regulator will point to NULL, when enabling or disabling it,
null-ptr-deref will occur.

ahci_probe()
	ahci_platform_get_resources()
		devm_regulator_get(, "phy") // failed, let phy_regulator = NULL
	ahci_platform_enable_resources()
		ahci_platform_enable_regulators()
			regulator_enable(hpriv->phy_regulator) // null-ptr-deref

commit 962399bb7fbf ("ata: libahci_platform: Fix regulator_get_optional()
misuse") replaces devm_regulator_get_optional() with devm_regulator_get(),
but PHY regulator omits to delete "hpriv->phy_regulator = NULL;" like AHCI.
Delete it like AHCI regulator to fix this bug.

Fixes: commit 962399bb7fbf ("ata: libahci_platform: Fix regulator_get_optional() misuse")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libahci_platform.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/ata/libahci_platform.c
+++ b/drivers/ata/libahci_platform.c
@@ -440,10 +440,7 @@ struct ahci_host_priv *ahci_platform_get
 	hpriv->phy_regulator = devm_regulator_get(dev, "phy");
 	if (IS_ERR(hpriv->phy_regulator)) {
 		rc = PTR_ERR(hpriv->phy_regulator);
-		if (rc == -EPROBE_DEFER)
-			goto err_out;
-		rc = 0;
-		hpriv->phy_regulator = NULL;
+		goto err_out;
 	}
 
 	if (flags & AHCI_PLATFORM_GET_RESETS) {


