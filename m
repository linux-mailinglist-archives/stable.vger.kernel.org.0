Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB3F15C49D
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729258AbgBMPtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:49:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:47346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387635AbgBMP0t (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:49 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97A29222C2;
        Thu, 13 Feb 2020 15:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607608;
        bh=laid7J5sQfr4zc5dfFYayIFp5SqBhYxHplp0Qg+Sfbc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abyzlmzA1QFx2MplJJWFt8EmZkFY1UAhg85frjDhNIkPNib0YpQ2MKbe5q7s/1vu0
         EZ+Hj3HZAfrV3yDEY1fvfyjDmj8s3BINrJnUZ68u5vZZx8PCQoCnw0tc6+iF/btIh7
         gmUO0XzY7UvsgjeqjteY6POrWcxNZXl4kTJgnPYA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolai Stange <nstange@suse.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 49/52] libertas: make lbs_ibss_join_existing() return error code on rates overflow
Date:   Thu, 13 Feb 2020 07:21:30 -0800
Message-Id: <20200213151829.946401006@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151810.331796857@linuxfoundation.org>
References: <20200213151810.331796857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicolai Stange <nstange@suse.de>

[ Upstream commit 1754c4f60aaf1e17d886afefee97e94d7f27b4cb ]

Commit e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss
descriptor") introduced a bounds check on the number of supplied rates to
lbs_ibss_join_existing() and made it to return on overflow.

However, the aforementioned commit doesn't set the return value accordingly
and thus, lbs_ibss_join_existing() would return with zero even though it
failed.

Make lbs_ibss_join_existing return -EINVAL in case the bounds check on the
number of supplied rates fails.

Fixes: e5e884b42639 ("libertas: Fix two buffer overflows at parsing bss descriptor")
Signed-off-by: Nicolai Stange <nstange@suse.de>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/libertas/cfg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/marvell/libertas/cfg.c b/drivers/net/wireless/marvell/libertas/cfg.c
index 68985d7663491..4e3de684928bf 100644
--- a/drivers/net/wireless/marvell/libertas/cfg.c
+++ b/drivers/net/wireless/marvell/libertas/cfg.c
@@ -1786,6 +1786,7 @@ static int lbs_ibss_join_existing(struct lbs_private *priv,
 		if (rates_max > MAX_RATES) {
 			lbs_deb_join("invalid rates");
 			rcu_read_unlock();
+			ret = -EINVAL;
 			goto out;
 		}
 		rates = cmd.bss.rates;
-- 
2.20.1



