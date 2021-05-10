Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72130378469
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233252AbhEJKwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:52:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233599AbhEJKuR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:50:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5380761A13;
        Mon, 10 May 2021 10:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643172;
        bh=Xf+puenA/PUhO6WkOQj7oPaNgZ6nEmCspFlKaCdmti0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Sp7RiJemB+F0yGEoFKIk6tmMxtRtA5lKZ/lO2eB+bHgecrZvuPrAEsQ+xdNpaCQSo
         kXbg9p8R38NZWwzS8ucM7cdhV+X5XCz24TeR5bfbNQdmIdztHgJpqRkFoPfjr0gK+j
         TdgLYJQpjEI4nSxe9x4zLi/ZEcGBf+h/GVApwJIk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangqing Zhu <zhuguangqing83@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Carl Philipp Klemm <philipp@uvos.xyz>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 208/299] power: supply: cpcap-battery: fix invalid usage of list cursor
Date:   Mon, 10 May 2021 12:20:05 +0200
Message-Id: <20210510102011.818616470@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guangqing Zhu <zhuguangqing83@gmail.com>

[ Upstream commit d0a43c12ee9f57ddb284272187bd18726c2c2c98 ]

Fix invalid usage of a list_for_each_entry in cpcap_battery_irq_thread().
Empty list or fully traversed list points to list head, which is not
NULL (and before the first element containing real data).

Signed-off-by: Guangqing Zhu <zhuguangqing83@gmail.com>
Reviewed-by: Tony Lindgren <tony@atomide.com>
Reviewed-by: Carl Philipp Klemm <philipp@uvos.xyz>
Tested-by: Carl Philipp Klemm <philipp@uvos.xyz>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/cpcap-battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/power/supply/cpcap-battery.c b/drivers/power/supply/cpcap-battery.c
index cebc5c8fda1b..793d4ca52f8a 100644
--- a/drivers/power/supply/cpcap-battery.c
+++ b/drivers/power/supply/cpcap-battery.c
@@ -626,7 +626,7 @@ static irqreturn_t cpcap_battery_irq_thread(int irq, void *data)
 			break;
 	}
 
-	if (!d)
+	if (list_entry_is_head(d, &ddata->irq_list, node))
 		return IRQ_NONE;
 
 	latest = cpcap_battery_latest(ddata);
-- 
2.30.2



