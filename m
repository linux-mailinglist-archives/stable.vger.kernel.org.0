Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9D451013A9
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728530AbfKSF0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:26:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728517AbfKSF0N (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:26:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2485222A2;
        Tue, 19 Nov 2019 05:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574141172;
        bh=b8J4MxCR33d36gDUpia1X9tMWmKY6k0ovzSnBa1tW+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JHHJwF7OjwrafC/WByksRFzvnygRH0L2+bZ2KB0couvaVSwbdYvoqBQLvTsjGCJ3y
         E0XmVYfTa2Z0rUZGdwRW/0S+DT0VMxxMVaCUfs2hBvDLpfSL52aPQgVEXsrtbY/VS2
         9THFqHDSSzq3y3vsZ2S7EEeCNVCiKdXhWH/yIekA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 070/422] pinctrl: ingenic: Probe driver at subsys_initcall
Date:   Tue, 19 Nov 2019 06:14:27 +0100
Message-Id: <20191119051404.162474836@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051400.261610025@linuxfoundation.org>
References: <20191119051400.261610025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

[ Upstream commit 556a36a71ed80e17ade49225b58513ea3c9e4558 ]

Using postcore_initcall() makes the driver try to initialize way too
early.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-ingenic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index 628817c40e3bb..a5accffbc8c91 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -847,4 +847,4 @@ static int __init ingenic_pinctrl_drv_register(void)
 {
 	return platform_driver_register(&ingenic_pinctrl_driver);
 }
-postcore_initcall(ingenic_pinctrl_drv_register);
+subsys_initcall(ingenic_pinctrl_drv_register);
-- 
2.20.1



