Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0C932C9BE7
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390059AbgLAJNN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 04:13:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390054AbgLAJNJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 04:13:09 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 61EC2206C1;
        Tue,  1 Dec 2020 09:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813949;
        bh=N7Bh0NS6yEu4dy81gH7ZNfZql5stSWvCg2+a4Z4tAtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=esd29kfjuiwoFrGST95XgYmjp9E5cNCGVmeOnln7BLlvrQ0HBlXTFiZWAPE2Vo2XD
         4DlAlwpsalE2WIv5ViLNE553N+RuzhR4EOiHN8O3omhzDx8ybA4teImUWKJlvOmA56
         z7weHfolUFatygwi/fn3x73yc3RAAnsGXGIpR57Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 085/152] bus: ti-sysc: suppress err msg for timers used as clockevent/source
Date:   Tue,  1 Dec 2020 09:53:20 +0100
Message-Id: <20201201084723.007191985@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084711.707195422@linuxfoundation.org>
References: <20201201084711.707195422@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit 65fb73676112f6fd107c5e542b2cbcfb206fe881 ]

GP Timers used as clockevent/source are not available for ti-sysc bus and
handled by Kernel timekeeping core. Now ti-sysc produces error message
every time such timer is detected:

 "ti-sysc: probe of 48040000.target-module failed with error -16"

Such messages are not necessary, so suppress them by returning -ENXIO
instead of -EBUSY.

Fixes: 6cfcd5563b4f ("clocksource/drivers/timer-ti-dm: Fix suspend and resume for am3 and am4")
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/ti-sysc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 16132e6e91f8d..92ecf1a78ec73 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -2889,7 +2889,7 @@ static int sysc_check_active_timer(struct sysc *ddata)
 
 	if ((ddata->cfg.quirks & SYSC_QUIRK_NO_RESET_ON_INIT) &&
 	    (ddata->cfg.quirks & SYSC_QUIRK_NO_IDLE))
-		return -EBUSY;
+		return -ENXIO;
 
 	return 0;
 }
-- 
2.27.0



