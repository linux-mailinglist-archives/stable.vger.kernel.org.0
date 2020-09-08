Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6F02261AA7
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbgIHSia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:38:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:53536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731320AbgIHQJA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:09:00 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B49824053;
        Tue,  8 Sep 2020 15:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599580108;
        bh=pTmyHVYbSXnA+BdUOOxYUNHxES5DQpQjSmwTw2AziGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eUtI3dSSCNEdiCDb4RojO042YOsaVLRCtLRLlh+l5wGSvisZ8PmsjSXv9e9kCs/Gs
         580Js7xm4IwOmvZ1kAGlRUBA7PKC8v3NdPWcfctgMId+lvMUCDgrFcdgY41FVhFfCc
         ps9rgtmzFlKLA0QjMzhjdFRugLnVkWqs4GM5MAek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Smith <msmith626@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 34/88] bnxt_en: fix HWRM error when querying VF temperature
Date:   Tue,  8 Sep 2020 17:25:35 +0200
Message-Id: <20200908152222.792503974@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152221.082184905@linuxfoundation.org>
References: <20200908152221.082184905@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

[ Upstream commit 12cce90b934bf2b0ed9c339b4d5503e69954351a ]

Firmware returns RESOURCE_ACCESS_DENIED for HWRM_TEMP_MONITORY_QUERY for
VFs. This produces unpleasing error messages in the log when temp1_input
is queried via the hwmon sysfs interface from a VF.

The error is harmless and expected, so silence it and return unknown as
the value. Since the device temperature is not particularly sensitive
information, provide flexibility to change this policy in future by
silencing the error rather than avoiding the HWRM call entirely for VFs.

Fixes: cde49a42a9bb ("bnxt_en: Add hwmon sysfs support to read temperature")
Cc: Marc Smith <msmith626@gmail.com>
Reported-by: Marc Smith <msmith626@gmail.com>
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 7047f4237ceaf..df3514503dee9 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6836,16 +6836,19 @@ static ssize_t bnxt_show_temp(struct device *dev,
 	struct hwrm_temp_monitor_query_input req = {0};
 	struct hwrm_temp_monitor_query_output *resp;
 	struct bnxt *bp = dev_get_drvdata(dev);
-	u32 temp = 0;
+	u32 len = 0;
 
 	resp = bp->hwrm_cmd_resp_addr;
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_TEMP_MONITOR_QUERY, -1, -1);
 	mutex_lock(&bp->hwrm_cmd_lock);
-	if (!_hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT))
-		temp = resp->temp * 1000; /* display millidegree */
+	if (!_hwrm_send_message_silent(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT))
+		len = sprintf(buf, "%u\n", resp->temp * 1000); /* display millidegree */
 	mutex_unlock(&bp->hwrm_cmd_lock);
 
-	return sprintf(buf, "%u\n", temp);
+	if (len)
+		return len;
+
+	return sprintf(buf, "unknown\n");
 }
 static SENSOR_DEVICE_ATTR(temp1_input, 0444, bnxt_show_temp, NULL, 0);
 
-- 
2.25.1



