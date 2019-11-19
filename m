Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564A3101731
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 07:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730542AbfKSFty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:49:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:46774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730977AbfKSFtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:49:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFC5420721;
        Tue, 19 Nov 2019 05:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574142591;
        bh=oDKOZKsGlOSOwbHZ/0xDL00iTc9xm4wYxZZxvU1I6Pc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MSi9icl6diIxTztkx04q+QfB0mjB9fj5jhjcajI9GeNr/VIBw8WhScBJwuknapO/R
         YsEqQmnxjDK57blqSfH559mfpnAIPkW0nQC0L33lPJqT1//ENL22b4MqTjrna+/ZTi
         HxrBCAFkc+7ZiIALaoAycgkCJ8sSpOWVt8KFOoa0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anton Vasilyev <vasilyev@ispras.ru>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 134/239] serial: mxs-auart: Fix potential infinite loop
Date:   Tue, 19 Nov 2019 06:18:54 +0100
Message-Id: <20191119051330.894516003@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119051255.850204959@linuxfoundation.org>
References: <20191119051255.850204959@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Vasilyev <vasilyev@ispras.ru>

[ Upstream commit 5963e8a3122471cadfe0eba41c4ceaeaa5c8bb4d ]

On the error path of mxs_auart_request_gpio_irq() is performed
backward iterating with index i of enum type. Underline enum type
may be unsigned char. In this case check (--i >= 0) will be always
true and error handling goes into infinite loop.

The patch changes the check so that it is valid for signed and unsigned
types.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Anton Vasilyev <vasilyev@ispras.ru>
Acked-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/mxs-auart.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/mxs-auart.c b/drivers/tty/serial/mxs-auart.c
index 673c8fd7e34f6..e83750831f15e 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -1638,8 +1638,9 @@ static int mxs_auart_request_gpio_irq(struct mxs_auart_port *s)
 
 	/*
 	 * If something went wrong, rollback.
+	 * Be careful: i may be unsigned.
 	 */
-	while (err && (--i >= 0))
+	while (err && (i-- > 0))
 		if (irq[i] >= 0)
 			free_irq(irq[i], s);
 
-- 
2.20.1



