Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4BD83788E1
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbhEJLYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:24:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:54898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232336AbhEJLL6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4845B6193F;
        Mon, 10 May 2021 11:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644987;
        bh=26CLOr1ZP0TRQ6nJslrI/QIKL/ktpG6A0Qpx2sia6JM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UY3hFTQxDSFLJX+uMZYPnQUoJnbVfMAps3LjlWj6froXllif/PQAvOpPPA+pzb6a6
         Jhjnw7lsnGFMGxLx7d4bYeP2HKbSBshJxjg9IMXl+2TwHspJXoCeDv+v7I8sLBRHqB
         q2CXfE/XUW3cXOO126d905OTJposZHvEfuSpRipA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guangqing Zhu <zhuguangqing83@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Carl Philipp Klemm <philipp@uvos.xyz>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 270/384] power: supply: cpcap-battery: fix invalid usage of list cursor
Date:   Mon, 10 May 2021 12:20:59 +0200
Message-Id: <20210510102023.743855609@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
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
index 6d5bcdb9f45d..a3fc0084cda0 100644
--- a/drivers/power/supply/cpcap-battery.c
+++ b/drivers/power/supply/cpcap-battery.c
@@ -786,7 +786,7 @@ static irqreturn_t cpcap_battery_irq_thread(int irq, void *data)
 			break;
 	}
 
-	if (!d)
+	if (list_entry_is_head(d, &ddata->irq_list, node))
 		return IRQ_NONE;
 
 	latest = cpcap_battery_latest(ddata);
-- 
2.30.2



