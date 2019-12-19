Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3DE126D96
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:14:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbfLSSiC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:38:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:55904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727939AbfLSSiB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:38:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9976F222C2;
        Thu, 19 Dec 2019 18:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780681;
        bh=pnnd65WYrdGU0mbe64rdND21nMc7k5/IBweNA1lg7Oo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdVOmwgz/DUKSwprjreCa8eJfdYMOzUrKVrYn3KvjUsKHZ6gQ4OVvfYYttlUSIepj
         HBoO3trVAIc1CDYDAFd7TC+LJZVIb7vh55JSmRSxpA4g6APgk1xzq9AeqoKTMta7+m
         dO24AO+ASWDWneF6eUKIJOoE4kMCvu9EoC7Y85gE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Agner <stefan@agner.ch>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 035/162] serial: imx: fix error handling in console_setup
Date:   Thu, 19 Dec 2019 19:32:23 +0100
Message-Id: <20191219183209.950160121@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Agner <stefan@agner.ch>

[ Upstream commit 63fd4b94b948c14eeb27a3bbf50ea0f7f0593bad ]

The ipg clock only needs to be unprepared in case preparing
per clock fails. The ipg clock has already disabled at the point.

Fixes: 1cf93e0d5488 ("serial: imx: remove the uart_console() check")
Signed-off-by: Stefan Agner <stefan@agner.ch>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index f5f46c121ee39..d607cb2eb64eb 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -1784,7 +1784,7 @@ imx_console_setup(struct console *co, char *options)
 
 	retval = clk_prepare(sport->clk_per);
 	if (retval)
-		clk_disable_unprepare(sport->clk_ipg);
+		clk_unprepare(sport->clk_ipg);
 
 error_console:
 	return retval;
-- 
2.20.1



