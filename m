Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0DA206562
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387779AbgFWUCM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:02:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:39202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387543AbgFWUCH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:02:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 932462082F;
        Tue, 23 Jun 2020 20:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592942527;
        bh=YsAd++K2D9kAS2XJZYVl1Ca7YxKlSgM03ysJztGuk6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zRYo+44L613190DBVGackxApRA3AnWtzobGf/oYUuSzHVe8zZtG3imbBEeTem5zGH
         rbFaYh7oSygyy72fxxjIO7a/ecXREyRFEFY1bqO81YOZGe/2ALRYqHQmx0xN6suR0u
         ej/6TYIy88HvwCA35pf6uFApnFhLqv4jGLonL9uk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 032/477] rtc: mc13xxx: fix a double-unlock issue
Date:   Tue, 23 Jun 2020 21:50:29 +0200
Message-Id: <20200623195409.116071107@linuxfoundation.org>
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

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit 8816cd726a4fee197af2d851cbe25991ae19ea14 ]

In function mc13xxx_rtc_probe, the mc13xxx_unlock() is called
before rtc_register_device(). But in the error path of
rtc_register_device(), the mc13xxx_unlock() is called again,
which causes a double-unlock problem. Thus add a call of the
function “mc13xxx_lock” in an if branch for the completion
of the exception handling.

Fixes: e4ae7023e182a ("rtc: mc13xxx: set range")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Link: https://lore.kernel.org/r/20200503182235.1652-1-wu000273@umn.edu
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mc13xxx.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-mc13xxx.c b/drivers/rtc/rtc-mc13xxx.c
index afce2c0b4bd67..d6802e6191cbe 100644
--- a/drivers/rtc/rtc-mc13xxx.c
+++ b/drivers/rtc/rtc-mc13xxx.c
@@ -308,8 +308,10 @@ static int __init mc13xxx_rtc_probe(struct platform_device *pdev)
 	mc13xxx_unlock(mc13xxx);
 
 	ret = rtc_register_device(priv->rtc);
-	if (ret)
+	if (ret) {
+		mc13xxx_lock(mc13xxx);
 		goto err_irq_request;
+	}
 
 	return 0;
 
-- 
2.25.1



