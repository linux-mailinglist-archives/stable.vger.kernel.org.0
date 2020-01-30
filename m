Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD2C814E1FE
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 19:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731529AbgA3Ss1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 13:48:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:59464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731553AbgA3Ss1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jan 2020 13:48:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72DFF2082E;
        Thu, 30 Jan 2020 18:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580410106;
        bh=99BtX/pBn3r/H1nNWbh9nCTgSnUF/ehvAdurJE7FIyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bkj7JTn52yWQbBt90+yPnsUO+LZPbwnXwxJ+tAo7gIRC8p/Utsg3eCip+8ZSAnjYZ
         GSKM4FV5bpy2nRiMA3ZsfBPQHCEml84M+DPx9r/GEvKEFAriLyMlt80G0EduLCf+Qq
         lRHzyc0WEeaLXi0A7QmfHPTavKn52XopD2rf1/XA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4.19 12/55] staging: vt6656: Fix false Tx excessive retries reporting.
Date:   Thu, 30 Jan 2020 19:38:53 +0100
Message-Id: <20200130183611.067371290@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
References: <20200130183608.563083888@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Malcolm Priestley <tvboxspy@gmail.com>

commit 9dd631fa99dc0a0dfbd191173bf355ba30ea786a upstream.

The driver reporting  IEEE80211_TX_STAT_ACK is not being handled
correctly. The driver should only report on TSR_TMO flag is not
set indicating no transmission errors and when not IEEE80211_TX_CTL_NO_ACK
is being requested.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Link: https://lore.kernel.org/r/340f1f7f-c310-dca5-476f-abc059b9cd97@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/vt6656/int.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/staging/vt6656/int.c
+++ b/drivers/staging/vt6656/int.c
@@ -97,9 +97,11 @@ static int vnt_int_report_rate(struct vn
 
 	info->status.rates[0].count = tx_retry;
 
-	if (!(tsr & (TSR_TMO | TSR_RETRYTMO))) {
+	if (!(tsr & TSR_TMO)) {
 		info->status.rates[0].idx = idx;
-		info->flags |= IEEE80211_TX_STAT_ACK;
+
+		if (!(info->flags & IEEE80211_TX_CTL_NO_ACK))
+			info->flags |= IEEE80211_TX_STAT_ACK;
 	}
 
 	ieee80211_tx_status_irqsafe(priv->hw, context->skb);


