Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A96A15C402
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729198AbgBMP0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:26:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729196AbgBMP0V (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:21 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2247C20661;
        Thu, 13 Feb 2020 15:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607581;
        bh=ybrmC2rHhdfkY7gVnF0IU5j4QPB1DHBHoIR7OzmC2is=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RrbkQZhPLCr1a38bo5jPzbcz/elGiMRGATWl1/62fUN+ujAYAxx8k4OZ3B+5yl4sP
         jtbld8JwAaaW9Fa70J9/Co44HimstQxYYwnQ3gTgTgKjaGDTWsP2PuCw81ecAd6KQk
         Ub2DjWAeBuzzAHgUeHY5KP7MfpKjOqNketY9yno8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 172/173] libertas: dont exit from lbs_ibss_join_existing() with RCU read lock held
Date:   Thu, 13 Feb 2020 07:21:15 -0800
Message-Id: <20200213152014.343895495@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151931.677980430@linuxfoundation.org>
References: <20200213151931.677980430@linuxfoundation.org>
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
index 4ffc188d2ffd3..a2874f111d122 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -1788,6 +1788,7 @@ static int lbs_ibss_join_existing(struct lbs_private *priv,
 		rates_max = rates_eid[1];
 		if (rates_max > MAX_RATES) {
 			lbs_deb_join("invalid rates");
+			rcu_read_unlock();
 			goto out;
 		}
 		rates = cmd.bss.rates;
-- 
2.20.1



