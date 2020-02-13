Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC42615C3A6
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbgBMPnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:43:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729517AbgBMP14 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:27:56 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6146C24682;
        Thu, 13 Feb 2020 15:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607676;
        bh=sOWt88WVkaqu6GMzTtpvWwwMB224frFvtLxOEicCWVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PVv+oi8rqt6DzVDNwHuqXb3hDTS1JNbrnHBd7lGHt/gstofCw+F8qoMusYHMJMDTw
         IinhxOBM1EVFfqpf4gDOLCarCNcRGycfrcfIBjaY35jQsOq+3Pqqw5Ygb8kRgICsje
         O0xWBRq5rjpABJTYRU/Pn1YkMBDxeo1eUDZcyy2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 95/96] libertas: dont exit from lbs_ibss_join_existing() with RCU read lock held
Date:   Thu, 13 Feb 2020 07:21:42 -0800
Message-Id: <20200213151914.499399051@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151839.156309910@linuxfoundation.org>
References: <20200213151839.156309910@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolai Stange <nstange@suse.de>

[ Upstream commit c7bf1fb7ddca331780b9a733ae308737b39f1ad4 ]

Commit e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss
descriptor") introduced a bounds check on the number of supplied rates to
lbs_ibss_join_existing().

Unfortunately, it introduced a return path from within a RCU read side
critical section without a corresponding rcu_read_unlock(). Fix this.

Fixes: e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss descriptor")
Signed-off-by: Nicolai Stange <nstange@suse.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/cfg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index c9401c121a14e..68985d7663491 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -1785,6 +1785,7 @@ static int lbs_ibss_join_existing(struct lbs_private *priv,
 		rates_max = rates_eid[1];
 		if (rates_max > MAX_RATES) {
 			lbs_deb_join("invalid rates");
+			rcu_read_unlock();
 			goto out;
 		}
 		rates = cmd.bss.rates;
-- 
2.20.1



