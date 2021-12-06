Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B9D469A8B
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242400AbhLFPIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:08:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:39726 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346567AbhLFPGp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:06:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D676AB81018;
        Mon,  6 Dec 2021 15:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFAB6C341C1;
        Mon,  6 Dec 2021 15:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638802994;
        bh=IVFz8ntBdU8/HcdloqpQ2v/VxvPxVUhJLhYdA3vs6a4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FnsmeEqsFe6K4W3PudrTyd/jEGREhTK2DAOtkPlm6znbANVNoIcHSvwFd7GqTIFiH
         lApgO13JMxyTLqRmk+TqiQD/FdJiWPy8Ziy64bFiudZeKXRSi6vhuVsQ/RiiwI4xmb
         Gcs9Dzil69b8VZXB4D4w1SIJhU3OYPPgs6FaM6AU=
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
Subject: [PATCH 4.9 54/62] natsemi: xtensa: fix section mismatch warnings
Date:   Mon,  6 Dec 2021 15:56:37 +0100
Message-Id: <20211206145551.068257341@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145549.155163074@linuxfoundation.org>
References: <20211206145549.155163074@linuxfoundation.org>
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


