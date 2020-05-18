Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7873C1D86D3
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:28:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731022AbgERS2Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:28:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:40514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729005AbgERRnL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:43:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81D8D20835;
        Mon, 18 May 2020 17:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823791;
        bh=HTvCiCacoig81YMwJ45KDFRvX3U18f9IXR+DcRXlePE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KO7KFgqJMillacUs/ajWS/N2JE4j7ktF9ElAgWQRVZ+Tl7h6+/DT5AEBG4XkgA/Xn
         4vAKN/2r17DT8d6EfgLoEEo8jnSuyiL58TnVOetl4G/Lgv0MN/xb6cbtM8ZUAIviGk
         UnnHITXK0McPFC+KNplQFHsSUrfIyyENpMWi96XY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 38/90] ptp: Fix pass zero to ERR_PTR() in ptp_clock_register
Date:   Mon, 18 May 2020 19:36:16 +0200
Message-Id: <20200518173458.838117489@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

commit aea0a897af9e44c258e8ab9296fad417f1bc063a upstream.

Fix smatch warning:

drivers/ptp/ptp_clock.c:298 ptp_clock_register() warn:
 passing zero to 'ERR_PTR'

'err' should be set while device_create_with_groups and
pps_register_source fails

Fixes: 85a66e550195 ("ptp: create "pins" together with the rest of attributes")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben.hutchings@codethink.co.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_clock.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index d5ac33350889e..b87b7b0867a4c 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -222,8 +222,10 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 	ptp->dev = device_create_with_groups(ptp_class, parent, ptp->devid,
 					     ptp, ptp->pin_attr_groups,
 					     "ptp%d", ptp->index);
-	if (IS_ERR(ptp->dev))
+	if (IS_ERR(ptp->dev)) {
+		err = PTR_ERR(ptp->dev);
 		goto no_device;
+	}
 
 	/* Register a new PPS source. */
 	if (info->pps) {
@@ -234,6 +236,7 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 		pps.owner = info->owner;
 		ptp->pps_source = pps_register_source(&pps, PTP_PPS_DEFAULTS);
 		if (!ptp->pps_source) {
+			err = -EINVAL;
 			pr_err("failed to register pps source\n");
 			goto no_pps;
 		}
-- 
2.20.1



