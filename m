Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBFDD24BAF7
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbgHTMVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:21:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:38628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729887AbgHTJzc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:55:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 201C92067C;
        Thu, 20 Aug 2020 09:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917331;
        bh=Mlre0NfdZn5TVHGLM/JcqLK5nl+zozSKCg2mXww6fb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J02/VjroLimRdxFRp2+LCkjDNNs/QUR00NlPbbtUHTrHsbpT5RP3V49pxKrl5iLFN
         hTl66QPIvD4447XbmAm1JK7h+kXTD1Nq9PBrmYLerDWeQos5xlM6Cpa2gOLfycWovw
         YnHRXz3oj8upX3ZA7l1XlH8qzCslUbj0lr1uR3jA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rich Felker <dalias@libc.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 87/92] sh: landisk: Add missing initialization of sh_io_port_base
Date:   Thu, 20 Aug 2020 11:22:12 +0200
Message-Id: <20200820091542.165410520@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091537.490965042@linuxfoundation.org>
References: <20200820091537.490965042@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 0c64a0dce51faa9c706fdf1f957d6f19878f4b81 ]

The Landisk setup code maps the CF IDE area using ioremap_prot(), and
passes the resulting virtual addresses to the pata_platform driver,
disguising them as I/O port addresses.  Hence the pata_platform driver
translates them again using ioport_map().
As CONFIG_GENERIC_IOMAP=n, and CONFIG_HAS_IOPORT_MAP=y, the
SuperH-specific mapping code in arch/sh/kernel/ioport.c translates
I/O port addresses to virtual addresses by adding sh_io_port_base, which
defaults to -1, thus breaking the assumption of an identity mapping.

Fix this by setting sh_io_port_base to zero.

Fixes: 37b7a97884ba64bf ("sh: machvec IO death.")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Rich Felker <dalias@libc.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sh/boards/mach-landisk/setup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/sh/boards/mach-landisk/setup.c b/arch/sh/boards/mach-landisk/setup.c
index f1147caebacf0..af69fb7fef7c7 100644
--- a/arch/sh/boards/mach-landisk/setup.c
+++ b/arch/sh/boards/mach-landisk/setup.c
@@ -85,6 +85,9 @@ device_initcall(landisk_devices_setup);
 
 static void __init landisk_setup(char **cmdline_p)
 {
+	/* I/O port identity mapping */
+	__set_io_port_base(0);
+
 	/* LED ON */
 	__raw_writeb(__raw_readb(PA_LED) | 0x03, PA_LED);
 
-- 
2.25.1



