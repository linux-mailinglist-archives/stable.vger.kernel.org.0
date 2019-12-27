Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A03712B716
	for <lists+stable@lfdr.de>; Fri, 27 Dec 2019 18:47:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727616AbfL0RrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Dec 2019 12:47:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728261AbfL0RpB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Dec 2019 12:45:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70E42222C4;
        Fri, 27 Dec 2019 17:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577468701;
        bh=h4EI1R3/8ZqYDlUaddUK89wFS87jVB3ZVX4EeXuri7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aa7jvE2RwYcoFdUM1IIfsWSVOuu2GBs1zsOQ8jqmrsYcqdGUcP47C0We9WmDT3P7P
         j11QFW1MjyVyGloiOj4N5O/AYxte/BU4Gg9pzhkdFeLpqVvkNK81OmPJyPOHd6P30f
         wzHlY+GJG/vTWzte3p22Po8mK/qnRp9sBc1XWkpI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sven Schnelle <svens@stackframe.org>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, linux-parisc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 57/84] parisc: add missing __init annotation
Date:   Fri, 27 Dec 2019 12:43:25 -0500
Message-Id: <20191227174352.6264-57-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191227174352.6264-1-sashal@kernel.org>
References: <20191227174352.6264-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

