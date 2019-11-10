Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855E9F64E0
	for <lists+stable@lfdr.de>; Sun, 10 Nov 2019 04:03:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfKJCsv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Nov 2019 21:48:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:56682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729327AbfKJCsv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 Nov 2019 21:48:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 760CC22583;
        Sun, 10 Nov 2019 02:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354130;
        bh=kL6FU9R5156ffI4nRNa+Oy0TifVNeORlwgtnvFjve3M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KxyDu0MZ57EF4QLeITtSXLiTVnxXkbS5qMg9N6GGhMtDYWz00eo/B1sFFooXMaxq5
         K3+lfhG3bETRnqde4JTIIOUqPFr63hpOuig6KqVBmq4Koiqiik8AICirFCJ5Ytyw4R
         g1mtqQLxzQjd/fDl7V/E2HqTV2YwH1CU6wDBxgXA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anton Vasilyev <vasilyev@ispras.ru>,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-serial@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 03/66] serial: mxs-auart: Fix potential infinite loop
Date:   Sat,  9 Nov 2019 21:47:42 -0500
Message-Id: <20191110024846.32598-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024846.32598-1-sashal@kernel.org>
References: <20191110024846.32598-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index 1d9d778828bae..515bf18c82943 100644
--- a/drivers/tty/serial/mxs-auart.c
+++ b/drivers/tty/serial/mxs-auart.c
@@ -1635,8 +1635,9 @@ static int mxs_auart_request_gpio_irq(struct mxs_auart_port *s)
 
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

