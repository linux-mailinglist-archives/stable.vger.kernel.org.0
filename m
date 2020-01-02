Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99ACC12F165
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 00:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727686AbgABWNY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:13:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:53142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727678AbgABWNY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:13:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E4AA22314;
        Thu,  2 Jan 2020 22:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003203;
        bh=hAw9jf6O4Dcc98roBEzpRWvY2Hq00GjTWZzmwZFscOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPEmxUsE/itm0FOoEvEIfKXAllr/45tynxzj4v3VKJm7ulW5Bxy9PyF/hEcxMAjfg
         lUxsMmwySD3v91/KJge4+6CMWuwgoxf/9b1oitGrx8n/Gs1MQBHDI53f0GT0JxU7b6
         /qXmHZGC0Fj517MMJvp947MDaPKsOPSw3t6dGr8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Rob Herring <robh@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/191] clocksource/drivers/timer-of: Use unique device name instead of timer
Date:   Thu,  2 Jan 2020 23:05:19 +0100
Message-Id: <20200102215833.929050360@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 4411464d6f8b5e5759637235a6f2b2a85c2be0f1 ]

If a hardware-specific driver does not provide a name, the timer-of core
falls back to device_node.name.  Due to generic DT node naming policies,
that name is almost always "timer", and thus doesn't identify the actual
timer used.

Fix this by using device_node.full_name instead, which includes the unit
addrees.

Example impact on /proc/timer_list:

    -Clock Event Device: timer
    +Clock Event Device: timer@fcfec400

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20191016144747.29538-3-geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-of.c b/drivers/clocksource/timer-of.c
index 11ff701ff4bb..a3c73e972fce 100644
--- a/drivers/clocksource/timer-of.c
+++ b/drivers/clocksource/timer-of.c
@@ -192,7 +192,7 @@ int __init timer_of_init(struct device_node *np, struct timer_of *to)
 	}
 
 	if (!to->clkevt.name)
-		to->clkevt.name = np->name;
+		to->clkevt.name = np->full_name;
 
 	to->np = np;
 
-- 
2.20.1



