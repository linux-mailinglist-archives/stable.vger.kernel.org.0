Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C564E206690
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:52:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388491AbgFWVoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:44:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:39320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387783AbgFWUCM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:02:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BAD472082F;
        Tue, 23 Jun 2020 20:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942532;
        bh=cEEfnp8GM0YdC1p3hokCpsKZ1vVckL0y5eAVAhF52xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ubofZOKm1MxRemjA/L46LRPvd+TzC1H/g3LrgZiX0Ma0OO8dNkK/agZ448ePGMoC8
         C991qDUhQFZ7SXDAlgSp6H5xx1+ypZFFSDPZP02UJtyJxYKbcjDL9W38+E1OpyK9mj
         ZEN3W36TwhUMOsmAG17o2fTEu6mhKDHdn4wcnmIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 005/477] rtc: rc5t619: Fix an ERR_PTR vs NULL check
Date:   Tue, 23 Jun 2020 21:50:02 +0200
Message-Id: <20200623195407.843697778@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 11ddbdfb68e4f9791e4bd4f8d7c87d3f19670967 ]

The devm_kzalloc() function returns NULL on error, it doesn't return
error pointers so this check doesn't work.

Fixes: 540d1e15393d ("rtc: rc5t619: Add Ricoh RC5T619 RTC driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20200407092852.GI68494@mwanda
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rc5t619.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-rc5t619.c b/drivers/rtc/rtc-rc5t619.c
index 24e386ecbc7ed..dd1a20977478e 100644
--- a/drivers/rtc/rtc-rc5t619.c
+++ b/drivers/rtc/rtc-rc5t619.c
@@ -356,10 +356,8 @@ static int rc5t619_rtc_probe(struct platform_device *pdev)
 	int err;
 
 	rtc = devm_kzalloc(dev, sizeof(*rtc), GFP_KERNEL);
-	if (IS_ERR(rtc)) {
-		err = PTR_ERR(rtc);
+	if (!rtc)
 		return -ENOMEM;
-	}
 
 	rtc->rn5t618 = rn5t618;
 
-- 
2.25.1



