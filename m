Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6674527880F
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728794AbgIYMwT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:52:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729304AbgIYMwS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:52:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 533272072E;
        Fri, 25 Sep 2020 12:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038337;
        bh=n3jCyH8EyUMXwneybjNkSGX4H4KQmmZxBtGBwnf0QXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kxPOk1ftHIQ6ryknELEy7CuaYkiNa92/mm1KBfSHF1d64Y3J4wR0CwzdijuZttGO7
         35rDiZ1VRrfVhRHeb77Rtj3WpqfvgCs9/1V5XC7nUey0REcsOeGIHkZANRNmMkdBqG
         TdzifDTOBsq5fQu8q5qe68lB96F3OyMzLOMunSxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 32/43] bnxt_en: return proper error codes in bnxt_show_temp
Date:   Fri, 25 Sep 2020 14:48:44 +0200
Message-Id: <20200925124728.418626868@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Edwin Peer <edwin.peer@broadcom.com>

[ Upstream commit d69753fa1ecb3218b56b022722f7a5822735b876 ]

Returning "unknown" as a temperature value violates the hwmon interface
rules. Appropriate error codes should be returned via device_attribute
show instead. These will ultimately be propagated to the user via the
file system interface.

In addition to the corrected error handling, it is an even better idea to
not present the sensor in sysfs at all if it is known that the read will
definitely fail. Given that temp1_input is currently the only sensor
reported, ensure no hwmon registration if TEMP_MONITOR_QUERY is not
supported or if it will fail due to access permissions. Something smarter
may be needed if and when other sensors are added.

Fixes: 12cce90b934b ("bnxt_en: fix HWRM error when querying VF temperature")
Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -8939,18 +8939,16 @@ static ssize_t bnxt_show_temp(struct dev
 	struct hwrm_temp_monitor_query_output *resp;
 	struct bnxt *bp = dev_get_drvdata(dev);
 	u32 len = 0;
+	int rc;
 
 	resp = bp->hwrm_cmd_resp_addr;
 	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_TEMP_MONITOR_QUERY, -1, -1);
 	mutex_lock(&bp->hwrm_cmd_lock);
-	if (!_hwrm_send_message_silent(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT))
+	rc = _hwrm_send_message(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (!rc)
 		len = sprintf(buf, "%u\n", resp->temp * 1000); /* display millidegree */
 	mutex_unlock(&bp->hwrm_cmd_lock);
-
-	if (len)
-		return len;
-
-	return sprintf(buf, "unknown\n");
+	return rc ?: len;
 }
 static SENSOR_DEVICE_ATTR(temp1_input, 0444, bnxt_show_temp, NULL, 0);
 
@@ -8970,7 +8968,16 @@ static void bnxt_hwmon_close(struct bnxt
 
 static void bnxt_hwmon_open(struct bnxt *bp)
 {
+	struct hwrm_temp_monitor_query_input req = {0};
 	struct pci_dev *pdev = bp->pdev;
+	int rc;
+
+	bnxt_hwrm_cmd_hdr_init(bp, &req, HWRM_TEMP_MONITOR_QUERY, -1, -1);
+	rc = hwrm_send_message_silent(bp, &req, sizeof(req), HWRM_CMD_TIMEOUT);
+	if (rc == -EACCES || rc == -EOPNOTSUPP) {
+		bnxt_hwmon_close(bp);
+		return;
+	}
 
 	if (bp->hwmon_dev)
 		return;


