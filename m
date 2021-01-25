Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0406302AB2
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:50:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbhAYSuS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:50:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730897AbhAYSs7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:48:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A4462075B;
        Mon, 25 Jan 2021 18:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600497;
        bh=saFJQyo/hoTL0Hb67wDhk6xyGKhA1Q7cd/qHGjDhsLw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=on9ZGc8gfvAkZ23BSB1d2Y3KjLeZp4KBCmeW9l6zN8h5gVYsob76Ahs6e9kiOeoLJ
         AuKHbFN1XuqAdUkeVfV1p6ll7iswu/mSRDnrjoR/LeJHbUE47RGFUYW+Q3t98t8AfF
         ISE4LXIqqEmcEd4RUGRAOl4GoY1ZHlF0sdzFJKpw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/199] HID: sony: select CONFIG_CRC32
Date:   Mon, 25 Jan 2021 19:37:40 +0100
Message-Id: <20210125183217.854376341@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



