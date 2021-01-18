Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38ED92F9F97
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391534AbhARM1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:27:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:38996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390724AbhARLps (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D95C522CF6;
        Mon, 18 Jan 2021 11:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970295;
        bh=robM1FCf2o6+qoV9voRAPYcuZqSUj2u4npsE/QEkB1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MH1KEqPCf7bLu7cCmct2B4x8qJSz/cFW1yUwzfXNM+DlkQpLQv+SHwdC9Xi0wU19Z
         AiKxze4lBKAW3zQkyK5UGfkQ2Q8jLewjDJ6wnKVjSxws+83Rvv8Tz3PhYX8RGVj3fA
         YD65scDAX3FYgejKCaDHPcluft61TOP5GFfdRclY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/152] cfg80211: select CONFIG_CRC32
Date:   Mon, 18 Jan 2021 12:34:37 +0100
Message-Id: <20210118113357.631944183@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 152a8a6c017bfdeda7f6d052fbc6e151891bd9b6 ]

Without crc32 support, this fails to link:

arm-linux-gnueabi-ld: net/wireless/scan.o: in function `cfg80211_scan_6ghz':
scan.c:(.text+0x928): undefined reference to `crc32_le'

Fixes: c8cb5b854b40 ("nl80211/cfg80211: support 6 GHz scanning")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
index 27026f587fa61..f620acd2a0f5e 100644
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -21,6 +21,7 @@ config CFG80211
 	tristate "cfg80211 - wireless configuration API"
 	depends on RFKILL || !RFKILL
 	select FW_LOADER
+	select CRC32
 	# may need to update this when certificates are changed and are
 	# using a different algorithm, though right now they shouldn't
 	# (this is here rather than below to allow it to be a module)
-- 
2.27.0



