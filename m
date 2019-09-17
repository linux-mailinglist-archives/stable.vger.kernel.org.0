Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B616B53DE
	for <lists+stable@lfdr.de>; Tue, 17 Sep 2019 19:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfIQRTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Sep 2019 13:19:02 -0400
Received: from smtp.domeneshop.no ([194.63.252.55]:46899 "EHLO
        smtp.domeneshop.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbfIQRTC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Sep 2019 13:19:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=tronnes.org
        ; s=ds201810; h=Content-Transfer-Encoding:Content-Type:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=MfZrMCUAMeA7TQrw3rrOPzZCfpWaDHz40znbVYjtSGc=; b=EvJiObe6F1J/NU4cwdHtBQJwsm
        tvzmF3ckxOYGz+xxC9Ww9cA012m3X9wxOJDmTpO+fHNEia9zU+Ri/A281pBzwDXPobT3IU0krwt4X
        alAZ+n/0vNuBuTXAUUjm9weACND2AVMYeUyQR6I8okjancFCIYym1nKGjY2n2JBQSd/lSJ81T+YHh
        O4yhfdtmmOiJRWAIpCY0tnYTeQzMaEy/s4sd06EBdIxbGdBMGx5AxnFFTo+yjDMdAEazFbGzrgpeC
        CW2xSkPJiA8ZYIinPttIfGvRV3KC2sPXFl5MrHdo7nkHe/3BJYT1jOf+XhKX/8wujlh8xTNVwJPhg
        DmdH4DTg==;
Received: from 211.81-166-168.customer.lyse.net ([81.166.168.211]:60392 helo=localhost.localdomain)
        by smtp.domeneshop.no with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_CBC_SHA1:128)
        (Exim 4.89)
        (envelope-from <noralf@tronnes.org>)
        id 1iAH7z-0005yL-Lc; Tue, 17 Sep 2019 19:18:59 +0200
From:   =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>
To:     devel@driverdev.osuosl.org
Cc:     gregkh@linuxfoundation.org,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/3] staging/fbtft: Depend on OF
Date:   Tue, 17 Sep 2019 19:18:41 +0200
Message-Id: <20190917171843.10334-1-noralf@tronnes.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit c440eee1a7a1 ("Staging: fbtft: Switch to the gpio descriptor
interface") removed setting gpios via platform data. This means that
fbtft will now only work with Device Tree so set the dependency.

This also prevents a NULL pointer deref on non-DT platform because
fbtftops.request_gpios is not set in that case anymore.

Fixes: c440eee1a7a1 ("Staging: fbtft: Switch to the gpio descriptor interface")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Noralf Trønnes <noralf@tronnes.org>
---
 drivers/staging/fbtft/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/fbtft/Kconfig b/drivers/staging/fbtft/Kconfig
index 8ec524a95ec8..4e5d860fd788 100644
--- a/drivers/staging/fbtft/Kconfig
+++ b/drivers/staging/fbtft/Kconfig
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 menuconfig FB_TFT
 	tristate "Support for small TFT LCD display modules"
-	depends on FB && SPI
+	depends on FB && SPI && OF
 	depends on GPIOLIB || COMPILE_TEST
 	select FB_SYS_FILLRECT
 	select FB_SYS_COPYAREA
-- 
2.20.1

