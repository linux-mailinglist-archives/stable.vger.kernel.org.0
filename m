Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3FA1469B2E
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345036AbhLFPN0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:13:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60168 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347026AbhLFPLV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:11:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 927D161327;
        Mon,  6 Dec 2021 15:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E875C341C1;
        Mon,  6 Dec 2021 15:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803270;
        bh=IVFz8ntBdU8/HcdloqpQ2v/VxvPxVUhJLhYdA3vs6a4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=errdKNX+EsA4hBa7UpnItsgFuFJ+Xd5X7fSK6SPFj4eCPtyMS/hRHF5YWzxdiYWcw
         p7cCI3ICg4jssmlOlj+e2aRgoZy7+8uNjInr2/pyOE+UWV6xz8Iz1NvuTktCTBDVB6
         7/Pth/+5plsc0KqBzRVQG8Hl/yVQgD3+ZdCb9KB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Finn Thain <fthain@telegraphics.com.au>,
        Chris Zankel <chris@zankel.net>, linux-xtensa@linux-xtensa.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 089/106] natsemi: xtensa: fix section mismatch warnings
Date:   Mon,  6 Dec 2021 15:56:37 +0100
Message-Id: <20211206145558.601503814@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145555.386095297@linuxfoundation.org>
References: <20211206145555.386095297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

commit b0f38e15979fa8851e88e8aa371367f264e7b6e9 upstream.

Fix section mismatch warnings in xtsonic. The first one appears to be
bogus and after fixing the second one, the first one is gone.

WARNING: modpost: vmlinux.o(.text+0x529adc): Section mismatch in reference from the function sonic_get_stats() to the function .init.text:set_reset_devices()
The function sonic_get_stats() references
the function __init set_reset_devices().
This is often because sonic_get_stats lacks a __init
annotation or the annotation of set_reset_devices is wrong.

WARNING: modpost: vmlinux.o(.text+0x529b3b): Section mismatch in reference from the function xtsonic_probe() to the function .init.text:sonic_probe1()
The function xtsonic_probe() references
the function __init sonic_probe1().
This is often because xtsonic_probe lacks a __init
annotation or the annotation of sonic_probe1 is wrong.

Fixes: 74f2a5f0ef64 ("xtensa: Add support for the Sonic Ethernet device for the XT2000 board.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Finn Thain <fthain@telegraphics.com.au>
Cc: Chris Zankel <chris@zankel.net>
Cc: linux-xtensa@linux-xtensa.org
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Link: https://lore.kernel.org/r/20211130063947.7529-1-rdunlap@infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/natsemi/xtsonic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/natsemi/xtsonic.c
+++ b/drivers/net/ethernet/natsemi/xtsonic.c
@@ -128,7 +128,7 @@ static const struct net_device_ops xtson
 	.ndo_set_mac_address	= eth_mac_addr,
 };
 
-static int __init sonic_probe1(struct net_device *dev)
+static int sonic_probe1(struct net_device *dev)
 {
 	static unsigned version_printed = 0;
 	unsigned int silicon_revision;


