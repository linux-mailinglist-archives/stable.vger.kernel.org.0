Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB7F724BCB7
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgHTMvt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:51:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:42058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729271AbgHTJnt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:43:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82C1022B43;
        Thu, 20 Aug 2020 09:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916629;
        bh=I8uEIPz1Akn5O5ubpZWgVp4PADz7yYhOyHoDeLbjUI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWo0yfz6CB+qI7mAL7/lmMUqOE0z5YxgYc78ccX2gzbsbL8ZL4LKLShcxeVjQxeVe
         7eWSpvmM2JvrZXPsWto6JzGssnYYAffvaJbaQOpuIu7T9JYhTBULnIjXcgBfErkynb
         EG/24CPYWWDbJGDW9NnnKwF9W76+GbZXuIifmKSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rich Felker <dalias@libc.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 188/204] sh: landisk: Add missing initialization of sh_io_port_base
Date:   Thu, 20 Aug 2020 11:21:25 +0200
Message-Id: <20200820091615.584546497@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
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
index 16b4d8b0bb850..2c44b94f82fb2 100644
--- a/arch/sh/boards/mach-landisk/setup.c
+++ b/arch/sh/boards/mach-landisk/setup.c
@@ -82,6 +82,9 @@ device_initcall(landisk_devices_setup);
 
 static void __init landisk_setup(char **cmdline_p)
 {
+	/* I/O port identity mapping */
+	__set_io_port_base(0);
+
 	/* LED ON */
 	__raw_writeb(__raw_readb(PA_LED) | 0x03, PA_LED);
 
-- 
2.25.1



