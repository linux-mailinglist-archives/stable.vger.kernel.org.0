Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389F72FC97A
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 04:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729163AbhATC2N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jan 2021 21:28:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:46600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729328AbhATB12 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Jan 2021 20:27:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8032923131;
        Wed, 20 Jan 2021 01:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611105970;
        bh=saFJQyo/hoTL0Hb67wDhk6xyGKhA1Q7cd/qHGjDhsLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GfHWZp8VRLCyLQ4Lwd7zdRpFeZrGygAruKSnEHd+8OMI+Buoc3wvCQ1cG1RQBCW3d
         bfEmpHRbaj9zXN22NOvNJzSb0xgtt8TBpKc0TlBgNaNQfw1BgRfMZZxbE63kgZCHjU
         fPxRtGsXJJ+Tu/pznS87udfW1ErgksCq3tg/WJ3Qyqv90eyg0x6zxjt7XbhOeq2PDP
         WiVXmRbaWBrlxI/Id6LUbbV6O9itZmuFlSg7KT1eE0dYmGvb7OfvdBIJBlelwc06+m
         cQgsvDsCFTglbtRw/rcwfsehXKNIlinReUN5K8llrKmACWlwiLA1o5QnyG6tAaFCQE
         TGoc2BhqqfSAg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 06/45] HID: sony: select CONFIG_CRC32
Date:   Tue, 19 Jan 2021 20:25:23 -0500
Message-Id: <20210120012602.769683-6-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210120012602.769683-1-sashal@kernel.org>
References: <20210120012602.769683-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 273435a1d4e5826f039625c23ba4fe9a09f24d75 ]

Without crc32 support, this driver fails to link:

arm-linux-gnueabi-ld: drivers/hid/hid-sony.o: in function `sony_raw_event':
hid-sony.c:(.text+0x8f4): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: hid-sony.c:(.text+0x900): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: drivers/hid/hid-sony.o:hid-sony.c:(.text+0x4408): more undefined references to `crc32_le' follow

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 612629678c845..9b56226ce0d1c 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -899,6 +899,7 @@ config HID_SONY
 	depends on NEW_LEDS
 	depends on LEDS_CLASS
 	select POWER_SUPPLY
+	select CRC32
 	help
 	Support for
 
-- 
2.27.0

