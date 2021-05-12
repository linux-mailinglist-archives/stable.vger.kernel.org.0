Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4A2037CEB0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345104AbhELRGG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:06:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:41520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238022AbhELQtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:49:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F0FA961C6C;
        Wed, 12 May 2021 16:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836167;
        bh=SN+WfQXYMiKaVpd/a21Ml4AXzRRyQBTeeFcIS57t+m0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L2L0ot7GPwdsF36WgS6CTWz3R3wdVjnr5S7fH3XuKpbzvLtdZ3YOcRETveVkRVS6S
         XL0vBshRuO7P8qRs2Iyy095vEgfmuCRGlOvcco5/R9o0pdQDFiFHTt6ctoM+4sFiHA
         3I7QPE4aUiLZrCkPGWOWLi+SQSrE1ksbfMyLWGAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 636/677] bnxt_en: fix ternary sign extension bug in bnxt_show_temp()
Date:   Wed, 12 May 2021 16:51:22 +0200
Message-Id: <20210512144858.492148761@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index b53a0d87371a..aeb8c61c0f87 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9736,7 +9736,9 @@ static ssize_t bnxt_show_temp(struct device *dev,
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



