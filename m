Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D30991676C0
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731103AbgBUIDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:03:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:36594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728953AbgBUIDp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:03:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 342E024650;
        Fri, 21 Feb 2020 08:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272224;
        bh=6lKOMqR9i+K8QwMDVdaLd2gD/Oq+Ml/qLNpP7AQyCxU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y3GMhxVBG0s92AgK9ypOTSG2GeSBXTFnG5Yv6/EKXE1g5QJrusv4hR8QIpW/1o2MH
         U3ZyrDWBF4zt/nLBjRIqzWszZs/vVbYjlHKhh3pEdzfhMZ+LJDAtWFNfVRYVX21P/u
         eI4ncTNJimunE/fVXF7DVV2K1Ok9bWe9bCbJYJIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/344] clocksource/drivers/bcm2835_timer: Fix memory leak of timer
Date:   Fri, 21 Feb 2020 08:37:40 +0100
Message-Id: <20200221072354.581014752@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 2052d032c06761330bca4944bb7858b00960e868 ]

Currently when setup_irq fails the error exit path will leak the
recently allocated timer structure.  Originally the code would
throw a panic but a later commit changed the behaviour to return
via the err_iounmap path and hence we now have a memory leak. Fix
this by adding a err_timer_free error path that kfree's timer.

Addresses-Coverity: ("Resource Leak")
Fixes: 524a7f08983d ("clocksource/drivers/bcm2835_timer: Convert init function to return error")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20191219213246.34437-1-colin.king@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/bcm2835_timer.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clocksource/bcm2835_timer.c b/drivers/clocksource/bcm2835_timer.c
index 2b196cbfadb62..b235f446ee50f 100644
--- a/drivers/clocksource/bcm2835_timer.c
+++ b/drivers/clocksource/bcm2835_timer.c
@@ -121,7 +121,7 @@ static int __init bcm2835_timer_init(struct device_node *node)
 	ret = setup_irq(irq, &timer->act);
 	if (ret) {
 		pr_err("Can't set up timer IRQ\n");
-		goto err_iounmap;
+		goto err_timer_free;
 	}
 
 	clockevents_config_and_register(&timer->evt, freq, 0xf, 0xffffffff);
@@ -130,6 +130,9 @@ static int __init bcm2835_timer_init(struct device_node *node)
 
 	return 0;
 
+err_timer_free:
+	kfree(timer);
+
 err_iounmap:
 	iounmap(base);
 	return ret;
-- 
2.20.1



