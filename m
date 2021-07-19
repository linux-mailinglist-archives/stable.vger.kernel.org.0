Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB8C63CDDDF
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344791AbhGSPBK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:01:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:52468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344117AbhGSO7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 912FA61001;
        Mon, 19 Jul 2021 15:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709118;
        bh=03XAdz9ZISH0iiky0yAc27/WCMoseRxMBc2HWd2ivZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13uy4hC3ElGhJ+pxq1rUuuXnZIlbhvsl6qh3tOpdP98TkDHf1amgAQKC2gyBs8Ybp
         T/OBivEY1mO1oO/pbSWb0GOWZzzabYaMTZ+28yjeVOIya+Qpp+s/BxzS9pHKej3iCO
         UoIfOo2dM2LyYaeN5wu0a0aVt5XiMHNUL1YYYLEk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Zhen Lei <thunder.leizhen@huawei.com>,
        Pavel Machek <pavel@ucw.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 216/421] leds: as3645a: Fix error return code in as3645a_parse_node()
Date:   Mon, 19 Jul 2021 16:50:27 +0200
Message-Id: <20210719144953.819149548@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 96a30960a2c5246c8ffebe8a3c9031f9df094d97 ]

Return error code -ENODEV rather than '0' when the indicator node can not
be found.

Fixes: a56ba8fbcb55 ("media: leds: as3645a: Add LED flash class driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Signed-off-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-as3645a.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/leds-as3645a.c b/drivers/leds/leds-as3645a.c
index f883616d9e60..821944379f2c 100644
--- a/drivers/leds/leds-as3645a.c
+++ b/drivers/leds/leds-as3645a.c
@@ -565,6 +565,7 @@ static int as3645a_parse_node(struct as3645a *flash,
 	if (!flash->indicator_node) {
 		dev_warn(&flash->client->dev,
 			 "can't find indicator node\n");
+		rval = -ENODEV;
 		goto out_err;
 	}
 
-- 
2.30.2



