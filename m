Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA9C121932
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbfLPRw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:52:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:45750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727634AbfLPRwz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:52:55 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A9FEE2176D;
        Mon, 16 Dec 2019 17:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518775;
        bh=PV0xUFIbqSUM/QVO5CU1Hx7+eOyNGkb2FSCxaY8XQJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wz0LqbOxKZk0ILNNgt6mgdvwSSa4Foj2+spJBY/fCwcpTNkxfr1xYBTjQABWiduou
         UIVuaBG7Kh/+8Z+3lNTZMvlSJXdvshJMrEGuYmGCzEmaUaXyrrTyfWaYnSzDdreoAG
         IXu/PF5ImbWdKAJC5SGMUTs823xCsbAWe/d7cK9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 059/267] dmaengine: coh901318: Fix a double-lock bug
Date:   Mon, 16 Dec 2019 18:46:25 +0100
Message-Id: <20191216174855.519703388@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 627469e4445b9b12e0229b3bdf8564d5ce384dd7 ]

The function coh901318_alloc_chan_resources() calls spin_lock_irqsave()
before calling coh901318_config().
But coh901318_config() calls spin_lock_irqsave() again in its
definition, which may cause a double-lock bug.

Because coh901318_config() is only called by
coh901318_alloc_chan_resources(), the bug fix is to remove the
calls to spin-lock and -unlock functions in coh901318_config().

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/coh901318.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/dma/coh901318.c
+++ b/drivers/dma/coh901318.c
@@ -1802,8 +1802,6 @@ static int coh901318_config(struct coh90
 	int channel = cohc->id;
 	void __iomem *virtbase = cohc->base->virtbase;
 
-	spin_lock_irqsave(&cohc->lock, flags);
-
 	if (param)
 		p = param;
 	else
@@ -1823,8 +1821,6 @@ static int coh901318_config(struct coh90
 	coh901318_set_conf(cohc, p->config);
 	coh901318_set_ctrl(cohc, p->ctrl_lli_last);
 
-	spin_unlock_irqrestore(&cohc->lock, flags);
-
 	return 0;
 }
 


