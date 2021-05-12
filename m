Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C54B37C272
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbhELPKr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:10:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:35268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233264AbhELPIJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:08:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07B9461490;
        Wed, 12 May 2021 15:01:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831704;
        bh=gi0c7hMzFESUY+6ztc91Q4rdHUKaKWCbFsxjHzz6eaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IaISJL50yaNjS09r0efSj0sm4wvGLfCTKhvfctqUqCjECcryM52M3b7n25DQpU0Z4
         1DItvBuXFLPAAORzbqZ78T41E7iBVMKzbaMCW+QN2lpWopf1wk88PaxEEgpaYc0qeW
         /Yqhmk88ochFQe+JcNjCT+0IkbtsdiUwx5/5HccY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 225/244] bnxt_en: fix ternary sign extension bug in bnxt_show_temp()
Date:   Wed, 12 May 2021 16:49:56 +0200
Message-Id: <20210512144750.200355938@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 27537929f30d3136a71ef29db56127a33c92dad7 ]

The problem is that bnxt_show_temp() returns long but "rc" is an int
and "len" is a u32.  With ternary operations the type promotion is quite
tricky.  The negative "rc" is first promoted to u32 and then to long so
it ends up being a high positive value instead of a a negative as we
intended.

Fix this by removing the ternary.

Fixes: d69753fa1ecb ("bnxt_en: return proper error codes in bnxt_show_temp")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 5a7831a97a13..04386e4078de 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8954,7 +8954,9 @@ static ssize_t bnxt_show_temp(struct device *dev,
 	if (!rc)
 		len = sprintf(buf, "%u\n", resp->temp * 1000); /* display millidegree */
 	mutex_unlock(&bp->hwrm_cmd_lock);
-	return rc ?: len;
+	if (rc)
+		return rc;
+	return len;
 }
 static SENSOR_DEVICE_ATTR(temp1_input, 0444, bnxt_show_temp, NULL, 0);
 
-- 
2.30.2



