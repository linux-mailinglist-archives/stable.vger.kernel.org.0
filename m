Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 309C9E6939
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730450AbfJ0VfQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:35:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:55622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726817AbfJ0VJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:09:14 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E7ED6214AF;
        Sun, 27 Oct 2019 21:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210553;
        bh=OxtsmDZcRyjTy/TwgnZe5iInYm/ARc+kAq5vsnT/P2M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tg8bBwO8LIG1+Kjt2UplagW4MNUNZ5poqcMbAsMoYHfWhMOi5EqtShMkT/+iKrhmC
         RkQ1eOx6Qs1QqaoQWodo49kUSOWRy8BfiQPKbvO7OPKw2DwrnrkdIazRY/0Zwhmska
         Dm/otqJvtpFoJcwCdLdp5OmR/qvqtCYJS7aPHPYo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Paul Burton <paul.burton@mips.com>, chenhc@lemote.com,
        ralf@linux-mips.org, jhogan@kernel.org, linux-mips@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 012/119] mips: Loongson: Fix the link time qualifier of serial_exit()
Date:   Sun, 27 Oct 2019 21:59:49 +0100
Message-Id: <20191027203303.052992308@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 25b69a889b638b0b7e51e2c4fe717a66bec0e566 ]

'exit' functions should be marked as __exit, not __init.

Fixes: 85cc028817ef ("mips: make loongsoon serial driver explicitly modular")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: chenhc@lemote.com
Cc: ralf@linux-mips.org
Cc: jhogan@kernel.org
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/loongson64/common/serial.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/loongson64/common/serial.c b/arch/mips/loongson64/common/serial.c
index ffefc1cb26121..98c3a7feb10f8 100644
--- a/arch/mips/loongson64/common/serial.c
+++ b/arch/mips/loongson64/common/serial.c
@@ -110,7 +110,7 @@ static int __init serial_init(void)
 }
 module_init(serial_init);
 
-static void __init serial_exit(void)
+static void __exit serial_exit(void)
 {
 	platform_device_unregister(&uart8250_device);
 }
-- 
2.20.1



