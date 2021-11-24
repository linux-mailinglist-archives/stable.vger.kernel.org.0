Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD0C45C01C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346195AbhKXNFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:05:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:43482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347901AbhKXND3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:03:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D719619F8;
        Wed, 24 Nov 2021 12:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757379;
        bh=4zFrEyqGqyh9lv76sY/B+Y+9jcgs335YIhtxFt09pJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FNlvgTEZQZryftAjHzb8iEAblib1H/3+++qqFpC9EPL46ihb07FHJcErIzFZ0qnAA
         P8x5prv7ThLfN9xHCyfG5KeiShOwzDo4gcSdbF3kYsjvcjTpE67CkrX6srNQZI79KT
         E2RTksJeLBuJS382pYRnnq98FAQRMTkmYF0hVWr4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 147/323] memstick: jmb38x_ms: use appropriate free function in jmb38x_ms_alloc_host()
Date:   Wed, 24 Nov 2021 12:55:37 +0100
Message-Id: <20211124115723.889815665@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit beae4a6258e64af609ad5995cc6b6056eb0d898e ]

The "msh" pointer is device managed, meaning that memstick_alloc_host()
calls device_initialize() on it.  That means that it can't be free
using kfree() but must instead be freed with memstick_free_host().
Otherwise it leads to a tiny memory leak of device resources.

Fixes: 60fdd931d577 ("memstick: add support for JMicron jmb38x MemoryStick host controller")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211011123912.GD15188@kili
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memstick/host/jmb38x_ms.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memstick/host/jmb38x_ms.c b/drivers/memstick/host/jmb38x_ms.c
index 29f5021d21ea6..0610d3c9f1318 100644
--- a/drivers/memstick/host/jmb38x_ms.c
+++ b/drivers/memstick/host/jmb38x_ms.c
@@ -907,7 +907,7 @@ static struct memstick_host *jmb38x_ms_alloc_host(struct jmb38x_ms *jm, int cnt)
 
 	iounmap(host->addr);
 err_out_free:
-	kfree(msh);
+	memstick_free_host(msh);
 	return NULL;
 }
 
-- 
2.33.0



