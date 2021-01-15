Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A147D2F7BCC
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732984AbhAONF5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:05:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:37400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732613AbhAOMb0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:31:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D407238D6;
        Fri, 15 Jan 2021 12:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713819;
        bh=s5rdMnDuSkDqSsdKS3Kfx41GvoHWbEtG2/DA60iC/qQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SnOIjkL46ChIRzjgDCyWIeSR4wwnzbQnf16PJBf2zEW9LePuJkZ9QZpFX6tNXSTLl
         HJztlLTnfiiol8E3dDrnOoXTdkcBE8q2/p1r6+N9GDOFyoKjuVgciChJcayBvbYVaP
         m0ki4EYS/Gs3J8rl9Wb8WSfP1at7y87dCOqIhCH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 18/25] wil6210: select CONFIG_CRC32
Date:   Fri, 15 Jan 2021 13:27:49 +0100
Message-Id: <20210115121957.581983317@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.679956165@linuxfoundation.org>
References: <20210115121956.679956165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit e186620d7bf11b274b985b839c38266d7918cc05 upstream.

Without crc32, the driver fails to link:

arm-linux-gnueabi-ld: drivers/net/wireless/ath/wil6210/fw.o: in function `wil_fw_verify':
fw.c:(.text+0x74c): undefined reference to `crc32_le'
arm-linux-gnueabi-ld: drivers/net/wireless/ath/wil6210/fw.o:fw.c:(.text+0x758): more undefined references to `crc32_le' follow

Fixes: 151a9706503f ("wil6210: firmware download")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/ath/wil6210/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/wil6210/Kconfig
+++ b/drivers/net/wireless/ath/wil6210/Kconfig
@@ -1,6 +1,7 @@
 config WIL6210
 	tristate "Wilocity 60g WiFi card wil6210 support"
 	select WANT_DEV_COREDUMP
+	select CRC32
 	depends on CFG80211
 	depends on PCI
 	default n


