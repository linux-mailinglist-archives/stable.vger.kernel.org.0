Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1C43137F07
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729995AbgAKKQD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 05:16:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:58530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729748AbgAKKQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 05:16:03 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA53E205F4;
        Sat, 11 Jan 2020 10:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578737762;
        bh=h4EI1R3/8ZqYDlUaddUK89wFS87jVB3ZVX4EeXuri7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dWOWgZhRCx2TE51Y0vHx8Bgl4Gyis36zXVD32Tx/01OALwAWKxMeaixsWgH+QDV4N
         PWiBFlrEyPUpjt619jSmjhfNJP0h4YpPEglMPl82EHjdmNjAFowl9VAhIkXW0XbHQN
         2oU9XliFKXBomeCPblM7KmhwU1AfD3D1/b67sMcQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@stackframe.org>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/84] parisc: add missing __init annotation
Date:   Sat, 11 Jan 2020 10:50:17 +0100
Message-Id: <20200111094901.521679707@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094845.328046411@linuxfoundation.org>
References: <20200111094845.328046411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@stackframe.org>

[ Upstream commit aeea5eae4fd54e94d820ed17ea3b238160be723e ]

compilation failed with:

MODPOST vmlinux.o
WARNING: vmlinux.o(.text.unlikely+0xa0c): Section mismatch in reference from the function walk_lower_bus() to the function .init.text:walk_native_bus()
The function walk_lower_bus() references
the function __init walk_native_bus().
This is often because walk_lower_bus lacks a __init
annotation or the annotation of walk_native_bus is wrong.

FATAL: modpost: Section mismatches detected.
Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.
make[2]: *** [/home/svens/linux/parisc-linux/src/scripts/Makefile.modpost:64: __modpost] Error 1
make[1]: *** [/home/svens/linux/parisc-linux/src/Makefile:1077: vmlinux] Error 2
make[1]: Leaving directory '/home/svens/linux/parisc-linux/build'
make: *** [Makefile:179: sub-make] Error 2

Signed-off-by: Sven Schnelle <svens@stackframe.org>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/parisc/kernel/drivers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/kernel/drivers.c b/arch/parisc/kernel/drivers.c
index 5eb979d04b90..a1a5e4c59e6b 100644
--- a/arch/parisc/kernel/drivers.c
+++ b/arch/parisc/kernel/drivers.c
@@ -789,7 +789,7 @@ EXPORT_SYMBOL(device_to_hwpath);
 static void walk_native_bus(unsigned long io_io_low, unsigned long io_io_high,
                             struct device *parent);
 
-static void walk_lower_bus(struct parisc_device *dev)
+static void __init walk_lower_bus(struct parisc_device *dev)
 {
 	unsigned long io_io_low, io_io_high;
 
-- 
2.20.1



