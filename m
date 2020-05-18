Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C8D61D873C
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbgERRjY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:39:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728747AbgERRjY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:39:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1079B2086A;
        Mon, 18 May 2020 17:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823563;
        bh=JcOJWFHBiOMUh474qYFCAv5ejV4BXihCIBZRpJjND1E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NFPlR1h8rnE+2Ku5/JrPqtuelxNEp4k1Cleu9yNqOa7cdXaBJQAFPmG6AktI7MsNZ
         LPsC1gEiMQaZnfXwW2erjOa3f5p35kYwBsZXGqV+z+5ea3bohvGhqnGQ12LWDcBBaf
         GlL7+p3Undm7xqquaG/oSSFb0OLjUMrqnPiJeHPc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>
Subject: [PATCH 4.4 32/86] ptp: Fix pass zero to ERR_PTR() in ptp_clock_register
Date:   Mon, 18 May 2020 19:36:03 +0200
Message-Id: <20200518173457.047846228@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.254571947@linuxfoundation.org>
References: <20200518173450.254571947@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ptp/ptp_clock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -222,8 +222,10 @@ struct ptp_clock *ptp_clock_register(str
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
@@ -234,6 +236,7 @@ struct ptp_clock *ptp_clock_register(str
 		pps.owner = info->owner;
 		ptp->pps_source = pps_register_source(&pps, PTP_PPS_DEFAULTS);
 		if (!ptp->pps_source) {
+			err = -EINVAL;
 			pr_err("failed to register pps source\n");
 			goto no_pps;
 		}


