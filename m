Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88D3E288C1
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 21:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391497AbfEWT2b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 15:28:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403755AbfEWT2b (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 23 May 2019 15:28:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DD10121841;
        Thu, 23 May 2019 19:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558639710;
        bh=UMvC08lni5aLyINag6W8qHVq+hf79X6rzLlABvFa1xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JSEJ65Lx6sjLmlEhZTKmYxzciKcC/2es1fQK5YrMX85KGn2IMxJjYDIGzK8j9gm6D
         kYukHYlJF/O2VldNmJHWaIbCGw+mY9deWEARZB3s6W/9cHMoS9UnLv5Tz8p6OFY1w0
         fMRxiZ9LShg1/LoWSx6WGd8RTitubGxTNsFG2ARY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: [PATCH 5.1 050/122] media: seco-cec: fix building with RC_CORE=m
Date:   Thu, 23 May 2019 21:06:12 +0200
Message-Id: <20190523181711.322318490@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190523181705.091418060@linuxfoundation.org>
References: <20190523181705.091418060@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 63604a143fe168094fbbccba56f6e3241683e399 upstream.

I previously added an RC_CORE dependency here, but missed the corner
case of CONFIG_VIDEO_SECO_CEC=y with CONFIG_RC_CORE=m, which still
causes a link error:

drivers/media/platform/seco-cec/seco-cec.o: In function `secocec_probe':
seco-cec.c:(.text+0x1b8): undefined reference to `devm_rc_allocate_device'
seco-cec.c:(.text+0x2e8): undefined reference to `devm_rc_register_device'
drivers/media/platform/seco-cec/seco-cec.o: In function `secocec_irq_handler':
seco-cec.c:(.text+0xa2c): undefined reference to `rc_keydown'

Refine the dependency to disallow building the RC subdriver in this case.
This is the same logic we apply in other drivers like it.

Fixes: f27dd0ad6885 ("media: seco-cec: fix RC_CORE dependency")

Cc: <stable@vger.kernel.org> # 5.1
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/platform/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/platform/Kconfig
+++ b/drivers/media/platform/Kconfig
@@ -649,7 +649,7 @@ config VIDEO_SECO_CEC
 config VIDEO_SECO_RC
 	bool "SECO Boards IR RC5 support"
 	depends on VIDEO_SECO_CEC
-	depends on RC_CORE
+	depends on RC_CORE=y || RC_CORE = VIDEO_SECO_CEC
 	help
 	  If you say yes here you will get support for the
 	  SECO Boards Consumer-IR in seco-cec driver.


