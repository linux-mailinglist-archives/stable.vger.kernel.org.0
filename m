Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E004125A2
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384133AbhITSql (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:46:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:59878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1383440AbhITSoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:44:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB3CC61AF7;
        Mon, 20 Sep 2021 17:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159170;
        bh=xmOalj1X7W0gV9J62wTmVJJ+9Tn7bwTmKErqAg6smwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uqFuAdwKC6bqw/CSGmHCPiwnVox3Ph9K4VYG96A7uUatVefHh7YulpDcJNAdlKT8b
         0DhxP4t6lX3kXu0ZcwxG9DsKw7aoIGIAEyp4oDrg7ZiMKD9t0XGwTMvgNjYkgMeeZt
         0yEij4nNiEvJGaOdy+lIjRo6SCVl2Aw5nuDCF4bA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Smadar Fuks <smadarf@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 109/168] octeontx2-af: Add additional register check to rvu_poll_reg()
Date:   Mon, 20 Sep 2021 18:44:07 +0200
Message-Id: <20210920163925.220037225@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Smadar Fuks <smadarf@marvell.com>

[ Upstream commit 21274aa1781941884599a97ab59be7f8f36af98c ]

Check one more time before exiting the API with an error.
Fix API to poll at least twice, in case there are other high priority
tasks and this API doesn't get CPU cycles for multiple jiffies update.

In addition, increase timeout from usecs_to_jiffies(10000) to
usecs_to_jiffies(20000), to prevent the case that for CONFIG_100HZ
timeout will be a single jiffies.
A single jiffies results actual timeout that can be any time between
1usec and 10msec. To solve this, a value of usecs_to_jiffies(20000)
ensures that timeout is 2 jiffies.

Signed-off-by: Smadar Fuks <smadarf@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 5fe277e354f7..c10cae78e79f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -92,7 +92,8 @@ static void rvu_setup_hw_capabilities(struct rvu *rvu)
  */
 int rvu_poll_reg(struct rvu *rvu, u64 block, u64 offset, u64 mask, bool zero)
 {
-	unsigned long timeout = jiffies + usecs_to_jiffies(10000);
+	unsigned long timeout = jiffies + usecs_to_jiffies(20000);
+	bool twice = false;
 	void __iomem *reg;
 	u64 reg_val;
 
@@ -107,6 +108,15 @@ again:
 		usleep_range(1, 5);
 		goto again;
 	}
+	/* In scenarios where CPU is scheduled out before checking
+	 * 'time_before' (above) and gets scheduled in such that
+	 * jiffies are beyond timeout value, then check again if HW is
+	 * done with the operation in the meantime.
+	 */
+	if (!twice) {
+		twice = true;
+		goto again;
+	}
 	return -EBUSY;
 }
 
-- 
2.30.2



