Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D55741207B
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347208AbhITRzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:55:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355040AbhITRwh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:52:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3928F60F25;
        Mon, 20 Sep 2021 17:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157972;
        bh=QRAfYCMlD1tydVAsQqC38dv/IQY/ZID3c6hiYrYC74A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SjRJqxJbZvwTmXbgZBsTN5ohI6GDdtPEt3n3X3p1GE3Od/eAgV6QPQwPoUt3Y6yUN
         JXlFg2WtoohML2oeVdqM7wibHPwssQh/4+dx7tT4JzZjy3Z+XFrZVSwLNqITuLtHpZ
         usz0WEg9kXzJMd4Nb7wSz3i2hX3KjVe5daVMggxc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 236/293] parport: remove non-zero check on count
Date:   Mon, 20 Sep 2021 18:43:18 +0200
Message-Id: <20210920163941.476735677@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 0be883a0d795d9146f5325de582584147dd0dcdc ]

The check for count appears to be incorrect since a non-zero count
check occurs a couple of statements earlier. Currently the check is
always false and the dev->port->irq != PARPORT_IRQ_NONE part of the
check is never tested and the if statement is dead-code. Fix this
by removing the check on count.

Note that this code is pre-git history, so I can't find a sha for
it.

Acked-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Addresses-Coverity: ("Logically dead code")
Link: https://lore.kernel.org/r/20210730100710.27405-1-colin.king@canonical.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/parport/ieee1284_ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/parport/ieee1284_ops.c b/drivers/parport/ieee1284_ops.c
index 5d41dda6da4e..75daa16f38b7 100644
--- a/drivers/parport/ieee1284_ops.c
+++ b/drivers/parport/ieee1284_ops.c
@@ -535,7 +535,7 @@ size_t parport_ieee1284_ecp_read_data (struct parport *port,
 				goto out;
 
 			/* Yield the port for a while. */
-			if (count && dev->port->irq != PARPORT_IRQ_NONE) {
+			if (dev->port->irq != PARPORT_IRQ_NONE) {
 				parport_release (dev);
 				schedule_timeout_interruptible(msecs_to_jiffies(40));
 				parport_claim_or_block (dev);
-- 
2.30.2



